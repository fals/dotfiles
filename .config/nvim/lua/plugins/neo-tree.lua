return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- Show filtered (hidden + gitignored) items
        hide_dotfiles = false, -- Show dotfiles
        hide_gitignored = false, -- Show gitignored files
      },
    },
  },
}
