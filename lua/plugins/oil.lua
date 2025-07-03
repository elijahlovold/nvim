return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require('oil')

    oil.setup({

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

    vim.keymap.set("n", "<leader>f", function()
      local entry = oil.get_cursor_entry()
      if entry then
        local filepath = oil.get_current_dir() .. entry.name
        vim.fn.jobstart({ "sxiv", filepath }, { detach = true })
      end
    end, { desc = "Open single file with sxiv" })

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

      vim.fn.jobstart(vim.list_extend({ "sxiv", "-t" }, selected), { detach = true })
    end, { desc = "Open selected files with sxiv" })
  end
}
