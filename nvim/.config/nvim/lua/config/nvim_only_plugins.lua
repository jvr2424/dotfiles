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
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
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

            vim.keymap.set("n", "<space>fd", function()
              require('telescope.builtin').find_files({ follow = true })
            end)

            vim.keymap.set("n", "<space>fg", require('config.telescope_multirg'))
        end,
    },
    -- lsp support
    { 'neovim/nvim-lspconfig' },
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
