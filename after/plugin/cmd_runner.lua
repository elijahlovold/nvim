-- Directory where the run commands will be saved (single JSON file for all projects)
local run_command_file = vim.fn.stdpath('data') .. '/run_commands.json'

-- Table to store run commands in memory
local run_commands_cache = {}

local buf = nil

-- Function to load the run command JSON into memory (only once per session)
local function load_run_commands()
  if vim.fn.filereadable(run_command_file) == 1 then
    local json_data = vim.fn.readfile(run_command_file)
    run_commands_cache = vim.fn.json_decode(table.concat(json_data, "\n"))
  end
end

-- Function to save all run commands to the JSON file (updates the file when needed)
local function save_run_commands()
  local json_data = vim.fn.json_encode(run_commands_cache)
  vim.fn.writefile(vim.fn.split(json_data, "\n"), run_command_file)
end

-- Function to get the current directory's project key (directory path as key)
local function get_project_key()
  return vim.fn.getcwd()  -- The current working directory
end

-- Function to load the run command for the current project from the in-memory cache
local function load_run_command()
  local project_key = get_project_key()
  return run_commands_cache[project_key]
end

-- Function to save the run command for the current project to the in-memory cache
local function save_run_command(command)
  local project_key = get_project_key()
  run_commands_cache[project_key] = command
  save_run_commands()  -- Write the updated data back to the JSON file
end

local function set_run_command()
  vim.ui.input({
    prompt = "Enter run command: ",
    default = load_run_command(),  -- Use the previous command if available
  }, function(input)
    if input then
      save_run_command(input)  -- Save the command to the project in the in-memory cache
      print("Run command saved: " .. input)
    end
  end)  -- This ends the function passed to vim.ui.input
end

-- Function to run the stored command for the current project
local function run_stored_command()
  local command = load_run_command()
  if command then
    vim.cmd("terminal " .. command)
  else
    print("No run command found for this project.")
  end
end

-- Load run commands when entering the project directory
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    load_run_commands()  -- Load the run commands from the JSON file only once at the start
  end,
})

-- Keybindings
vim.keymap.set("n", "<leader>r", run_stored_command, { noremap = true, silent = true })  -- Run saved command
vim.keymap.set("n", "<leader><C-r>", set_run_command, { noremap = true, silent = true })  -- Set run command




-- -- Get project key (based on current working directory)
-- local function get_project_key()
--     return vim.fn.getcwd()
-- end

-- -- Load all project commands from JSON file (only once per session)
-- local function load_run_commands()
--     if vim.fn.filereadable(run_command_file) == 1 then
--         local json_data = vim.fn.readfile(run_command_file)
--         run_commands_cache = vim.fn.json_decode(table.concat(json_data, "\n")) or {}
--     end
-- end

-- -- Save all project commands to JSON file
-- local function save_run_commands()
--     local json_data = vim.fn.json_encode(run_commands_cache)
--     vim.fn.writefile(vim.fn.split(json_data, "\n"), run_command_file)
-- end

-- -- Get commands for the current project
-- local function load_project_commands()
--     return run_commands_cache[get_project_key()] or {}
-- end

-- -- Save commands for the current project
-- local function save_project_commands(commands)
--     run_commands_cache[get_project_key()] = commands
--     save_run_commands()
-- end

-- -- Open a buffer to edit commands
-- local function edit_run_commands()
--     if not buf then
--         buf = vim.api.nvim_create_buf(false, true)
--         vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")
--         vim.api.nvim_buf_set_name(buf, "Run Commands")
--     end

--     local win = vim.api.nvim_open_win(buf, true, {
--         relative = "editor",
--         width = math.floor(vim.o.columns * 0.6),
--         height = math.floor(vim.o.lines * 0.2),
--         row = math.floor(vim.o.lines * 0.2),
--         col = math.floor(vim.o.columns * 0.2),
--         border = "rounded",
--     })

--     local commands = load_project_commands()

--     local lines = {}
--     for key, cmd in pairs(commands) do
--         table.insert(lines, key .. " : " .. cmd)
--     end

--     vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

--     -- Save commands when buffer is written (:w)
--     vim.api.nvim_create_autocmd("BufWriteCmd", {
--         buffer = buf,
--         callback = function()
--             local new_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
--             local new_commands = {}

--             for _, line in ipairs(new_lines) do
--                 local key, cmd = line:match("^(%S+)%s*:%s*(.+)$")
--                 if key and cmd then
--                     print("adding key: ", key, " cmd: ", cmd)
--                     new_commands[key] = cmd
--                 end
--             end

--             save_project_commands(new_commands)
--             print("Run commands saved.")
--         end,
--     })
-- end

-- -- Run a command by key
-- local function run_command_by_key()
--     local commands = load_project_commands()
--     local keys = vim.tbl_keys(commands)

--     if #keys == 0 then
--         print("No commands set for this project.")
--         return
--     end

--     vim.ui.select(keys, { prompt = "Select a command to run:" }, function(choice)
--         if choice then
--             vim.cmd("vsplit | terminal " .. commands[choice])
--         end
--     end)
-- end

-- -- Load run commands once per session
-- vim.api.nvim_create_autocmd("VimEnter", { pattern = "*", callback = load_run_commands })

-- -- Keybindings
-- vim.keymap.set("n", "<leader>re", edit_run_commands, { noremap = true, silent = true })  -- Edit commands
-- vim.keymap.set("n", "<leader>rr", run_command_by_key, { noremap = true, silent = true }) 
