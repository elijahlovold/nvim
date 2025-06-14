-- Directory where the run commands will be saved (single JSON file for all projects)
local run_command_file = vim.fn.stdpath('data') .. '/run_commands.json'

-- Table to store run commands in memory
local run_commands_cache = {}

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
