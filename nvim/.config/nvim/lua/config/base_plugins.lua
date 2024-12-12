return {
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
}
