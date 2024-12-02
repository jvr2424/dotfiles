-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.vscode then
  -- VSCode extension
  vim.g.mapleader = " "
  vim.g.have_nerd_font = false
  vim.opt.clipboard = "unnamedplus"
  vim.opt.hlsearch = true

  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
  vim.keymap.set("n", "gj", "<cmd>lua require('vscode').action('editor.action.marker.next')<CR>")
  vim.keymap.set("n", "gk", "<cmd>lua require('vscode').action('editor.action.marker.prev')<CR>")

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
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

_G.thousands_sep = function(separator)
  separator = separator or ","

  local line = vim.api.nvim_get_current_line()

  local reversed_line = string.reverse(line)

  local pattern = "(%d%d%d)"
  local with_separators = reversed_line:gsub(pattern, "%1" .. separator)

  if #line % 3 == 0 then
    with_separators = with_separators:sub(1, -2)
  end

  with_separators = string.reverse(with_separators)

  vim.api.nvim_set_current_line(with_separators)
end

_G.thousands_sep_comma = function()
  _G.thousands_sep(",")
end

_G.thousands_sep_underscore = function()
  _G.thousands_sep("_")
end

_G.wrap_in_fstring = function(add_equal)
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- retrieve the line and process the selected portion
  local line = vim.fn.getline(start_pos[2])
  local pre_selection = string.sub(line, 1, start_pos[3] - 1)
  local post_selection = string.sub(line, end_pos[3] + 1)

  local selected_text = string.sub(line, start_pos[3], end_pos[3])

  -- construct the f string
  local f_string
  if add_equal then
    f_string = 'f"{' .. selected_text .. '=}"'
  else
    f_string = 'f"{' .. selected_text .. '}"'
  end

  -- combine everything and replace the line
  local new_line = pre_selection .. f_string .. post_selection
  vim.fn.setline(start_pos[2], new_line)
end

_G.wrap_in_fstring_std = function()
  _G.wrap_in_fstring(false)
end

_G.wrap_in_fstring_equal = function()
  _G.wrap_in_fstring(true)
end

-- Map the function to key combos
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>lua thousands_sep_comma()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>T", "<cmd>lua thousands_sep_underscore()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>f", ":lua wrap_in_fstring_std()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>F", ":lua wrap_in_fstring_equal()<CR>", { noremap = true, silent = true })
