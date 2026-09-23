-- Kiro CLI integration via the snacks terminal (no extra dependency).
--
-- Thin wrapper, same pattern as a lazygit toggle. Relies only on snacks
-- (already installed) rather than a young single-author kiro plugin.
--
--   <leader>k  (normal) toggle a floating Kiro CLI terminal (session persists)
--   <leader>k  (visual) open Kiro CLI seeded with the selected code as context
return {
  'folke/snacks.nvim',
  keys = {
    {
      '<leader>k',
      function()
        Snacks.terminal.toggle('kiro-cli', {
          win = { position = 'float', border = 'rounded', width = 0.9, height = 0.9 },
        })
      end,
      desc = '[K]iro CLI',
    },
    {
      '<leader>k',
      function()
        -- Grab the visual selection (linewise) from the current buffer.
        local start_line = vim.fn.line 'v'
        local end_line = vim.fn.line '.'
        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end
        local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
        local selection = table.concat(lines, '\n')

        -- Frame the selection with filename + filetype so Kiro has context.
        local name = vim.fn.expand '%:t'
        local ft = vim.bo.filetype
        local prompt = table.concat({
          'Here is a selection from ' .. (name ~= '' and name or '[unnamed buffer]') .. ':',
          '',
          '```' .. ft,
          selection,
          '```',
        }, '\n')

        -- IMPORTANT: pass the command as an argv list, not a joined string, so
        -- the prompt is a single argument and is never re-parsed by the shell
        -- (no injection risk from buffer contents).
        Snacks.terminal.open({ 'kiro-cli', 'chat', prompt }, {
          win = { position = 'float', border = 'rounded', width = 0.9, height = 0.9 },
        })
      end,
      mode = 'x',
      desc = '[K]iro CLI with selection',
    },
  },
}
