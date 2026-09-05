local M = {}

local home = vim.loop.os_homedir()
local vault = home .. "/vault"
local vault_tags = vault .. "/TAGS.md"

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
    local file = vim.fn.expand(vault_tags)
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

--------------------------------------------------------------------------------
-- goto or create
--------------------------------------------------------------------------------

-- extract the [[link]] target under the cursor, stripping any
-- |alias or #heading suffix. returns nil if the cursor isn't on a link.
local function get_wikilink_under_cursor()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] -- 0-indexed byte col

    local search_from = 1
    while true do
        local s, e, inner = line:find("%[%[(.-)%]%]", search_from)
        if not s then return nil end
        if col >= s - 1 and col < e then
            local name = inner:match("^[^|#]*") or inner
            name = vim.trim(name)
            return name ~= "" and name or nil
        end
        search_from = e + 1
    end
end

-- recursively collect directories under `root` (relative paths, "." = root),
-- skipping dotfolders like .git/.obsidian
local function list_vault_dirs(root)
    local dirs = { "." }
    local function scan(dir, rel)
        local handle = vim.loop.fs_scandir(dir)
        if not handle then return end
        while true do
            local name, ftype = vim.loop.fs_scandir_next(handle)
            if not name then break end
            if ftype == "directory" and not name:match("^%.") then
                local rel_path = rel == "" and name or (rel .. "/" .. name)
                table.insert(dirs, rel_path)
                scan(dir .. "/" .. name, rel_path)
            end
        end
    end
    scan(root, "")
    return dirs
end

local function create_note_and_open(dir_rel, name)
    local dir_path = dir_rel == "." and vault or (vault .. "/" .. dir_rel)
    vim.fn.mkdir(dir_path, "p")

    local file_path = dir_path .. "/" .. name .. ".md"
    if vim.fn.filereadable(file_path) == 0 then
        vim.fn.writefile({}, file_path)
    end
    vim.cmd("edit " .. vim.fn.fnameescape(file_path))
end

-- fuzzy-find style directory picker: <CR> confirms, <Esc> cancels the
local function prompt_create_note(name)
    local dirs = list_vault_dirs(vault)

    require('telescope.pickers').new({}, {
        prompt_title = string.format("Create '%s.md' in...", name),
        finder = require('telescope.finders').new_table {
            results = dirs,
            entry_maker = function(dir)
                return {
                    value = dir,
                    display = dir == "." and "(vault root)" or dir,
                    ordinal = dir,
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
                if not selection then return end
                create_note_and_open(selection.value, name)
            end)
            return true
        end,
    }):find()
end

-- go to definition for a markdown-oxide link; if it doesn't resolve,
-- offer to create the missing note instead of just failing silently.
function M.goto_definition_or_create()
    local bufnr = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()

    local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "markdown_oxide" })
    if #clients == 0 then
        return vim.lsp.buf.definition()
    end

    vim.lsp.buf_request_all(bufnr, "textDocument/definition", function(client)
        return vim.lsp.util.make_position_params(win, client.offset_encoding)
    end, function(results)
        local all_items = {}
        for client_id, res in pairs(results) do
            local client = vim.lsp.get_client_by_id(client_id)
            if client and res and res.result then
                local locations = vim.islist(res.result) and res.result or { res.result }
                vim.list_extend(all_items, vim.lsp.util.locations_to_items(locations, client.offset_encoding))
            end
        end

        if not vim.tbl_isempty(all_items) then
            if #all_items == 1 then
                local item = all_items[1]
                vim.cmd("normal! m'")
                vim.cmd("edit " .. vim.fn.fnameescape(item.filename))
                vim.api.nvim_win_set_cursor(0, { item.lnum, math.max(item.col - 1, 0) })
            else
                vim.fn.setqflist({}, ' ', { title = "LSP locations", items = all_items })
                vim.cmd("botright copen")
            end
            return
        end

        local link_name = get_wikilink_under_cursor()
        if not link_name then
            vim.notify("markdown-oxide: no definition found", vim.log.levels.INFO)
            return
        end
        prompt_create_note(link_name)
    end)
end

-- own our 'gd' override end-to-end: detect markdown_oxide attaching and
-- rebind gd ourselves, deferred via vim.schedule so we always win the race
-- against any other LspAttach handler (e.g. a generic one in lsp.lua) that
-- sets 'gd' for every filetype, regardless of autocmd registration order.
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client or client.name ~= "markdown_oxide" then return end

        vim.schedule(function()
            vim.keymap.set('n', 'gd', M.goto_definition_or_create, {
                buffer = ev.buf,
                desc = "Go to definition, or create the note if missing",
            })
        end)
    end,
})

return M
