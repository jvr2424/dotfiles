-- bootstrap lazy.nvim, LazyVim and your plugins


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

vim.g.have_nerd_font = false
vim.opt.clipboard = "unnamedplus"
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- keymaps
require("config.keymaps")


-- autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})


vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*/bash-fc*",
    command = "set filetype=bash"
})

--plugins
-- require("config.base_plugins")

--vs code vs regular neovim
if vim.g.vscode then
    -- VSCode extension
    require("lazy").setup({
        spec = {
            { import = "config.base_plugins" },
        },
        defaults = {
            lazy = false,
            version = false, -- always use the latest git commit
            -- version = "*", -- try installing the latest stable version for plugins that support semver
        },
        checker = { enabled = false },
    })
    vim.keymap.set("n", "<leader>j", "<cmd>lua require('vscode').action('editor.action.marker.next')<CR>")
    vim.keymap.set("n", "<leader>k", "<cmd>lua require('vscode').action('editor.action.marker.prev')<CR>")
    vim.keymap.set("n", "<leader>s", "<cmd>lua require('vscode').action('cSpell.suggestSpellingCorrections')<CR>")
    vim.keymap.set("n", "<leader>gn", "<cmd>lua require('vscode').action('workbench.action.editor.nextChange')<CR>")
    vim.keymap.set("n", "<leader>gp", "<cmd>lua require('vscode').action('workbench.action.editor.previousChange')<CR>")

    -- vscode like harpoon
    vim.keymap.set("n", "<leader>hx", "<cmd>lua require('vscode').action('workbench.action.pinEditor')<CR>")
    vim.keymap.set("n", "<leader>hX", "<cmd>lua require('vscode').action('workbench.action.unpinEditor')<CR>")
    vim.keymap.set("n", "<leader>hj", "<cmd>lua require('vscode').action('workbench.action.openEditorAtIndex1')<CR>")
    vim.keymap.set("n", "<leader>hk", "<cmd>lua require('vscode').action('workbench.action.openEditorAtIndex2')<CR>")
    vim.keymap.set("n", "<leader>hl", "<cmd>lua require('vscode').action('workbench.action.openEditorAtIndex3')<CR>")
    vim.keymap.set("n", "<leader>h;", "<cmd>lua require('vscode').action('workbench.action.openEditorAtIndex4')<CR>")

    -- search for text and files
    vim.keymap.set("n", "<leader>fg", "<cmd>lua require('vscode').action('workbench.action.findInFiles')<CR>")
    vim.keymap.set("n", "<leader>fd", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>")
else
    -- ordinary Neovim
    require("lazy").setup({
        spec = {
            { import = "config.base_plugins" },
            { import = "config.nvim_only_plugins" },
        },
        defaults = {
            lazy = false,
            version = false, -- always use the latest git commit
            -- version = "*", -- try installing the latest stable version for plugins that support semver
        },
        install = { colorscheme = { "tokyonight" } },
        checker = { enabled = true },
    })
    -- Reserve a space in the gutter
    -- This will avoid an annoying layout shift in the screen
    vim.opt.signcolumn = 'yes'


    -- keymap to open current file in xcode
    vim.keymap.set("n", "<leader>xo", ":!open -a Xcode %<CR>", { noremap = true, silent = true })


    -- Add cmp_nvim_lsp capabilities settings to lspconfig
    -- This should be executed before you configure any language server
    local lspconfig_defaults = require('lspconfig').util.default_config
    lspconfig_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lspconfig_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
    )

    -- This is where you enable features that only work
    -- if there is a language server active in the file
    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
            local opts = { buffer = event.buf }

            vim.keymap.set('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
            vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
            vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
            vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
            vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
            vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
            vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        end,
    })
    require('mason').setup({})
    require('mason-lspconfig').setup({
        handlers = {
            function(server_name)
                require('lspconfig')[server_name].setup({})
            end,
        },
    })
    require('mini.snippets').setup()

    local cmp = require('cmp')
    cmp.setup({
        sources = {
            { name = 'nvim_lsp' },
        },
        mapping = cmp.mapping.preset.insert({
            -- Navigate between completion items
            ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
            ['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),

            -- `Enter` key to confirm completion
            ["<Tab>"] = cmp.mapping(function(fallback)
                -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
                if cmp.visible() then
                    local entry = cmp.get_selected_entry()
                    if not entry then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    end
                    cmp.confirm()
                else
                    fallback()
                end
            end, { "i", "s", "c", }),

            -- Ctrl+Space to trigger completion menu
            ['<C-Space>'] = cmp.mapping.complete(),

            -- Scroll up and down in the completion documentation
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
        }),
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                -- For `mini.snippets` users:
                local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
                insert({ body = args.body }) -- Insert at cursor
                cmp.resubscribe({ "TextChangedI", "TextChangedP" })
                require("cmp.config").set_onetime({ sources = {} })
            end,
        },
    })

    require 'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all" (the listed parsers MUST always be installed)
        ensure_installed = {
            "lua",
            "vim",
            "markdown",
            "markdown_inline",
            "html",
            "python",
            "javascript",
            "css",
            "bash",
            "toml",
        },

        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        highlight = {
            enable = true,
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
    }
end
