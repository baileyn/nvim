-- snacks.nvim (folke): an all-in-one collection of small QoL features.
-- Here we primarily use the fuzzy-finder `picker` plus a few core modules.
-- Docs: https://github.com/folke/snacks.nvim
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Core niceties
    bigfile = { enabled = true }, -- disables heavy features in huge files
    quickfile = { enabled = true }, -- render a file before plugins load
    input = { enabled = true }, -- nicer vim.ui.input
    notifier = { enabled = true, timeout = 3000 }, -- notification popups
    indent = { enabled = true }, -- indent guides
    scope = { enabled = true }, -- scope detection for pickers/textobjects

    -- The reason we're here: fuzzy finder
    picker = { enabled = true },
  },
  keys = {
    -- Top-level pickers
    { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
    { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep Project' },
    { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },

    -- find
    { '<leader>ff', function() Snacks.picker.files() end, desc = '[F]ind [F]iles' },
    { '<leader>fg', function() Snacks.picker.git_files() end, desc = '[F]ind [G]it Files' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = '[F]ind [R]ecent' },
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = '[F]ind [B]uffers' },
    { '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = '[F]ind [C]onfig File' },

    -- search
    { '<leader>sg', function() Snacks.picker.grep() end, desc = '[S]earch by [G]rep' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = '[S]earch current [W]ord', mode = { 'n', 'x' } },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = '[S]earch [D]iagnostics' },
    { '<leader>sh', function() Snacks.picker.help() end, desc = '[S]earch [H]elp' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = '[S]earch [K]eymaps' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = '[S]earch [R]esume' },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = '[S]earch [R]egisters' },

    -- misc
    { '<leader>n', function() Snacks.picker.notifications() end, desc = '[N]otification History' },
  },
}
