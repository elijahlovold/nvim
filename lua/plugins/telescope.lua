return {
  'nvim-telescope/telescope.nvim',

  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = vim.fn.executable("make") == 1,
    },
  },

  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local actions = require('telescope.actions')

    local rg_args = { "rg",
      "--color=never", "--no-heading", "--with-filename",
      "--line-number", "--column", "--smart-case",
    }

    local rga_args = { "rga",
      "--color=never", "--no-heading", "--with-filename",
      "--line-number", "--column", "--smart-case",
    }

    -- ~-~-~-~-~-~-~-~-~-~ setup ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

    telescope.setup({
      defaults = {
        vimgrep_arguments = rg_args,

        mappings = {
          i = {
            ["<A-j>"] = actions.move_selection_next,
            ["<A-k>"] = actions.move_selection_previous,

            ["<C-q>"] = actions.smart_send_to_qflist
            + actions.open_qflist,

            ["<C-j>"] = actions.preview_scrolling_down,
            ["<C-k>"] = actions.preview_scrolling_up,
          },

          n = {
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,

            ["q"] = actions.close,

            ["<C-q>"] = actions.smart_send_to_qflist
            + actions.open_qflist,
          },
        },
      },

      pickers = {
        find_files = {
          hidden = true,

          file_ignore_patterns = {
            "%.rst$",
            "%.png$",
            "%.jpe?g$",
            "%.raw$",
          },
        },

        buffers = {
          sort_mru = true,
          ignore_current_buffer = true,

          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },

        current_buffer_fuzzy_find = {
          previewer = false,
        },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    -- ~-~-~-~-~-~-~-~-~-~ functions ~-~-~-~-~-~-~-~-~-~-~-~-~-

    pcall(telescope.load_extension, "fzf")

    local function grep_no_ignore()
        local args = vim.deepcopy(rg_args)
        vim.list_extend(args, { "--no-ignore" })
        builtin.live_grep({
          prompt_title = "Live Grep --no-ignore",
          vimgrep_arguments = args,
        })
    end

    local function grep_extensions()
      vim.ui.input({
        prompt = "Extensions: ",
      }, function(input)
        if not input or input == "" then
          return
        end

        local args = vim.deepcopy(rg_args)

        for extension in input:gmatch("[^,]+") do
          extension = vim.trim(extension)

          if extension ~= "" then
            extension = extension:gsub("^%*?%.?", "")
            vim.list_extend(args, {
              "--glob",
              "*." .. extension,
            })
          end
        end

        builtin.live_grep({
          prompt_title = "Grep by extension",
          vimgrep_arguments = args,
        })
      end)
    end

    local function grep_documents()
      builtin.live_grep({
        prompt_title = "Search documents with rga",
        vimgrep_arguments = rga_args,
      })
    end

    local function grep_word()
      builtin.grep_string({
        search = vim.fn.expand("<cword>"),
      })
    end

    local function grep_visual()
      local previous_register = vim.fn.getreg('"')
      local previous_register_type = vim.fn.getregtype('"')

      vim.cmd('normal! ""y')

      local selection = vim.fn.getreg('"')
      vim.fn.setreg('"', previous_register, previous_register_type)

      builtin.grep_string({
        search = selection,
      })
    end

   local function map(lhs, rhs, description, modes)
      vim.keymap.set(
        modes or "n",
        lhs,
        rhs,
        { desc = "Telescope: " .. description }
      )
    end

    -- ~-~-~-~-~-~-~-~-~-~ mappings -~-~-~-~-~-~-~-~-~-~-~-~-~-

    map("<C-k>", builtin.find_files, "files")
    map("<leader>pf", builtin.find_files, "files")
    map("<leader>pg", builtin.git_files, "Git files")

    map("<leader>ps", builtin.live_grep, "live grep")
    map("<leader>pS", grep_no_ignore, "live grep, no ignores")
    map("<leader>pd", grep_extensions, "grep extensions")
    map("<leader>pD", grep_documents, "grep documents")
    map("<leader>pa", grep_word, "grep cursor word")
    map("<leader>pa", grep_visual, "grep selection", "x")

    map("<leader>pu", builtin.current_buffer_fuzzy_find, "current buffer")
    map("<leader>pb", builtin.buffers, "buffers")
    map("<leader>ph", builtin.help_tags, "help tags")

    map("<leader>pk", builtin.keymaps, "keymaps")
    map("<leader>pc", builtin.commands, "commands")
    map("<leader>pr", builtin.oldfiles, "recent files")
    map("<leader>pj", builtin.jumplist, "jump list")
    map("<leader>pl", builtin.resume, "resume last picker")
    map("<leader>pp", builtin.builtin, "available pickers")

    map("<leader>pe", builtin.diagnostics, "diagnostics")
    map("<leader>pq", builtin.quickfix, "quickfix list")

    map("<leader>pG", builtin.git_status, "Git status")
    map("<leader>pC", builtin.git_commits, "Git commits")
    map("<leader>pB", builtin.git_branches, "Git branches")

    map("<leader>pm", builtin.marks, "marks")
    map("<leader>p/", builtin.search_history, "search history")
    map("<leader>p:", builtin.command_history, "command history")

    map("grr", builtin.lsp_references, "LSP references")
    map("<leader>py", builtin.lsp_document_symbols, "document symbols")
    map("<leader>pY", builtin.lsp_dynamic_workspace_symbols, "workspace symbols")
    map("<leader>pi", builtin.lsp_implementations, "implementations")
    map("<leader>pt", builtin.lsp_type_definitions, "type definitions")
  end,
}
