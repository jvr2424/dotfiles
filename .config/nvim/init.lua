-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.vscode then
  -- VSCode extension
  vim.g.mapleader = " "
  vim.g.have_nerd_font = false
  vim.opt.clipboard = "unnamedplus"
  vim.opt.hlsearch = true
  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  -- [[ Install `lazy.nvim` plugin manager ]]
  --    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  end ---@diagnostic disable-next-line: undefined-field
  vim.opt.rtp:prepend(lazypath)
  --
  -- NOTE: Here is where you install your plugins.
  require("lazy").setup({
    -- "gc" to comment visual regions/lines
    { "numToStr/Comment.nvim", opts = {} },
    { -- Collection of various small independent plugins/modules
      "echasnovski/mini.nvim",
      config = function()
        require("mini.surround").setup()
        -- ... and there is more!
        --  Check out: https://github.com/echasnovski/mini.nvim
      end,
    },
  })
else
  -- ordinary Neovim
  require("config.lazy")
end
