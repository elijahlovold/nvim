local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
vim.keymap.set('n', '<leader>pa', function()
    local word = vim.fn.expand('<cword>')  -- Get the word under the cursor
    builtin.grep_string({ search = word })  -- Use the word in the grep search
end)
