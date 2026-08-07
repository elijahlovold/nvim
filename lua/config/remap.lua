vim.g.mapleader = " "

-- Map Alt + hjkl to navigate windows
vim.keymap.set('n', '<A-h>', '<C-w>h', { noremap = true, silent = true })  -- Move left
vim.keymap.set('n', '<A-j>', '<C-w>j', { noremap = true, silent = true })  -- Move down
vim.keymap.set('n', '<A-k>', '<C-w>k', { noremap = true, silent = true })  -- Move up
vim.keymap.set('n', '<A-l>', '<C-w>l', { noremap = true, silent = true })  -- Move right

-- remaps when entering commands
vim.cmd('cnoremap <A-j> <Down>')
vim.cmd('cnoremap <A-k> <Up>')

vim.keymap.set("n", "<leader>pwd", "<cmd>echo expand('%:p')<CR>")

vim.keymap.set("n", "<leader>R", ":vsplit | terminal<CR>i", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "<A-j>", "<Down>", { noremap = true, silent = true })
vim.keymap.set("t", "<A-k>", "<Up>", { noremap = true, silent = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")

-- custom matching groups
vim.keymap.set({ "x", "o" }, "i*", function() vim.cmd([[normal! T*vt*]]) end)
vim.keymap.set({ "x", "o" }, "a*", function() vim.cmd([[normal! F*vf*]]) end)
--

vim.keymap.set("n", "<leader>P", [[viwP]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("v", "<C-x>", [[:s/, /,\r/g<CR>]])
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set('n', '<leader>z', '1z=', { noremap = true, silent = true })

vim.keymap.set("n", "<C-l>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-h>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("i", "<C-.>", "<Tab>", { noremap = true, silent = true })

-- toggle controls
vim.keymap.set('n', '<leader>tc', function()
  if vim.wo.colorcolumn == "" then
    vim.wo.colorcolumn = "80"  -- Set to 80 if not set
  else
    vim.wo.colorcolumn = ""    -- Clear if it's set
  end
end, { noremap = true, silent = true })

-- some quick common dirs
vim.keymap.set('n', '<leader>/h', ':Oil ~/<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>/r', ':Oil ~/repos<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>/c', ':Oil ~/.config<CR>', { noremap = true, silent = true })

-- title case
vim.keymap.set("v", "<leader>u", "<cmd>s/\\<./\\l&/g<CR><Esc>")
vim.keymap.set("v", "<leader>U", "<cmd>s/\\<./\\u&/g<CR><Esc>")

-- open in alacritty
vim.keymap.set("n", "<leader>oa", function()
  local dir = vim.fn.expand("%:p:h")
  vim.fn.jobstart({ "alacritty", "--working-directory", dir })
end, { silent = true })


-- alternative browser opening
vim.keymap.set("n", "<leader>gx", function()
    local url = vim.fn.expand("<cfile>")
    vim.fn.jobstart(
        { "google-chrome", url },
        { detach = true }
    )
end, { desc = "Open URL in Chrome" })

-- search with firefox
vim.keymap.set("v", "<leader>fx", function()
  local s = vim.fn.getpos("v")
  local e = vim.fn.getpos(".")

  local lines = vim.fn.getline(s[2], e[2])

  lines[#lines] = string.sub(lines[#lines], 1, e[3])
  lines[1] = string.sub(lines[1], s[3])

  local selection = table.concat(lines, "\n")
  selection = selection:gsub("^%s+", ""):gsub("%s+$", "")

  vim.fn.system({ "firefox", "--search", selection })
end)


vim.keymap.set('n', '<leader>tw', function()
  if vim.o.textwidth == 0 then
    vim.o.textwidth = 80
    vim.o.formatoptions = vim.o.formatoptions .. 't'
    print("Auto-wrap: ON (80 cols)")
  else
    vim.o.textwidth = 0
    vim.o.formatoptions = vim.o.formatoptions:gsub('t', '')
    print("Auto-wrap: OFF")
  end
end, { desc = "Toggle text wrap at 80 cols" })

-- Create a function to toggle wrap and remap j/k
vim.keymap.set('n', '<leader>w', function()
  -- Check if line wrap is currently enabled
  local wrap_enabled = vim.wo.wrap

  if wrap_enabled then
    -- If wrap is enabled, disable it and restore default behavior for j/k
    vim.wo.wrap = false
    vim.keymap.del('n', 'j')  -- Remove gj remap
    vim.keymap.del('v', 'j')  -- Remove gj remap

    vim.keymap.del('n', 'k')  -- Remove gk remap
    vim.keymap.del('v', 'k')  -- Remove gk remap

    vim.keymap.del('n', '0')
    vim.keymap.del('v', '0')

    vim.keymap.del('n', '$')
    vim.keymap.del('v', '$')
  else
    -- If wrap is disabled, enable wrap and remap j/k to gj/gk
    vim.wo.wrap = true
    vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true })
    vim.keymap.set('v', 'j', 'gj', { noremap = true, silent = true })

    vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true })
    vim.keymap.set('v', 'k', 'gk', { noremap = true, silent = true })

    vim.keymap.set('n', '0', 'g0', { noremap = true, silent = true })
    vim.keymap.set('v', '0', 'g0', { noremap = true, silent = true })

    vim.keymap.set('n', '$', 'g$', { noremap = true, silent = true })
    vim.keymap.set('v', '$', 'g$', { noremap = true, silent = true })
  end
end)

vim.keymap.set("v", "<leader>et", function()
    print("timed")
    local buf = 0
    local s = vim.fn.getpos("'<")
    local e = vim.fn.getpos("'>")

    local sr = s[2] - 1
    local er = e[2] - 1

    local indent = string.match(vim.api.nvim_buf_get_lines(buf, sr, sr+1, false)[1], "^%s*") or ""

    local before = {
        indent .. "import time",
        indent .. "t0 = time.perf_counter()",
    }

    local after = {
        indent .. "print(time.perf_counter() - t0)",
    }

    vim.api.nvim_buf_set_text(buf, er+1, 0, er+1, 0, after)
    vim.api.nvim_buf_set_text(buf, sr, 0, sr, 0, before)
end)

local function files_in_buffer_dir()
  local dir = vim.fn.expand("%:p:h")
  local files = vim.fn.glob(dir .. "/*", false, true)

  files = vim.tbl_filter(function(f)
    return vim.fn.isdirectory(f) == 0
  end, files)

  table.sort(files)

  for i, f in ipairs(files) do
    files[i] = vim.fn.resolve(f)
  end

  return files
end

local function next_file(delta)
  local files = files_in_buffer_dir()
  local current = vim.fn.resolve(vim.fn.expand("%:p"))

  for i, f in ipairs(files) do
    if f == current then
      local next_i = i + delta

      if next_i >= 1 and next_i <= #files then
        vim.cmd("edit " .. vim.fn.fnameescape(files[next_i]))
      end

      return
    end
  end
end

vim.keymap.set("n", "<M-ScrollWheelUp>", function()
  next_file(-1)
end)

vim.keymap.set("n", "<M-ScrollWheelDown>", function()
  next_file(1)
end)
