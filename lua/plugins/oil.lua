-- oil.nvim (stevearc): edit your filesystem like a normal buffer.
-- Press `-` to open the parent directory, edit lines to rename/create/delete,
-- then `:w` to apply. `<CR>` opens a file/dir, `-` goes up a level.
-- Docs: https://github.com/stevearc/oil.nvim
return {
  'stevearc/oil.nvim',
  -- Lazy loading is not recommended by the author; loading eagerly also lets
  -- oil replace netrw so it handles `nvim <dir>` and `:e <dir>` correctly.
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- file icons (optional)
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true, -- take over netrw
    columns = { 'icon' },
    view_options = {
      show_hidden = true,
    },
  },
  keys = {
    { '-', '<CMD>Oil<CR>', desc = 'Open parent directory (oil)' },
  },
}
