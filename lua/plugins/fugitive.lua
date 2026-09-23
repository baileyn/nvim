-- vim-fugitive (tpope): the classic git interface for Vim/Neovim.
-- Use :Git (or :G) for the status buffer, :Git blame, :Gdiffsplit, etc.
-- Docs: https://github.com/tpope/vim-fugitive
return {
  'tpope/vim-fugitive',
  -- Load on the commands it provides (and the keymaps below), so it stays out
  -- of the way until you actually invoke git.
  cmd = { 'Git', 'G', 'Gdiffsplit', 'Gread', 'Gwrite', 'Gedit', 'GBrowse' },
  keys = {
    { '<leader>gg', '<cmd>Git<cr>', desc = '[G]it status (fugitive)' },
    { '<leader>gc', '<cmd>Git commit<cr>', desc = '[G]it [C]ommit' },
    { '<leader>gd', '<cmd>Gdiffsplit<cr>', desc = '[G]it [D]iff split' },
    { '<leader>gB', '<cmd>Git blame<cr>', desc = '[G]it [B]lame' },
  },
}
