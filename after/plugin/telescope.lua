local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pg', builtin.git_files, {})

local function find_files()
    builtin.find_files({
        file_ignore_patterns = {
            "%.rst$",
            "%.png$",
            "%.jpeg$",
            "%.raw$",
        },
        -- no_ignore = true,
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<A-j>', require('telescope.actions').move_selection_next)
            map('i', '<A-k>', require('telescope.actions').move_selection_previous)
            return true
        end
    })
end

vim.keymap.set('n', '<C-k>', find_files)
vim.keymap.set('n', '<leader>pf', find_files)

-- vim.keymap.set('n', '<leader>ps', function()
--   local telescope = require('telescope.builtin')
--   local actions = require('telescope.actions')
--   local action_state = require('telescope.actions.state')

--   telescope.live_grep({
--     attach_mappings = function(prompt_bufnr, map)
--       -- Map Ctrl-q to send results to the quickfix list
--       map('i', '<C-q>', function()
--         actions.send_selected_to_qflist({prompt_bufnr})
--         actions.close(prompt_bufnr) -- Close Telescope
--         vim.cmd('copen') -- Open the quickfix list
--       end)
--       return true
--     end,
--   })
-- end, { noremap = true, silent = true })

-- Function to prompt for file type and perform a live_grep search in the specified file type
vim.keymap.set('n', '<leader>pd', function()
    -- Prompt for file type (e.g., .cpp, .hpp)
    vim.ui.input({ prompt = 'Enter file type (e.g., .cpp, .hpp): ' }, function(filetype)
        if filetype then
            local glob_args = {}
            for ftype in string.gmatch(filetype, '([^,]+)') do
                ftype = ftype:gsub("^%s+", "")  -- Remove leading whitespace

                if not ftype:match('^%*') then
                    ftype = '*' .. ftype  -- Add '*' only if not present
                end
                table.insert(glob_args, '--glob')
                table.insert(glob_args, ftype)
            end

            -- Call Telescope live_grep with custom vimgrep_arguments including the file type filter
            builtin.live_grep({
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case',
                    unpack(glob_args),
                },
                -- no_ignore = true,
                attach_mappings = function(prompt_bufnr, map)
                    map('i', '<A-j>', require('telescope.actions').move_selection_next)
                    map('i', '<A-k>', require('telescope.actions').move_selection_previous)

                    return true
                end
            })
        end
    end)
end)

vim.keymap.set('n', '<leader>ps', function()
    builtin.live_grep({
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            -- '--no-ignore'       -- Disable .gitignore and other ignore files
        },
        -- no_ignore = true,
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
        no_ignore = true,
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<A-j>', require('telescope.actions').move_selection_next)
            map('i', '<A-k>', require('telescope.actions').move_selection_previous)

            return true
        end
    })
end)

vim.keymap.set('n', '<leader>pb', function()
    builtin.buffers({
        no_ignore = true,
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<A-j>', require('telescope.actions').move_selection_next)
            map('i', '<A-k>', require('telescope.actions').move_selection_previous)

            return true
        end
    })
end)

vim.keymap.set('n', '<leader>ph', function()
    builtin.help_tags({
        no_ignore = true,
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<A-j>', require('telescope.actions').move_selection_next)
            map('i', '<A-k>', require('telescope.actions').move_selection_previous)

            return true
        end
    })
end)

