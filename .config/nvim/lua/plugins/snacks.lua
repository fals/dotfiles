return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Always show hidden files (dotfiles) in file pickers and explorer:
    picker = {
      -- optional global picker default (some people prefer to set per-source only)
      hidden = true,
      sources = {
        -- files picker (used by Snacks.picker.files)
        files = {
          hidden = true, -- show dotfiles like .gitignore, .env, etc.
          -- ignored = true, -- if you ALSO want to include git-ignored files (node_modules), uncomment
        },
        -- explorer is implemented as a picker source — override it too:
        explorer = {
          hidden = true,
          -- ignored = true, -- optional: include git-ignored files here as well
        },
      },
    },

    -- Disable scroll *animations* (keeps the scroll feature but turns off smooth/animated motion)
    scroll = {
      animate = {
        enabled = false,
      },
    },

    -- Alternatively, to completely disable the scroll snack (if you want no scroll handling at all):
    -- scroll = { enabled = false },
  },
}
