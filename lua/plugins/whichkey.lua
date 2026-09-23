-- which-key.nvim (folke): popup showing available keybindings as you type a
-- prefix. Uses the v3 `spec` API (the old `register()` is deprecated).
-- Docs: https://github.com/folke/which-key.nvim
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'modern',
    -- Group labels for the leader prefixes used across this config. Individual
    -- key descriptions come from the `desc` set where each mapping is defined
    -- (LSP, gitsigns, snacks, conform, fugitive, etc.).
    spec = {
      { '<leader>f', group = '[F]ind' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>g', group = '[G]it (fugitive)' },
      { '<leader>h', group = 'Git [H]unks', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>r', group = '[R]ename' },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer-local keymaps (which-key)',
    },
  },
}
