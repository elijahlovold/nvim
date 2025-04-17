local gs = require('gitsigns')

gs.setup {
    on_attach = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', 'gl', function()
            if vim.wo.diff then
                vim.cmd.normal({'gl', bang = true})
            else
                gs.nav_hunk('next')
            end
        end)
        map('n', 'gh', function()
            if vim.wo.diff then
                vim.cmd.normal({'gh', bang = true})
            else
                gs.nav_hunk('prev')
            end
        end)

        -- Actions
        map('n', '<leader>gs', gs.stage_hunk)
        map('n', '<leader>gr', gs.reset_hunk)

        map('v', '<leader>gs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        map('v', '<leader>gr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('n', '<leader>gS', gs.stage_buffer)
        map('n', '<leader>gR', gs.reset_buffer)
        map('n', '<leader>gU', gs.reset_buffer_index)
        map('n', '<leader>gp', gs.preview_hunk)
        map('n', '<leader>gi', gs.preview_hunk_inline)

        map('n', '<leader>gB', function()
            gs.blame_line({ full = true })
        end)

        map('n', '<leader>gd', gs.diffthis)
        map('n', '<leader>gD', function()
            vim.ui.input({ prompt = 'Diff against branch/revision: ' }, gs.diffthis)
        end)

        map('n', '<leader>gQ', function() gs.setqflist('all') end)
        map('n', '<leader>gq', gs.setqflist)
    end,
}

-- navigate changed files --
local function index_of(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then return i end
    end
    return nil
end
--
-- Get the repo root directory
local function get_git_root()
  local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  return root or ""
end

-- Get list of changed files via Git (porcelain output)
local function get_changed_files()
    local output = vim.fn.systemlist("git status --porcelain")
    local files = {}

    -- strip heading of porcelain output and insert into table
    for _, line in ipairs(output) do
        local filename = line:sub(4)
        table.insert(files, filename)
    end

    return files
end

-- Jump to next/previous changed file
local function jump_to_changed_file(next)
    local files = get_changed_files()
    if #files == 0 then return end

    local current = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
    local index = index_of(files, current)

    local next_index
    if index then
        if next then
            next_index = (index % #files) + 1
        else
            next_index = (index - 2 + #files) % #files + 1
        end
    else
        next_index = 1
    end

    vim.notify("(" .. next_index .. " of " .. #files .. "): " .. files[next_index])

    -- translate to git root
    local git_root = get_git_root()
    local abs_file = vim.fn.fnamemodify(git_root .. "/" .. files[next_index], ":p")
    vim.cmd("edit " .. abs_file)
end

-- Bind gj to next changed file, gk to previous
vim.keymap.set('n', 'gj', function() jump_to_changed_file(true) end, { desc = "Next changed file" })
vim.keymap.set('n', 'gk', function() jump_to_changed_file(false) end, { desc = "Previous changed file" })

-- git blame
vim.keymap.set('n', 'gb', ':Git blame<CR>', { desc = "Fugitive: Git blame" })
vim.keymap.set("n", "<leader>gf", vim.cmd.Git)
