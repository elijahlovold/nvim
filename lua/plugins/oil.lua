return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "malewicz1337/oil-git.nvim" },
  config = function()
    local oil = require('oil')

    oil.setup({
      columns = {
        "icon",
        -- {"mtime", highlight="OilMtime", },
      },
        -- EXPERIMENTAL support for performing file operations with git
        -- Return true to automatically git add/mv/rm files
      git = {
        -- add = function(path) return true end,
        mv = function(src_path, dest_path) return true end,
        -- rm = function(path) return true end,
      },

      -- Correct structure
      view_options = {
        show_hidden = true,  -- Show hidden files like netrw
        show_filesystem = true,  -- Show filesystem
      },

      icons = true,

      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,

      -- Configuration for the file preview window
      preview_win = {
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
        -- How to open the preview window "load"|"scratch"|"fast_scratch"
        preview_method = "fast_scratch",
        -- A function that returns true to disable preview on a file e.g. to avoid lag
        disable_preview = function(filename)
          return false
        end,
        -- Window-local options to use for preview window buffers
        win_options = {},
      },
      preview_split = "left",
    })

    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

    local show_mtime = false

    local function refresh_oil_buffers()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "oil" then
          vim.api.nvim_buf_call(buf, function()
            require("oil.actions").refresh.callback()
          end)
        end
      end
    end

    vim.keymap.set("n", "<leader>tt", function()
        show_mtime = not show_mtime

        require("oil.config").columns = show_mtime and {
            "icon", { "mtime", highlight = "OilMtime" },
        } or { "icon", }

        refresh_oil_buffers()
    end, { desc = "Toggle oil mtime column" })

    vim.keymap.set("n", "<leader>o", function()
        local dir = oil.get_current_dir()

        if not dir then
            dir = vim.fn.expand("%:p:h")
        end

        vim.fn.jobstart({"kitty", "-e", "yazi", dir, }, { detach = true, })
    end)

    vim.keymap.set("n", "<leader>y", function()
      local entry = oil.get_cursor_entry()
      if not entry then return end

      local dir = oil.get_current_dir()
      local fullpath = dir .. entry.name

      local resolved = vim.fn.fnamemodify(fullpath, ":p")

      vim.fn.setreg("+", resolved)
    end)

    vim.keymap.set("v", "<leader>f", function()
      local dir = oil.get_current_dir()
      local buf = vim.api.nvim_get_current_buf()

      local start_line = vim.fn.line("v") - 1
      local end_line = vim.fn.line(".") - 1
      if start_line > end_line then
        start_line, end_line = end_line, start_line
      end
      local selected = {}
      for i = start_line, end_line do
        local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)[1]
        if line and not vim.startswith(line, "  ..") then
          -- Extract file name (strip icons, whitespace)
          local name = line:match("([^%s]+%..+)$")
          if name then
            table.insert(selected, dir .. name)
          end
        end
      end

      vim.fn.jobstart(vim.list_extend({ "nsxiv", "-t" }, selected), { detach = true })
    end, { desc = "Open selected files with sxiv" })

    require("oil-git").setup({
      debounce_ms = 50,
      show_file_highlights = true,
      show_directory_highlights = false,
      show_file_symbols = true,
      show_directory_symbols = true,
      show_ignored_files = false,       -- Show ignored file status
      show_ignored_directories = false, -- Show ignored directory status

      symbol_position = "oel",  -- "eol", "signcolumn", or "none"
      can_use_signcolumn = nil,

      ignore_gitsigns_update = false,   -- Ignore GitSignsUpdate events (fallback for flickering)
      debug = false,            -- false, "minimal", or "verbose"

      symbols = {
        file = { added = "+", modified = "~", renamed = "->", deleted = "D",
                 copied = "C", conflict = "!", untracked = "?", ignored = "o" },
        directory = { added = "*", modified = "*", renamed = "*", deleted = "*",
                      copied = "*", conflict = "!", untracked = "*", ignored = "o" },
      },

      -- Colors (only applied if highlight groups don't exist)
      highlights = {
        OilGitAdded = { fg = "#a6e3a1" },
        OilGitModifiedStaged = { fg = "#9a83f7" },
        OilGitModifiedUnstaged = { fg = "#83b7f7" },
        OilGitRenamed = { fg = "#cba6f7" },
        OilGitDeleted = { fg = "#490cb2" },
        OilGitCopied = { fg = "#cba6f7" },
        OilGitConflict = { fg = "#fab387" },
        OilGitUntracked = { fg = "#3eadc9" },
        OilGitIgnored = { fg = "#6c7086" },
      },
    })
  end
}
