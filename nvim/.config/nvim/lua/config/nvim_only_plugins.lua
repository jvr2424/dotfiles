-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
return {
    {
        "rockyzhang24/arctic.nvim",
        dependencies = { "rktjmp/lush.nvim" },
        name = "arctic",
        branch = "main",
        priority = 1000,
        config = function()
            vim.o.background = "dark"
            vim.cmd("colorscheme arctic")
        end
    },
    -- {
    --     'sainnhe/everforest',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         -- Optionally configure and load the colorscheme
    --         -- directly inside the plugin declaration.
    --         vim.o.background = "dark"
    --         vim.g.everforest_background = 'hard'
    --         vim.g.everforest_enable_italic = true
    --         vim.cmd.colorscheme('everforest')
    --     end
    -- },
    -- {
    --     "EdenEast/nightfox.nvim",
    --     priority = 1000,
    --     config = function()
    --         -- load the colorscheme here
    --         vim.o.background = "dark"
    --         vim.cmd([[colorscheme terafox]])
    --     end,
    -- },
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --         -- load the colorscheme here
    --         vim.cmd([[colorscheme tokyonight]])
    --     end,
    -- },
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
        event = (function()
            local obsidian_dir = os.getenv("OBSIDIAN_DIR")
            if not obsidian_dir then
                return {}
            end
            return {
                "BufReadPre " .. obsidian_dir .. "/**.md",
                "BufNewFile " .. obsidian_dir .. "/**.md",
            }
        end)(),
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
        opts = {
            workspaces = {
                {
                    name = "ObsidianNotes",
                    path = os.getenv("OBSIDIAN_DIR") or "",
                },
            },

            -- see below for full list of options 👇
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main", -- config below uses the rewritten API, only on main (not master)
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        -- event = { "LazyFile", "VeryLazy" },
        config = function()
            require("nvim-treesitter").setup()
            local parsers = {
                "lua", "vim", "markdown", "markdown_inline",
                "html", "python", "javascript", "css", "bash", "toml", "yaml",
                "json", "sql",
            }
            local installed = require("nvim-treesitter.config").get_installed()
            local to_install = vim.tbl_filter(function(p)
                return not vim.tbl_contains(installed, p)
            end, parsers)
            if #to_install > 0 then
                require("nvim-treesitter").install(to_install)
            end
        end,
    },
    {
        "amas0/stan.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = "stan",
        config = function()
            -- nvim-treesitter main branch no longer manages highlighting;
            -- must enable it manually per filetype
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "stan",
                callback = function() vim.treesitter.start() end,
            })
        end,
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
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
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

                    if c.supports_method('textDocument/formatting') then
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
                    expand = function(args)          -- mini.snippets expands snippets from lsp...
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
    { 'williamboman/mason.nvim',           config = true },
    { 'williamboman/mason-lspconfig.nvim', config = true },
    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            local set = vim.keymap.set

            -- Add or skip cursor above/below the main cursor.
            set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
            set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)
            set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
            set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)

            -- Add or skip adding a new cursor by matching word/selection
            set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end)
            set({ "n", "x" }, "<leader>s", function() mc.matchSkipCursor(1) end)
            set({ "n", "x" }, "<leader>N", function() mc.matchAddCursor(-1) end)
            set({ "n", "x" }, "<leader>S", function() mc.matchSkipCursor(-1) end)

            -- Add and remove cursors with control + left click.
            set("n", "<c-leftmouse>", mc.handleMouse)
            set("n", "<c-leftdrag>", mc.handleMouseDrag)
            set("n", "<c-leftrelease>", mc.handleMouseRelease)

            -- Disable and enable cursors.
            set({ "n", "x" }, "<c-q>", mc.toggleCursor)

            -- Mappings defined in a keymap layer only apply when there are
            -- multiple cursors. This lets you have overlapping mappings.
            mc.addKeymapLayer(function(layerSet)
                -- Select a different cursor as the main one.
                layerSet({ "n", "x" }, "<left>", mc.prevCursor)
                layerSet({ "n", "x" }, "<right>", mc.nextCursor)

                -- Delete the main cursor.
                layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

                -- Enable and clear cursors using escape.
                layerSet("n", "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
                -- Enable and clear cursors using leader c.
                layerSet("n", "<leader>c", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)

            -- Customize how cursors look.
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { reverse = true })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn" })
            hl(0, "MultiCursorMatchPreview", { link = "Search" })
            hl(0, "MultiCursorDisabledCursor", { reverse = true })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
        end
    },
    {
        "apple/pkl-neovim",
        lazy = true,
        ft = "pkl",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter",
                build = function(_)
                    vim.cmd("TSUpdate")
                end,
            },
            "L3MON4D3/LuaSnip",
        },
        build = function()
            require('pkl-neovim').init()

            -- Set up syntax highlighting.
            vim.cmd("TSInstall pkl")
        end,
        config = function()
            -- Set up snippets.
            require("luasnip.loaders.from_snipmate").lazy_load()

            -- Configure pkl-lsp
            vim.g.pkl_neovim = {
                start_command = { "pkl-lsp" },
                pkl_cli_path = "pkl",
            }
        end,
    },
    {
        "ThePrimeagen/99",
        config = function()
            local _99 = require("99")

            -- For logging that is to a file if you wish to trace through requests
            -- for reporting bugs, i would not rely on this, but instead the provided
            -- logging mechanisms within 99.  This is for more debugging purposes
            local cwd = vim.uv.cwd()
            local basename = vim.fs.basename(cwd)
            _99.setup({
                -- model is optional, overrides the provider's default
                provider = _99.Providers.ClaudeCodeProvider,
                model = "claude-sonnet-4-5-20250929",
                logger = {
                    level = _99.DEBUG,
                    path = "/tmp/" .. basename .. ".99.debug",
                    -- path = "/tmp/" .. ".99.debug",
                    print_on_error = true,
                },

                --- Completions: #rules and @files in the prompt buffer
                completion = {
                    -- I am going to disable these until i understand the
                    -- problem better.  Inside of cursor rules there is also
                    -- application rules, which means i need to apply these
                    -- differently
                    -- cursor_rules = "<custom path to cursor rules>"

                    --- A list of folders where you have your own SKILL.md
                    --- Expected format:
                    --- /path/to/dir/<skill_name>/SKILL.md
                    ---
                    --- Example:
                    --- Input Path:
                    --- "scratch/custom_rules/"
                    ---
                    --- Output Rules:
                    --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
                    --- ... the other rules in that dir ...
                    ---
                    -- custom_rules = {
                    --   "scratch/custom_rules/",
                    -- },

                    --- Configure @file completion (all fields optional, sensible defaults)
                    files = {
                        -- enabled = true,
                        -- max_file_size = 102400,     -- bytes, skip files larger than this
                        -- max_files = 5000,            -- cap on total discovered files
                        -- exclude = { ".env", ".env.*", "node_modules", ".git", ... },
                    },

                    --- What autocomplete do you use.  We currently only
                    --- support cmp right now
                    source = "cmp",
                },

                --- WARNING: if you change cwd then this is likely broken
                --- ill likely fix this in a later change
                ---
                --- md_files is a list of files to look for and auto add based on the location
                --- of the originating request.  That means if you are at /foo/bar/baz.lua
                --- the system will automagically look for:
                --- /foo/bar/AGENT.md
                --- /foo/AGENT.md
                --- assuming that /foo is project root (based on cwd)
                -- md_files = {
                -- 	"AGENT.md",
                -- },
            })

            -- take extra note that i have visual selection only in v mode
            -- technically whatever your last visual selection is, will be used
            -- so i have this set to visual mode so i dont screw up and use an
            -- old visual selection
            --
            -- likely ill add a mode check and assert on required visual mode
            -- so just prepare for it now
            vim.keymap.set("v", "<leader>9v", function()
                _99.visual()
            end)

            --- if you have a request you dont want to make any changes, just cancel it
            vim.keymap.set("v", "<leader>9s", function()
                _99.stop_all_requests()
            end)
        end,
    },
    {

        "lewis6991/gitsigns.nvim",
        config = function()
            gitsigns = require("gitsigns")
            gitsigns.setup()
            vim.keymap.set("n", "<leader>gN", function() gitsigns.nav_hunk("prev", { target = 'all' }) end)
            vim.keymap.set("n", "<leader>gn", function() gitsigns.nav_hunk("next", { target = 'all' }) end)
            vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk)
            vim.keymap.set("n", "<leader>gP", gitsigns.preview_hunk_inline)
            vim.keymap.set("n", "<leader>gd", function() gitsigns.diffthis("~1") end)
            vim.keymap.set("n", "<leader>gq", function() gitsigns.setqflist('all') end)
            vim.keymap.set('n', '<leader>gr', function()
                -- Fetch the target branch of the current PR using gh CLI
                local cmd = "gh pr view --json baseRefName --template '{{.baseRefName}}' 2>/dev/null"
                local handle = io.popen(cmd)
                local base_branch = handle:read("*a"):gsub("%s+", "")
                handle:close()

                if base_branch ~= "" then
                    -- Use "..." to compare against the merge-base (only shows PR changes)
                    -- The 'true' argument applies this globally to all open buffers
                    require('gitsigns').change_base(base_branch, true)
                    -- set quickfix list with changed files

                    local files = vim.fn.systemlist('gh pr diff --name-only')
                    local qf_items = {}
                    for _, file in ipairs(files) do
                        if file ~= "" then
                            table.insert(qf_items, { filename = file, lnum = 1 })
                        end
                    end

                    -- Replace the current quickfix list with the new items
                    vim.fn.setqflist(qf_items, 'r')
                    vim.cmd('copen')
                    print("Gitsigns base set to: " .. base_branch)
                else
                    print("Error: No PR found for the current branch via 'gh' CLI.")
                end
            end, { desc = "Gitsigns: Show diff for current PR" })
        end
    },
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        dependencies = { { "nvim-mini/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
    },
    {
        "hat0uma/csvview.nvim",
        ---@module "csvview"
        ---@type CsvView.Options
        opts = {
            parser = { comments = { "#", "//" } },
            keymaps = {
                -- Text objects for selecting fields
                textobject_field_inner = { "if", mode = { "o", "x" } },
                textobject_field_outer = { "af", mode = { "o", "x" } },
                -- Excel-like navigation:
                -- Use <Tab> and <S-Tab> to move horizontally between fields.
                -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
                -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
                jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
                jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
                jump_next_row = { "<Enter>", mode = { "n", "v" } },
                jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
            },
        },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    },
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { 'tpope/vim-dadbod',                     lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    }

}
