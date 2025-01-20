require("oil").setup({
  -- Correct structure
  view_options = {
    show_hidden = true,  -- Show hidden files like netrw
    show_filesystem = true,  -- Show filesystem
  },
  default_file_explorer = true,
  
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
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>")
