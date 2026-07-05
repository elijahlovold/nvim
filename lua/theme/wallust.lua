local ok, c = pcall(require, "theme.wallust-colors")
if not ok then
  return false
end

local function apply()
  vim.cmd.colorscheme("default")
  vim.cmd("set background=dark")

  local hl = vim.api.nvim_set_hl

  -- GENERAL --
  hl(0, "Normal", { bg = "none", fg = c.fg })
  hl(0, "NormalNC", { bg = c.bg, fg = c.fg })

  hl(0, "Directory", { fg = c.blue, bold = true })
  hl(0, "ColorColumn", { bg = c.black })
  hl(0, "String", { fg = c.green })
  hl(0, "Number", { fg = c.magenta })

  -- MARKDOWN --
  -- headings
  hl(0, "RenderMarkdownH1",   { fg = c.fg, bold = true })
  hl(0, "RenderMarkdownH2",   { fg = c.fg, bold = true })
  hl(0, "RenderMarkdownH3",   { fg = c.fg, bold = true })
  hl(0, "RenderMarkdownH4",   { fg = c.fg, bold = true })
  hl(0, "RenderMarkdownH5",   { fg = c.fg, bold = true })
  hl(0, "RenderMarkdownH6",   { fg = c.fg, bold = true })

  -- heading backgrounds (important for visual structure)
  hl(0, "RenderMarkdownH1Bg", { bg = c.blue })
  hl(0, "RenderMarkdownH2Bg", { bg = c.cyan })
  hl(0, "RenderMarkdownH3Bg", { bg = c.megenta })
  hl(0, "RenderMarkdownH4Bg", { bg = c.yellow })
  hl(0, "RenderMarkdownH5Bg", { bg = c.green })
  hl(0, "RenderMarkdownH6Bg", { bg = c.red })

  -- quotes (should not be static anymore)
  hl(0, "RenderMarkdownQuote", { fg = c.yellow, italic = true })

  -- code blocks (important consistency point)
  hl(0, "RenderMarkdownCode", { bg = c.black })
  hl(0, "RenderMarkdownCodeInline", { fg = c.green, bg = c.black })

  -- call outs (semantic mapping)
  hl(0, "RenderMarkdownWarn",   { fg = c.yellow })
  hl(0, "RenderMarkdownError",  { fg = c.red })
  hl(0, "RenderMarkdownInfo",   { fg = c.blue })
  hl(0, "RenderMarkdownHint",   { fg = c.cyan })

  -- lists
  hl(0, "RenderMarkdownBullet", { fg = c.blue })

  -- links
  hl(0, "RenderMarkdownLink", { fg = c.magenta, underline = true })


  -- PROGRAMMING --
  -- parameters
  hl(0, "@variable.parameter", { fg = c.bright_cyan, italic = true, })

  -- #define, constexpr, etc
  hl(0, "Define", { fg = c.bright_blue, bold = true, })
  hl(0, "@constant", { fg = c.white, bold = true, })

  -- function names
  hl(0, "Function", { fg = c.bright_white, })

  -- preprocessor directives
  hl(0, "PreProc", { fg = c.bright_cyan, bold = true, })

  -- self, this, _G, etc
  hl(0, "@variable.builtin", { fg = c.white, italic = true, })

  -- member variables: foo.bar, this->bar
  hl(0, "@variable.member", { fg = c.bright_blue, })

  -- fields in structs/classes
  hl(0, "@property", { fg = c.bright_blue, })

  -- parameters
  hl(0, "@variable.parameter", { fg = c.bright_cyan, italic = true, })

  -- globals / namespace vars
  hl(0, "@variable.builtin", { fg = c.white, italic = true, })

  hl(0, "@string.documentation", { link = "String", })

  -- control-flow keywords
  hl(0, "@keyword", { fg = c.fg, bold = true, })
  hl(0, "@keyword.conditional", { fg = c.white, bold = true, })
  hl(0, "@keyword.repeat", { fg = c.white, bold = true, })
  hl(0, "@keyword.return", { fg = c.bright_cyan, bold = true, })
  hl(0, "@keyword.function", { fg = c.bright_blue, bold = true, })
  hl(0, "@keyword.operator", { fg = c.bright_cyan, })
  hl(0, "@keyword.import", { fg = c.bright_blue, bold = true, })
  hl(0, "@type", { fg = c.white, })
  hl(0, "@type.builtin", { fg = c.bright_white, bold = true, })

end

apply()

-- fs_event trigger (watch wallust palette dir from config root)
local path = vim.fn.stdpath("config") .. "/lua/theme/wallust-colors.lua"

local watcher = vim.loop.new_fs_event()

watcher:start(path, {}, vim.schedule_wrap(function()
  package.loaded["theme.wallust-colors"] = nil
  c = require("theme.wallust-colors")
  apply()
end))

return true
