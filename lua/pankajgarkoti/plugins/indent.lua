local setup, ibl = pcall(require, "ibl")

if not setup then
	print("ibl not found!")
	return
end

ibl.setup({})
