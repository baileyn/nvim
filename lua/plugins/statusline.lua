-- lualine.nvim: a fast, configurable statusline.
-- Themed to tokyonight to match the colorscheme; the git sections read from
-- gitsigns (branch + diff counts).
-- Docs: https://github.com/nvim-lualine/lualine.nvim
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- filetype/mode icons
  opts = {
    options = {
      theme = 'tokyonight',
      icons_enabled = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      globalstatus = true, -- one statusline across splits (Neovim 0.7+)
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { { 'filename', path = 1 } }, -- relative path
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  },
}
