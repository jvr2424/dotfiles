-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
return {
	{
	    "folke/tokyonight.nvim",
	    lazy = false, -- make sure we load this during startup if it is your main colorscheme
	    priority = 1000, -- make sure to load this before all the other start plugins
	    config = function()
	      -- load the colorscheme here
	      vim.cmd([[colorscheme tokyonight]])
	    end,
	  },
	{
	  "epwalsh/obsidian.nvim",
	  version = "*",  -- recommended, use latest release instead of latest commit
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
	-- lsp support
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
}
