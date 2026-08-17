-- Colorschemes
return {
  require('custom.save-colors').lazy_setup {
    -- List all colorscheme plugins here.
    {
      'folke/tokyonight.nvim',
      lazy = false,
      priority = 1000,
    },
    {
      'EdenEast/nightfox.nvim',
      lazy = false,
      priority = 1000,
    },
    {
      'Mofiqul/dracula.nvim',
      lazy = false,
      priority = 1000,
    },
    {
      'ellisonleao/gruvbox.nvim',
      priority = 1000,
      config = true,
    },

    {
      'catppuccin/nvim',
      lazy = false,
      priority = 1000,
      -- name = 'catppuccin',
    },

    {
      'folke/tokyonight.nvim',
      lazy = false,
      priority = 1000,
      -- opts = {},
    },
    {
      'clearaspect/onehalf',
      lazy = false,
      priority = 1000,
    },
    {
      'olimorris/onedarkpro.nvim',
      priority = 1000, -- Ensure it loads first
    },
    {
      'vague2k/vague.nvim',
      lazy = false,
      priority = 1000,
    },
    {
      'neanias/everforest-nvim',
      lazy = false,
      priority = 1000,
    },
    {
      'ribru17/bamboo.nvim',
      lazy = false,
      priority = 1000,
    },

    {
      'tanvirtin/monokai.nvim',
      lazy = false,
      priority = 1000,
      -- name = 'monokai',
    },

    {
      'drewxs/ash.nvim',
      lazy = false,
      priority = 1000,
    },

    {
      'eldritch-theme/eldritch.nvim',
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
      'rose-pine/neovim',
      lazy = false,
      priority = 1000,
      -- name = 'rose-pine',
    },

    {
      'rebelot/kanagawa.nvim',
      lazy = false,
      priority = 1000,
    },
    {
      'savq/melange-nvim',
      lazy = false,
      priority = 1000,
    },

    -- Use themery to live preview themes
    -- {
    --   'zaldih/themery.nvim',
    --   lazy = false,
    --   config = function()
    --     require('themery').setup {
    --   themes = {
    --     'ash',
    --     'catppuccin-latte',
    --     'catppuccin-frappe',
    --     'catppuccin-macchiato',
    --     'catppuccin-mocha',
    --     'cyberdream',
    --     'dracula',
    --     'gruvbox',
    --     'kanagawa-dragon',
    --     'kanagawa-lotus',
    --     'kanagawa-wave',
    --     'onehalfdark',
    --     'onehalflight',
    --     'oxocarbon',
    --     'rose-pine',
    --     'tokyonight-day',
    --     'tokyonight-moon',
    --     'tokyonight-night',
    --     'tokyonight-storm',
    --     'vague',
    --   }, -- Your list of installed colorschemes.
    --   livePreview = true, -- Apply theme while picking. Default to true.
    --     }
    --   end,
    -- },
  },
}
