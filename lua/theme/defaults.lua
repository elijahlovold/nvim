local M = {}

function M.set_default()
  vim.cmd.colorscheme("tokyonight")
  vim.cmd("set background=dark")

  vim.api.nvim_set_hl(0, "Directory", { fg = "#0037da", bold = true })
  vim.api.nvim_set_hl(0, "OilMtime", { fg = "#99a8bf", italic = true })

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "#070d26" })

  vim.api.nvim_set_hl(0, "String", { fg = "#8FF492" })
  vim.api.nvim_set_hl(0, "Number", { fg = "#8179ed" })
  vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#58c4d7" })
  vim.api.nvim_set_hl(0, "Define", { fg = "#1a54c7", bold = true })
  vim.api.nvim_set_hl(0, "@constant", { link = "Define" })
  vim.api.nvim_set_hl(0, "Function", { fg = "#53c9a4" })
  vim.api.nvim_set_hl(0, "PreProc", { fg = "#996eff" })
  vim.api.nvim_set_hl(0, "@variable.builtin", { fg = "#26c3fc" })
  vim.api.nvim_set_hl(0, "@string.documentation", { link = "String" })

  vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 0, bg = "#0f2d59" })
end

function M.set_print()
  vim.cmd.colorscheme("default")
  vim.cmd("set background=light")

  vim.api.nvim_set_hl(0, "Normal", { bg = "white", fg = "black" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "white", fg = "black" })
  vim.api.nvim_set_hl(0, "ColorColumn", {})
end

_G.SetDefaultColors = M.set_default
_G.SetPrintColors = M.set_print

return M
