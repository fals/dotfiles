return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local cb = require("diffview.config").diffview_callback

      require("diffview").setup({
        view = {
          merge_tool = {
            layout = "diff3_mixed", -- "diff3_horizontal" for true side-by-side merge
            disable_diagnostics = true,
          },
        },
      })
    end,
  },
}
