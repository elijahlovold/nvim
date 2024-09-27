
function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#070d26" })  -- Black with 70% opacity

    vim.api.nvim_set_hl(0, "String", { fg = "#8FF492" })
    vim.api.nvim_set_hl(0, "Type", { fg = "#00FF00" })  -- Replace with your desired hex code
end

ColorMyPencils()
