return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-mini/mini.nvim",
        {
            "3rd/image.nvim",
            enabled = vim.env.KITTY_WINDOW_ID ~= nil,
            opts = {
                backend = "kitty",
                integrations = {
                    markdown = {
                        enabled = true,
                        clear_in_insert_mode = false,
                        download_remote_images = true,
                        only_render_image_at_cursor = false,
                        floating_windows = false,
                        filetypes = { "markdown", "vimwiki" },
                    },
                },
                max_width = 100,
                max_height = 24,
                max_width_window_percentage = math.huge,
                max_height_window_percentage = 50,
                kitty_method = "normal",
            },
        },
    },
    opts = {},
    config = function()
        require("render-markdown").setup({
            bullet = {
                icons = { '', '', '◆', '◇' },
            },
            checkbox = {
                bullet = true,
                left_pad = 1,
            },
            link = {
                custom = {
                    edu = { pattern = '%.edu', icon = '󰑴 ' },
                },

            },
            code = {
                border = 'thin'
            },

            -- Enables image.nvim integration
            render_modes = true,
        })
    end,
}
