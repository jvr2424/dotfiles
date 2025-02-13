-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
return {
    {
        "folke/tokyonight.nvim",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        'echasnovski/mini.pairs',
        version = false,
        config = function()
            require("mini.pairs").setup()
            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },
    {
        'echasnovski/mini.snippets',
        version = false,
        config = function()
            require("mini.snippets").setup()
            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
        end,
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        -- ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        event = {
            -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
            -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
            "BufReadPre /Users/joeracaniello/Documents/ObsidianNotes/**.md",
            "BufNewFile /Users/joeracaniello/Documents/ObsidianNotes/**.md",
        },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
        opts = {
            workspaces = {
                {
                    name = "ObsidianNotes",
                    path = "/Users/joeracaniello/Documents/ObsidianNotes",
                },
            },

            -- see below for full list of options 👇
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        -- event = { "LazyFile", "VeryLazy" },
    },
    {
        'ThePrimeagen/harpoon',
        version = false,
        config = function()
            require("harpoon").setup()

            vim.keymap.set("n", "<leader>hx", require("harpoon.mark").add_file)
            vim.keymap.set("n", "<leader>hn", require("harpoon.ui").nav_next)
            vim.keymap.set("n", "<leader>hp", require("harpoon.ui").nav_prev)

            vim.keymap.set("n", "<leader>hj", function() require("harpoon.ui").nav_file(1) end)
            vim.keymap.set("n", "<leader>hk", function() require("harpoon.ui").nav_file(2) end)
            vim.keymap.set("n", "<leader>hl", function() require("harpoon.ui").nav_file(3) end)
            vim.keymap.set("n", "<leader>h;", function() require("harpoon.ui").nav_file(4) end)

            -- vim.keymap.set("n", "<leader>hm", "<cmd>Telescope harpoon marks<CR>")
            vim.keymap.set("n", "<leader>hm", require("harpoon.ui").toggle_quick_menu)

            -- vim.keymap.set("n", "<C-h>", function() require("harpoon").list().select(1) end)
            -- vim.keymap.set("n", "<C-t>", function() require("harpoon").list().select(2) end)
            -- vim.keymap.set("n", "<C-n>", function() require("harpoon").list().select(3) end)
            -- vim.keymap.set("n", "<C-s>", function() require("harpoon").list().select(4) end)
            -- vim.keymap.set("n", "<leader><C-h>", function() require("harpoon").list().replace_at(1) end)
            -- vim.keymap.set("n", "<leader><C-t>", function() require("harpoon").list().replace_at(2) end)
            -- vim.keymap.set("n", "<leader><C-n>", function() require("harpoon").list().replace_at(3) end)
            -- vim.keymap.set("n", "<leader><C-s>", function() require("harpoon").list().replace_at(4) end)
        end,

    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
        },
        config = function()
            require('telescope').setup {
                extensions = {
                    fzf = {}
                }
            }

            require('telescope').load_extension('fzf')
            require('telescope').load_extension('harpoon')

            vim.keymap.set("n", "<space>fd", function()
                require('telescope.builtin').find_files({ follow = true })
            end)

            vim.keymap.set("n", "<space>fg", require('config.telescope_multirg'))
        end,
    },
    -- lsp support
    {
        'neovim/nvim-lspconfig',
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local c = vim.lsp.get_client_by_id(args.data.client_id)
                    if not c then return end

                    if c.supports_method('textDocumet/formatting') then
                        -- Format the current buffer on save
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
                            end,
                        })
                    end
                end,
            })
        end,

    },
    { 'hrsh7th/cmp-nvim-lsp' },
    { -- do read the installation section in the readme of nvim-cmp!
        "hrsh7th/nvim-cmp",
        main = "cmp",
        dependencies = { "abeldekat/cmp-mini-snippets" }, -- this plugin
        event = "InsertEnter",
        opts = function()
            local cmp = require("cmp")
            return {
                snippet = {
                    expand = function(args) -- mini.snippets expands snippets from lsp...
                        local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
                        insert({ body = args.body }) -- Insert at cursor
                        cmp.resubscribe({ "TextChangedI", "TextChangedP" })
                        require("cmp.config").set_onetime({ sources = {} })
                    end,
                },
                sources = cmp.config.sources({ { name = "mini_snippets" } }),
                mapping = cmp.mapping.preset.insert(), -- more opts...
            }
        end,
    },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
}
