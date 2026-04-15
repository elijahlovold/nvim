-- create & jump to today's notes
vim.keymap.set("n", "<A-0>", function()
  -- run command and capture stdout
  local handle = io.popen("todays-notes")
  if not handle then return end

  local result = handle:read("*a")
  handle:close()
  local file = result:gsub("%s+$", "")

  if file ~= "" then
    vim.cmd("edit " .. vim.fn.fnameescape(file))
  end
end)

-- function to grab tags from the vault location
local function get_tags()
    local paths = require("config.paths")
    local file = vim.fn.expand(paths.vault_tags)
    local lines = vim.fn.readfile(file)

    local tags = {}
    local in_section = false

    for _, line in ipairs(lines) do
        -- read until we find the # Tags section
        if not in_section then
            if line:match("^# Tags") then
                in_section = true
            end
        else
            if line:match("^%- ") then
                local tag = line:gsub("^%- ", "")
                table.insert(tags, tag)
            end
        end
    end

    return tags
end

-- tag picker
vim.keymap.set('i', '<C-y>', function()
    local tags = get_tags()
    require('telescope.pickers').new({}, {
        prompt_title = "Select tag",
        finder = require('telescope.finders').new_table { results = tags },
        sorter = require('telescope.config').values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.api.nvim_put({selection[1]}, 'c', true, true)
                vim.cmd('startinsert!')
            end)
            return true
        end
    }):find()
end, { desc = "Pick tag" })
