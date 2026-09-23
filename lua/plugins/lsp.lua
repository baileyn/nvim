-- LSP stack for Neovim 0.11+/0.12 native LSP.
--
-- How the pieces fit together:
--   * mason.nvim            -> installs language-server binaries
--   * mason-lspconfig.nvim  -> auto-installs (ensure_installed) and
--                              auto-enables installed servers via vim.lsp.enable()
--   * nvim-lspconfig        -> ships the per-server configs in its lsp/ dir that
--                              Neovim consumes natively (no require('lspconfig').setup)
--   * blink.cmp             -> provides completion `capabilities` (see completion.lua)
--
-- Customize a server with vim.lsp.config('name', {...}); enable with
-- vim.lsp.enable('name') (mason-lspconfig does the enabling for installed ones).
return {
  -- mason itself: load eagerly (not behind an LSP event) so its commands
  -- (:Mason, :MasonInstall) and setup() always run, even when Neovim starts
  -- on an empty buffer. Previously mason was only a dependency of
  -- nvim-lspconfig, which is lazy-loaded on BufReadPre/BufNewFile -- so
  -- launching nvim with no file meant mason never set up and its commands
  -- didn't exist. Keeping it standalone fixes that.
  {
    'mason-org/mason.nvim',
    lazy = false,
    opts = {},
  },

  -- Reliable, declarative installation of servers/formatters/linters.
  -- mason-lspconfig's `ensure_installed` is known to be flaky about actually
  -- completing installs; mason-tool-installer installs mason packages by name
  -- and is the dependable way to guarantee the tooling is present.
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    lazy = false,
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = {
        'lua_ls', -- Lua LSP
        'basedpyright', -- Python LSP (types + completion)
        'ruff', -- Python linter/formatter (LSP + binary for conform)
        'stylua', -- Lua formatter (also on system, but keep managed)
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    config = function()
    -- 1. Merge blink.cmp's completion capabilities into the default client
    --    config so every server advertises them.
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    vim.lsp.config('*', { capabilities = capabilities })

    -- 2. Per-server overrides. `lua_ls` needs to know about the `vim` global
    --    and this config's runtime so it stops warning about it.
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          },
          diagnostics = { globals = { 'vim' } },
          completion = { callSnippet = 'Replace' },
        },
      },
    })

    -- Python: basedpyright handles type checking + completion; ruff handles
    -- linting/formatting. Disable ruff's hover so basedpyright owns it.
    vim.lsp.config('ruff', {
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
      end,
    })
    vim.lsp.config('basedpyright', {
      settings = {
        basedpyright = {
          analysis = {
            -- 'basic' keeps diagnostics useful without the very strict
            -- defaults basedpyright ships with. Bump to 'standard'/'strict'
            -- per project if you want more.
            typeCheckingMode = 'basic',
            autoImportCompletions = true,
          },
        },
      },
    })

    -- 3. Auto-enable installed servers via vim.lsp.enable(). Installation is
    --    handled by mason-tool-installer above; here we only enable. Add new
    --    servers to the tool-installer list (e.g. 'rust_analyzer', 'gopls').
    require('mason-lspconfig').setup {
      automatic_enable = true,
    }

    -- 4. Buffer-local keymaps, set when a server attaches to a buffer.
    --    Note: Neovim 0.11+ already provides grn (rename), gra (code action),
    --    grr (references), gri (implementation), and K (hover) by default.
    --    These add the familiar extras.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, fn, desc)
          vim.keymap.set('n', keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gy', vim.lsp.buf.type_definition, '[G]oto t[Y]pe definition')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('<leader>D', vim.diagnostic.open_float, 'Show line [D]iagnostics')
      end,
    })

    -- 5. Nicer diagnostics: show virtual text and a floating window on hover.
    vim.diagnostic.config {
      virtual_text = true,
      severity_sort = true,
      float = { border = 'rounded', source = true },
    }
    end,
  },
}
