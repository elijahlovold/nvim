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

-- function to grab tags from the vault location, respecting nested indentation.
-- each returned entry is { path = {"electronics", "power design", "linear"}, breadcrumb = "electronics > power design > linear" }
-- so that selecting a nested tag can also surface its ancestors.
local function get_tags()
    local paths = require("config.paths")
    local file = vim.fn.expand(paths.vault_tags)
    local lines = vim.fn.readfile(file)

    local tags = {}
    local stack = {} -- {indent = N, name = "..."}
    for _, line in ipairs(lines) do
        local indent, name = line:match("^(%s*)%- (.+)$")
        if name then
            name = name:gsub("%s+$", "")
            while #stack > 0 and stack[#stack].indent >= #indent do
                table.remove(stack)
            end
            table.insert(stack, { indent = #indent, name = name })

            local path = {}
            for _, entry in ipairs(stack) do
                table.insert(path, entry.name)
            end
            table.insert(tags, { path = path, breadcrumb = table.concat(path, " > ") })
        end
    end

    return tags
end

-- tag picker
vim.keymap.set('i', '<C-y>', function()
    local tags = get_tags()
    local cursor_indent = vim.api.nvim_get_current_line():match("^%s*")
    require('telescope.pickers').new({}, {
        prompt_title = "Select tag",
        finder = require('telescope.finders').new_table {
            results = tags,
            entry_maker = function(tag)
                return {
                    value = tag,
                    display = tag.breadcrumb,
                    ordinal = tag.breadcrumb,
                }
            end,
        },
        sorter = require('telescope.config').values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                local out_lines = {}
                for i, name in ipairs(selection.value.path) do
                    local prefix = i == 1 and "" or cursor_indent
                    table.insert(out_lines, prefix .. "- " .. name)
                end

                vim.api.nvim_put(out_lines, 'c', true, true)
                vim.cmd('startinsert!')
            end)
            return true
        end
    }):find()
end, { desc = "Pick tag" })
