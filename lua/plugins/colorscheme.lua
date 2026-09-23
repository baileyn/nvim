-- Colorscheme: tokyonight (folke)
-- A clean, dark theme with first-class LSP, treesitter, and plugin support.
return {
  'folke/tokyonight.nvim',
  lazy = false, -- load during startup since it's the main colorscheme
  priority = 1000, -- load before all other plugins
  opts = {
    style = 'night', -- night | storm | moon | day
    transparent = false,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
    },
  },
  config = function(_, opts)
    require('tokyonight').setup(opts)
    vim.cmd.colorscheme 'tokyonight'
  end,
}
