
function ColorMyPencils(color)
	color = color or "tokyonight"
	vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#070d26" })  -- Black with 70% opacity

    vim.api.nvim_set_hl(0, "String", { fg = "#8FF492" })
    vim.api.nvim_set_hl(0, "Number", { fg = "#8179ed" })
    vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#58c4d7" }) 
    vim.api.nvim_set_hl(0, "Define", { fg = "#1a54c7", bold = 1})
    vim.api.nvim_set_hl(0, "@constant", { link = "Define" })
    vim.api.nvim_set_hl(0, "Function", { fg = "#53c9a4" }) 
    vim.api.nvim_set_hl(0, "PreProc", { fg = "#996eff" }) 
end

ColorMyPencils()
