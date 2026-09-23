-- gitsigns.nvim: git decorations in the sign column + hunk actions.
-- Shows added/changed/deleted lines and lets you stage, reset, preview, and
-- navigate hunks without leaving the buffer.
-- Docs: https://github.com/lewis6991/gitsigns.nvim
return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    on_attach = function(bufnr)
      local gs = require 'gitsigns'
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigate hunks. When a diff is open, fall back to ]c/[c.
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gs.nav_hunk 'next'
        end
      end, 'Next git hunk')
      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gs.nav_hunk 'prev'
        end
      end, 'Previous git hunk')

      -- Hunk actions (leader h = "hunk")
      map('n', '<leader>hs', gs.stage_hunk, 'Git [H]unk [S]tage')
      map('n', '<leader>hr', gs.reset_hunk, 'Git [H]unk [R]eset')
      map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Git [H]unk [S]tage (range)')
      map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Git [H]unk [R]eset (range)')
      map('n', '<leader>hS', gs.stage_buffer, 'Git [H]unk [S]tage buffer')
      map('n', '<leader>hu', gs.undo_stage_hunk, 'Git [H]unk [U]ndo stage')
      map('n', '<leader>hR', gs.reset_buffer, 'Git [H]unk [R]eset buffer')
      map('n', '<leader>hp', gs.preview_hunk, 'Git [H]unk [P]review')
      map('n', '<leader>hb', function() gs.blame_line { full = true } end, 'Git [H]unk [B]lame line')
      map('n', '<leader>hd', gs.diffthis, 'Git [H]unk [D]iff this')

      -- Toggles
      map('n', '<leader>tb', gs.toggle_current_line_blame, '[T]oggle git line [B]lame')
      map('n', '<leader>tD', gs.toggle_deleted, '[T]oggle git [D]eleted')

      -- Text object: select the current hunk (e.g. `dih`, `vih`)
      map({ 'o', 'x' }, 'ih', gs.select_hunk, 'Select git hunk')
    end,
  },
}
