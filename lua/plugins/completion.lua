-- blink.cmp (saghen): fast, batteries-included completion engine.
-- Chosen over nvim-cmp for speed (Rust fuzzy matcher) and simpler config.
-- It also supplies the LSP `capabilities` consumed in lsp.lua.
-- Docs: https://cmp.saghen.dev/
return {
  'saghen/blink.cmp',
  -- Pin to a released 1.x tag so lazy fetches the matching prebuilt Rust
  -- binary instead of a bleeding-edge `main` commit (a stale lock previously
  -- forced `main`, which has no prebuilt binary -> `blink.lib` not found).
  version = '1.*',
  -- Belt-and-suspenders: if no prebuilt binary is available for this
  -- platform/version, build the native fuzzy matcher from source. Requires
  -- cargo (present on this machine).
  build = 'cargo build --release',
  event = 'InsertEnter',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
  },
  opts_extend = { 'sources.default' },
}
