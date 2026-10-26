return {
  'lewis6991/gitsigns.nvim',
  config = function()
    local gs = require('gitsigns')

    gs.setup {
      signs = {},
      numhl = true,
      -- sign_priority = 20,
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

    -- Changed files under the repo at `root`, relative to it. -uall lists
    -- untracked files one by one instead of collapsing them to "dir/"
    -- (recursing into those re-ran the same status forever), and -z keeps
    -- paths unquoted. Only real repos (a .git inside) are recursed into.
    local function get_changed_files(root)
      local out = vim.system({ "git", "-C", root, "status", "--porcelain", "-z", "-uall" }):wait().stdout or ""
      local entries = vim.split(out, "\0", { plain = true, trimempty = true })
      local files = {}

      local i = 1
      while i <= #entries do
        local status, filename = entries[i]:sub(1, 2), entries[i]:sub(4)
        -- renames/copies are followed by the old path; skip it
        if status:find("[RC]") then i = i + 1 end
        i = i + 1

        local abs = root .. "/" .. filename
        if vim.uv.fs_stat(abs .. "/.git") then
          for _, v in ipairs(get_changed_files(abs)) do
            table.insert(files, filename .. "/" .. v)
          end
        elseif vim.uv.fs_stat(abs) then -- deleted files have nothing to open
          table.insert(files, filename)
        end
      end

      return files
    end

    -- Jump to next/previous changed file
    local function jump_to_changed_file(next)
      local git_root = get_git_root()
      if git_root == "" then return end
      local files = get_changed_files(git_root)
      if #files == 0 then return end

      -- match against root-relative paths, resolving symlinks on both sides
      local buf = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(0)) or ""
      local real_root = vim.uv.fs_realpath(git_root) or git_root
      local current = buf:sub(#real_root + 2)
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
      vim.cmd.edit(vim.fn.fnameescape(git_root .. "/" .. files[next_index]))
    end

    -- Bind gj to next changed file, gk to previous
    vim.keymap.set('n', 'gj', function() jump_to_changed_file(true) end, { desc = "Next changed file" })
    vim.keymap.set('n', 'gk', function() jump_to_changed_file(false) end, { desc = "Previous changed file" })

    -- git blame
    vim.keymap.set('n', 'gb', ':Git blame<CR>', { desc = "Fugitive: Git blame" })
    vim.keymap.set("n", "<leader>gf", vim.cmd.Git)
  end
}
