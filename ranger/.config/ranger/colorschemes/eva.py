"""EVA colour scheme for ranger.

Reads ~/.config/hypr/themes/current/colors.css (the file eva-theme switches) every time
ranger starts, so it follows nerv, unit01 and blue without being regenerated. Colours are
mapped to the nearest xterm-256 entry, because ranger draws with curses.
"""
import os
import re

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import default, normal, bold, reverse, default_colors  # noqa: F401

CSS = os.path.expanduser("~/.config/hypr/themes/current/colors.css")
FALLBACK = {"base": "#0b0b0f", "surface0": "#1c1c24", "surface1": "#2a2a33", "text": "#e6e6ea",
            "dim": "#8a8a99", "accent": "#e5322d", "accent2": "#ff8c1a", "c1": "#abbcda",
            "c2": "#9d6ff0", "good": "#9be564", "warn": "#ff8c1a", "bad": "#e5322d"}


def _xterm(hexc):
    r, g, b = (int(hexc[i:i + 2], 16) for i in (1, 3, 5))
    steps = [0, 95, 135, 175, 215, 255]
    q = lambda v: min(range(6), key=lambda i: abs(steps[i] - v))  # noqa: E731
    ci = (q(r), q(g), q(b))
    cube = 16 + 36 * ci[0] + 6 * ci[1] + ci[2]
    cd = sum((steps[c] - v) ** 2 for c, v in zip(ci, (r, g, b)))
    gi = min(range(24), key=lambda i: abs(8 + 10 * i - (r + g + b) / 3))
    gv = 8 + 10 * gi
    gd = sum((gv - v) ** 2 for v in (r, g, b))
    return cube if cd <= gd else 232 + gi


def _palette():
    pal = dict(FALLBACK)
    try:
        with open(CSS) as f:
            for name, hexc in re.findall(r"@define-color\s+(\w+)\s+(#[0-9a-fA-F]{6})", f.read()):
                pal[name] = hexc
    except OSError:
        pass
    return {k: _xterm(v) for k, v in pal.items()}


P = _palette()


class Eva(ColorScheme):
    progress_bar_color = P["accent"]

    def use(self, context):
        fg, bg, attr = default_colors
        if context.reset:
            return default_colors
        if context.in_browser:
            if context.selected:
                attr = reverse
            if context.empty or context.error:
                fg = P["bad"]
            if context.border:
                fg = P["surface1"]
            if context.media:
                fg = P["c2"] if context.image else P["c1"]
            if context.container:
                fg = P["warn"]
            if context.directory:
                attr |= bold
                fg = P["accent"]
            elif context.executable and not any((context.media, context.container, context.fifo, context.socket)):
                attr |= bold
                fg = P["good"]
            if context.socket or context.fifo or context.device:
                fg = P["c2"]
                attr |= bold
            if context.link:
                fg = P["c1"] if context.good else P["bad"]
            if context.tag_marker and not context.selected:
                attr |= bold
                fg = P["accent2"]
            if not context.selected and (context.cut or context.copied):
                fg = P["dim"]
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = P["accent2"]
            if context.badinfo:
                fg = P["bad"] if attr & reverse else fg
            if context.inactive_pane:
                fg = P["dim"]
        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = P["bad"] if context.bad else P["accent"]
            elif context.directory:
                fg = P["accent2"]
            elif context.tab:
                if context.good:
                    bg, fg = P["accent"], P["base"]
            elif context.link:
                fg = P["c1"]
        elif context.in_statusbar:
            if context.permissions:
                fg = P["good"] if context.good else P["bad"] if context.bad else fg
            if context.marked:
                attr |= bold | reverse
                fg = P["accent2"]
            if context.frozen:
                attr |= bold | reverse
                fg = P["c1"]
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = P["bad"]
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = P["c1"]
                attr &= ~bold
            if context.vcscommit:
                fg = P["accent2"]
                attr &= ~bold
            if context.vcsdate:
                fg = P["dim"]
                attr &= ~bold
        if context.text and context.highlight:
            attr |= reverse
        if context.in_taskview:
            if context.title:
                fg = P["accent"]
            if context.selected:
                attr |= reverse
            if context.loaded:
                bg = self.progress_bar_color if not context.selected else fg
        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = P["bad"]
            elif context.vcschanged:
                fg = P["warn"]
            elif context.vcsunknown:
                fg = P["dim"]
            elif context.vcsstaged or context.vcssync:
                fg = P["good"]
            elif context.vcsignored:
                fg = P["surface1"]
        elif context.vcsremote and not context.selected:
            attr &= ~bold
            fg = P["good"] if (context.vcssync or context.vcsnone) else P["warn"]
        return fg, bg, attr
