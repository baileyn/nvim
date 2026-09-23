-- conform.nvim (stevearc): run external formatters and format on save.
--
-- Formatters used here:
--   * Python -> ruff (organize imports, then format). The ruff binary comes
--     from mason (installed as an LSP in lsp.lua); mason puts it on Neovim's
--     PATH, so conform finds it even if your shell can't.
--   * Lua    -> stylua (picks up the .stylua.toml in this config).
--
-- Format-on-save can be toggled at runtime:
--   :FormatDisable        -> turn off for this session (all buffers)
--   :FormatDisable!       -> turn off for the current buffer only
--   :FormatEnable         -> turn back on
--   <leader>tf            -> toggle on/off
-- Docs: https://github.com/stevearc/conform.nvim
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' }, -- load in time to format on save
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = { 'n', 'x' },
      desc = '[F]ormat buffer',
    },
  },
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      python = { 'ruff_organize_imports', 'ruff_format' },
      lua = { 'stylua' },
      -- Add more as you go, e.g.:
      -- javascript = { 'prettierd', 'prettier', stop_after_first = true },
    },
    -- Pin stylua to the mason-managed binary. There is also an old
    -- stylua 0.18.1 at ~/.cargo/bin that lacks the `--respect-ignores` flag
    -- conform passes to modern stylua; if PATH order ever favored it,
    -- formatting would fail. Referencing mason's binary directly avoids that.
    formatters = {
      stylua = {
        command = vim.fn.stdpath 'data' .. '/mason/bin/stylua',
      },
    },
    -- Format on save, unless disabled globally or for the buffer.
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
  },
  init = function()
    -- Commands to toggle format-on-save. A bang (!) scopes to the buffer.
    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = 'Disable autoformat-on-save', bang = true })

    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = 'Re-enable autoformat-on-save' })

    -- <leader>tf toggles autoformat globally.
    vim.keymap.set('n', '<leader>tf', function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      vim.notify('Autoformat ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled'))
    end, { desc = '[T]oggle [F]ormat on save' })
  end,
}
