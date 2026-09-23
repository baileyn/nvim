-- nvim-treesitter (main branch): parser/query installer for Neovim's built-in
-- treesitter features.
--
-- NOTE: `main` is a full, incompatible rewrite of the plugin. It does NOT use
-- the old `require('nvim-treesitter.configs').setup{ highlight = ... }` API.
-- Instead:
--   * parsers are installed via require('nvim-treesitter').install{...}
--   * highlighting is enabled per-filetype with vim.treesitter.start()
--   * indentation/folding are opt-in via indentexpr/foldexpr
--
-- Requirements (main branch): Neovim 0.12+, plus `tree-sitter-cli` (>= 0.26.1),
-- `curl`, `tar`, and a C compiler on PATH. Install tree-sitter-cli via a package
-- manager (e.g. `brew install tree-sitter`), NOT npm.
-- Docs: https://github.com/nvim-treesitter/nvim-treesitter/tree/main
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- main branch does not support lazy-loading
  build = ':TSUpdate', -- keep parsers in sync with the plugin version
  config = function()
    local ts = require 'nvim-treesitter'
    ts.setup {
      -- default install location (prepended to runtimepath)
      install_dir = vim.fn.stdpath 'data' .. '/site',
    }

    -- Parsers to install. `python` is the priority; the rest cover this
    -- config (lua, vim) and common data/markup formats. `rust` is included so
    -- the custom queries in queries/rust/ have a parser to attach to.
    local parsers = {
      'python',
      'lua',
      'luadoc',
      'vim',
      'vimdoc',
      'rust',
      'bash',
      'json',
      'yaml',
      'toml',
      'markdown',
      'markdown_inline',
      'gitcommit',
      'diff',
    }
    -- Warm up the common parsers. Asynchronous; a no-op for anything already
    -- installed. Everything else is handled on demand by the autocmd below.
    ts.install(parsers)

    -- Enable treesitter features per buffer, self-installing parsers on demand.
    --
    -- The main branch has no `auto_install`, so we recreate it: on FileType,
    -- resolve the buffer's language, and if a parser is available install it
    -- (when missing) then start highlighting. `install` is async, so for a
    -- freshly-installed parser we start highlighting from its completion
    -- callback rather than immediately.
    local function enable_features(buf)
      -- Highlighting (provided by Neovim core).
      pcall(vim.treesitter.start, buf)
      -- Experimental treesitter-based indentation.
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-features', { clear = true }),
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        -- Filetype -> treesitter language (they differ, e.g. sh -> bash).
        local lang = vim.treesitter.language.get_lang(ft) or ft

        -- Only proceed if a parser exists for this language in the registry.
        if not vim.tbl_contains(ts.get_available(), lang) then
          return
        end

        if vim.tbl_contains(ts.get_installed(), lang) then
          enable_features(buf)
        else
          -- Install, then enable once compilation finishes. Guard the buffer
          -- in case it's gone (or changed filetype) by the time we return.
          ts.install(lang):await(function()
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == ft then
              enable_features(buf)
            end
          end)
        end
      end,
    })
  end,
}
