"""eva_layer: optional gtk4-layer-shell support for the eva-* pickers and the MAGI panels.

Imported by eva-wifi, eva-bluetooth, magi and magi-overview (it sits next to them, so
Python finds it through sys.path[0]). Without gtk4-layer-shell, or with EVA_NO_LAYER=1,
attach() returns None and the scripts stay plain floating windows placed by the
Hyprland window rules.

    import eva_layer
    eva_layer.preload()            # BEFORE `from gi.repository import Gtk`
    ...
    layer = eva_layer.attach(win, "eva-wifi", anchor="top right",
                             margins={"top": 6, "right": 6}, on_outside=hide)

Behaviour of an attached panel (Hyprland 0.57, tested):
- overlay layer, namespace = the app name (matched by hl.layer_rule in hyprland.lua);
- exclusive zone 0, so the compositor keeps it out of waybar's reserved strip;
- EXCLUSIVE keyboard while shown. ON_DEMAND is useless here: Hyprland refocuses the
  window under the pointer the moment the surface maps (follow_mouse), so the panel
  would never get the keyboard after a hotkey;
- since an exclusive panel can't lose focus to a click, a transparent "scrim" layer
  (top layer, full usable area, no keyboard) sits under it while it is shown and calls
  on_outside() when clicked: clicking anywhere else still closes the panel;
- release() hands the keyboard back (and hides the scrim) for dialogs the panel waits
  on, such as blueman's pairing prompt; grab() takes it again.
"""
import ctypes
import os

LIB = "libgtk4-layer-shell.so.0"
_preloaded = False
_L = None


def preload():
    """Load libgtk4-layer-shell before GTK pulls in libwayland-client.

    The library interposes on libwayland, so it has to be loaded first: this is the
    documented Python approach (examples/simple-example.py), in-process, so no LD_PRELOAD
    leaks into apps the panels launch."""
    global _preloaded
    if os.environ.get("EVA_NO_LAYER") == "1" or not os.environ.get("WAYLAND_DISPLAY"):
        return False
    try:
        ctypes.CDLL(LIB, mode=ctypes.RTLD_GLOBAL)
        _preloaded = True
    except OSError:
        pass
    return _preloaded


def module():
    """The Gtk4LayerShell module when usable on this display, else None."""
    global _L
    if _L is None:
        _L = False
        if _preloaded:
            try:
                import gi
                gi.require_version("Gtk4LayerShell", "1.0")
                from gi.repository import Gtk4LayerShell
                if Gtk4LayerShell.is_supported():
                    _L = Gtk4LayerShell
            except (ImportError, ValueError):
                pass
    return _L or None


# Not fully transparent: a window that renders nothing never commits a buffer, so the
# compositor never maps it. 1% black is invisible but keeps it mapped.
_SCRIM_CSS = "window.eva-scrim { background: rgba(0, 0, 0, 0.01); box-shadow: none; border: none; }"


class Panel:
    def __init__(self, L, win, namespace, anchor, margins, on_outside):
        from gi.repository import Gdk, Gtk
        self.L, self.win = L, win
        L.init_for_window(win)
        L.set_layer(win, L.Layer.OVERLAY)
        L.set_namespace(win, namespace)
        L.set_exclusive_zone(win, 0)
        for edge in anchor.split():
            L.set_anchor(win, getattr(L.Edge, edge.upper()), True)
        for edge, px in (margins or {}).items():
            L.set_margin(win, getattr(L.Edge, edge.upper()), px)
        L.set_keyboard_mode(win, L.KeyboardMode.EXCLUSIVE)

        self.scrim = None
        if on_outside:
            s = Gtk.Window(title=namespace + "-scrim")
            s.set_decorated(False)
            s.add_css_class("eva-scrim")
            L.init_for_window(s)
            L.set_layer(s, L.Layer.TOP)
            L.set_namespace(s, namespace + "-scrim")
            L.set_exclusive_zone(s, 0)
            for e in (L.Edge.TOP, L.Edge.BOTTOM, L.Edge.LEFT, L.Edge.RIGHT):
                L.set_anchor(s, e, True)
            L.set_keyboard_mode(s, L.KeyboardMode.NONE)
            click = Gtk.GestureClick(button=0)
            click.connect("pressed", lambda *_: on_outside())
            s.add_controller(click)
            prov = Gtk.CssProvider()
            prov.load_from_string(_SCRIM_CSS)
            Gtk.StyleContext.add_provider_for_display(
                Gdk.Display.get_default(), prov, Gtk.STYLE_PROVIDER_PRIORITY_USER + 10)
            self.scrim = s
            win.connect("map", lambda *_: self._scrim(True))
            win.connect("unmap", lambda *_: self._scrim(False))
        win.connect("unmap", lambda *_: L.set_keyboard_mode(win, L.KeyboardMode.EXCLUSIVE))

    def _scrim(self, on):
        if self.scrim is None:
            return
        if on:
            mon = self.L.get_monitor(self.win)
            self.L.set_monitor(self.scrim, mon)  # None = compositor's choice, same as the panel
            self.scrim.present()
        else:
            self.scrim.set_visible(False)

    def set_monitor(self, monitor):
        """Pin to a Gdk.Monitor (None: let the compositor pick the focused one)."""
        self.L.set_monitor(self.win, monitor)

    def release(self):
        """Let another window (a dialog this panel waits on) take the keyboard."""
        self.L.set_keyboard_mode(self.win, self.L.KeyboardMode.ON_DEMAND)
        self._scrim(False)

    def grab(self):
        self.L.set_keyboard_mode(self.win, self.L.KeyboardMode.EXCLUSIVE)
        if self.win.get_visible():
            self._scrim(True)


def attach(win, namespace, anchor="", margins=None, on_outside=None):
    """Make win a layer-shell overlay; None when layer shell isn't available."""
    L = module()
    if L is None:
        return None
    panel = Panel(L, win, namespace, anchor, margins, on_outside)
    if forced_monitor():  # testing: render on a given output (e.g. a headless one)
        panel.set_monitor(monitor_by_name(forced_monitor()))
    return panel


def forced_monitor():
    return os.environ.get("EVA_LAYER_MONITOR")


def monitor_by_name(name):
    """Gdk.Monitor for a connector name such as "eDP-1", or None."""
    from gi.repository import Gdk
    mons = Gdk.Display.get_default().get_monitors()
    for i in range(mons.get_n_items()):
        m = mons.get_item(i)
        if m.get_connector() == name:
            return m
    return None
