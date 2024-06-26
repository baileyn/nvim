return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/playground',
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        auto_install = true,
        ignore_install = { 'org' },
        indent = {
          enabled = true,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'org' },
        },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      -- This will be overwritten if I don't have it in the ColorScheme autocmd
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#3E5256' }) -- 5% lighter that CursorLine hl group
        end,
      })
    end,
  },
}
