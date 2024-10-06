local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

vim.keymap.set('n', '<leader>pf', function()
  builtin.find_files({
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<A-j>', require('telescope.actions').move_selection_next)
      map('i', '<A-k>', require('telescope.actions').move_selection_previous)
      return true
    end
  })
end)

vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({
    search = vim.fn.input("Grep > "),
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<A-j>', require('telescope.actions').move_selection_next)
      map('i', '<A-k>', require('telescope.actions').move_selection_previous)

      return true
    end
  })
end)

vim.keymap.set('n', '<leader>pa', function()
  builtin.grep_string({
    search = vim.fn.expand('<cword>'),  -- Get the word under the cursor
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<A-j>', require('telescope.actions').move_selection_next)
      map('i', '<A-k>', require('telescope.actions').move_selection_previous)

      return true
    end
  })
end)

