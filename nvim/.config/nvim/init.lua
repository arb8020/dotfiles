-- Set leader key to space (near the top)
vim.g.mapleader = " "

-- Suppress lspconfig deprecation warning (nvim 0.11+)
-- TODO: migrate to vim.lsp.config when plugins catch up
local original_deprecate = vim.deprecate
vim.deprecate = function(name, alternative, version, plugin, backtrace)
  if plugin == 'nvim-lspconfig' then return end
  return original_deprecate(name, alternative, version, plugin, backtrace)
end

local Plug = vim.fn['plug#']
vim.call('plug#begin')

-- Your existing plugins
Plug('catppuccin/nvim', {['as'] = 'catppuccin'})
Plug('akinsho/bufferline.nvim', { ['tag'] = '*' })
Plug('nvim-tree/nvim-web-devicons')  -- Required for file icons
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug('numToStr/Comment.nvim')  -- Add this line for the commenting plugin

-- New plugins for LSP and file finding
Plug('neovim/nvim-lspconfig')           -- LSP configuration
Plug('williamboman/mason.nvim')         -- LSP installer
Plug('williamboman/mason-lspconfig.nvim') -- Mason LSP config
Plug('nvim-lua/plenary.nvim')           -- Required for telescope
Plug('nvim-telescope/telescope.nvim')    -- Fuzzy finder (kept installed but unused; fzf below is primary)
Plug('junegunn/fzf', { ['do'] = function() vim.fn['fzf#install']() end })
Plug('junegunn/fzf.vim')                 -- :Files, :Rg, :Buffers
Plug('ojroques/nvim-lspfuzzy')           -- Route LSP results (gr, etc.) through fzf instead of quickfix
Plug('tpope/vim-fugitive')
Plug('sindrets/diffview.nvim')
Plug('NeogitOrg/neogit')
Plug('sgeb/vim-diff-fold')
Plug('kevinhwang91/promise-async')
Plug('kevinhwang91/nvim-ufo')

-- Adding GitSigns for git integration
Plug('lewis6991/gitsigns.nvim')

-- do u have games on ur nvim
Plug('ThePrimeagen/vim-be-good')

-- Completion plugins
Plug('hrsh7th/nvim-cmp')           -- Completion engine
Plug('hrsh7th/cmp-nvim-lsp')       -- LSP completion source
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-buffer')

-- LLM integration
Plug('arb8020/dingllm.nvim')

-- Unified colorscheme
Plug('axkirillov/unified.nvim')

-- lean
Plug('Julian/lean.nvim')

-- orgmode
Plug('nvim-orgmode/orgmode')


vim.call('plug#end')

-- Load follow-diffs plugin
-- vim.defer_fn(function()
--   vim.opt.runtimepath:append(vim.fn.expand('~/nvim-follow-diffs'))
--
--   local ok, follow_diffs = pcall(require, 'follow-diffs')
--   if ok then
--     follow_diffs.setup({
--       -- Optional: customize config
--       debounce_ms = 200,
--       max_file_size = 5 * 1024 * 1024,
--     })
--     vim.notify('follow-diffs loaded ✓', vim.log.levels.INFO)
--   else
--     vim.notify('follow-diffs: failed to load', vim.log.levels.WARN)
--   end
-- end, 100)

-- Load git viewer using follow-diffs rendering
vim.defer_fn(function()
  vim.opt.runtimepath:append(vim.fn.expand('~/nvim-follow-diffs'))

  local ok, git_show = pcall(require, 'follow-diffs.git')
  if ok then
    -- Create :GitShow command
    vim.api.nvim_create_user_command('GitShow', function(opts)
      local commit = opts.args ~= '' and opts.args or 'HEAD'
      git_show.show_commit(commit)
    end, {
      nargs = '?',
      desc = 'Show git commit with follow-diffs rendering',
    })
    vim.notify('GitShow command loaded ✓', vim.log.levels.INFO)
  end
end, 100)

-- Neogit
require('neogit').setup({
  integrations = { diffview = true },
})
vim.keymap.set('n', '<leader>g', '<cmd>Neogit<cr>', { desc = 'Open Neogit' })

-- diffview
require('diffview').setup({
  view = {
    default = { layout = "diff1_plain" },
    file_history = { layout = "diff1_plain" },
  },
})

-- unified diff folding + file preview for ft=diff buffers
-- requires this shell function in zshrc:
--   gd() { git diff ${1:-HEAD} | nvim -c "set ft=diff" -c "let b:diff_range='${1:-HEAD}'" - }
-- usage: gd HEAD~3..HEAD, gd 70724f5^..70724f5, etc.
-- diff-syntax.nvim: syntax highlighting inside .diff files
vim.opt.runtimepath:append(vim.fn.expand('~/diff-syntax.nvim'))
require('diff-syntax').setup({ theme = 'graphite' })

-- Diff buffer keymaps (go/gn/gd for version viewing, g-/g+/g= for filtering)
-- These use git and are specific to this config, not part of the plugin.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "diff",
  callback = function()
    vim.keymap.set('n', 'go', function() _G.diff_show_version('old') end, { buffer = true })
    vim.keymap.set('n', 'gn', function() _G.diff_show_version('new') end, { buffer = true })
    -- g-/g+/g= view filtering now lives in diff-syntax.nvim (gm to cycle, g= to restore)
  end,
})

-- find the "diff --git a/... b/..." header above the cursor
local function current_diff_paths()
  local lnum = vim.fn.line('.')
  while lnum > 0 do
    local line = vim.fn.getline(lnum)
    local a, b = line:match('^diff %-%-git a/(.+) b/(.+)$')
    if a then return a, b end
    lnum = lnum - 1
  end
end

-- stash/restore diff content
local diff_stash = {}  -- bufnr -> { lines, diff_range }

function _G.diff_show_version(version)
  local bufnr = vim.api.nvim_get_current_buf()
  local a_path, b_path = current_diff_paths()
  if not a_path then
    vim.notify("no diff --git header found above cursor", vim.log.levels.WARN)
    return
  end

  local range = vim.b.diff_range or 'HEAD'
  diff_stash[bufnr] = {
    lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false),
    range = range,
  }

  local ref, path
  if version == 'old' then
    local old_ref = range:match('^(.-)%.%.') or (range .. '^')
    ref, path = old_ref, a_path
  else
    local new_ref = range:match('%.%.(.+)$') or range
    ref, path = new_ref, b_path
  end

  local result = vim.fn.systemlist('git show ' .. ref .. ':' .. path .. ' 2>&1')
  if vim.v.shell_error ~= 0 then
    vim.notify("git show failed: " .. table.concat(result, '\n'), vim.log.levels.ERROR)
    diff_stash[bufnr] = nil
    return
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, result)
  vim.bo[bufnr].filetype = vim.filetype.match({ filename = path }) or 'text'
  vim.keymap.set('n', 'gd', function() _G.diff_restore(bufnr) end, { buffer = true })
end

function _G.diff_restore(bufnr)
  local stash = diff_stash[bufnr]
  if not stash then return end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, stash.lines)
  vim.b[bufnr].diff_range = stash.range
  vim.bo[bufnr].filetype = 'diff'
  diff_stash[bufnr] = nil
end


vim.opt.termguicolors = true

-- Line numbers
vim.opt.number = true        -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers

-- Folding settings — nvim-ufo takes over foldmethod
vim.opt.foldcolumn = '0'
vim.opt.foldlevel = 99      -- start with everything open
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.defer_fn(function()
  local ok, ufo = pcall(require, 'ufo')
  if not ok then return end

  ufo.setup({
    provider_selector = function(bufnr, filetype, buftype)
      -- diff/sem buffers keep their custom foldexpr
      if filetype == 'diff' or filetype == 'sem' then return '' end
      return { 'treesitter', 'indent' }
    end,
  })

  -- zR/zM through ufo (smoother than native)
  vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'UFO: open all folds' })
  vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'UFO: close all folds' })
  -- zK to peek inside a fold without opening it
  vim.keymap.set('n', 'zK', ufo.peekFoldedLinesUnderCursor, { desc = 'UFO: peek fold' })
  -- z0/z1/z2 to set fold level directly
  vim.keymap.set('n', 'z0', function() ufo.closeFoldsWith(0) end, { desc = 'Fold level 0' })
  vim.keymap.set('n', 'z1', function() ufo.closeFoldsWith(1) end, { desc = 'Fold level 1' })
  vim.keymap.set('n', 'z2', function() ufo.closeFoldsWith(2) end, { desc = 'Fold level 2' })
  vim.keymap.set('n', 'z3', function() ufo.closeFoldsWith(3) end, { desc = 'Fold level 3' })
end, 100)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.foldminlines = 0
  end,
})

-- Basic bufferline setup
vim.defer_fn(function()
  local ok, bufferline = pcall(require, "bufferline")
  if ok then
    bufferline.setup{}
  end
end, 100)

-- Enhanced Treesitter setup with folding
vim.defer_fn(function()
  local ok, ts = pcall(require, 'nvim-treesitter.configs')
  if ok then
    ts.setup({
    ensure_installed = { 
        "python",
        "lua",
        "vim",
        "javascript",
        "typescript",
        "json",
    },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    },
    })
  end
end, 100)

-- Indentation settings
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.shiftwidth = 2        -- Number of spaces for each indentation
vim.opt.tabstop = 2           -- Number of spaces for a tab
vim.opt.softtabstop = 2       -- Number of spaces a tab counts for in insert mode
vim.opt.autoindent = true     -- Copy indent from current line when starting a new line
vim.opt.smartindent = true    -- Smart autoindenting when starting a new line

vim.cmd.colorscheme "catppuccin"

-- Set up Comment.nvim
vim.defer_fn(function()
  -- lspfuzzy first, in its own pcall — so failures elsewhere in this block don't skip it
  local ok_lspfuzzy, lspfuzzy = pcall(require, 'lspfuzzy')
  if ok_lspfuzzy then
    local ok_setup, err = pcall(lspfuzzy.setup, {})
    if not ok_setup then vim.notify('lspfuzzy.setup failed: ' .. tostring(err), vim.log.levels.ERROR) end
    -- Required for Neovim 0.11+: hijack each LSP client's request method
    -- (the global vim.lsp.handlers table is no longer the only dispatch path)
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          client.request = lspfuzzy.wrap_request(client.request)
        end
      end,
    })
  else
    vim.notify('lspfuzzy require failed: ' .. tostring(lspfuzzy), vim.log.levels.ERROR)
  end

  local ok_telescope, telescope = pcall(require, "telescope")
  if ok_telescope then
    pcall(telescope.setup, {})
  end

  local ok, comment = pcall(require, 'Comment')
  if ok then
    pcall(comment.setup)
  end
end, 100)

-- CMP completion setup
vim.defer_fn(function()
  local ok_cmp, cmp = pcall(require, "cmp")
  if not ok_cmp then
    return
  end
  local source_defaults = {}
  local ok_cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp_lsp then
    source_defaults = require("cmp_nvim_lsp").default_capabilities()
  end
  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<Esc>"] = cmp.mapping.abort(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
    }),
  })
  local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
  if ok_lspconfig then
    lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config or {}, {
      capabilities = source_defaults,
    })
  end
end, 100)

-- Set up Mason and LSP
vim.defer_fn(function()
  local ok_mason, mason = pcall(require, "mason")
  if ok_mason then
    mason.setup()
  end
  local ok_mason_lsp, mason_lsp = pcall(require, "mason-lspconfig")
  if ok_mason_lsp then
    mason_lsp.setup({
      ensure_installed = { "ts_ls" },
      automatic_installation = true,
    })
  end

  local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
  if ok_lspconfig then
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp_lsp then
      capabilities = cmp_lsp.default_capabilities(capabilities)
    end

    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "tsx", "jsx" },
      root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", ".git", vim.fn.getcwd()),
    })

    lspconfig.pyright.setup({
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            -- "workspace" pre-indexes the whole project so cross-file lookups
            -- (gr, workspace symbols) are fast after warm-up. Trades startup
            -- cost for steady-state perf. "openFilesOnly" is the default and
            -- makes references slow for files pyright hasn't seen yet.
            diagnosticMode = "workspace",
            useLibraryCodeForTypes = true,
            autoSearchPaths = true,
          },
        },
      },
    })
  end
end, 100)

-- LSP configurations handled by mason-lspconfig automatically

local diagnostics_active = false
local function toggle_diagnostics()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })
    else
        vim.diagnostic.config({
            virtual_text = false,
            signs = false,
            underline = false,
            update_in_insert = false,
            severity_sort = true,
        })
    end
end

-- Keymaps
vim.keymap.set('n', '<space>e', toggle_diagnostics, { noremap = true })
vim.keymap.set('t', '<S-Esc>', '<C-\\><C-n>', { noremap = true })

-- -- Comment keymaps using Cmd + / (for macOS)
-- i dont think these work lol
vim.keymap.set('n', '<D-/>', 'gcc', { noremap = true })  -- Comment line in normal mode
vim.keymap.set('v', '<D-/>', 'gc', { noremap = true })   -- Comment selection in visual mode

-- LSP keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
-- fzf.vim keymaps (replaces Telescope; Telescope still installed but unbound)
vim.keymap.set('n', '<leader>f', ':Files<cr>',   { desc = "Find files" })
vim.keymap.set('n', '<leader>/', ':Rg<cr>',      { desc = "Live grep" })
vim.keymap.set('n', '<leader>b', ':Buffers<cr>', { desc = "Buffers" })

-- Folding keymaps
vim.keymap.set('n', 'zf', 'zf', { noremap = true })  -- Create fold
vim.keymap.set('n', 'za', 'za', { noremap = true })  -- Toggle fold
vim.keymap.set('n', 'zo', 'zo', { noremap = true })  -- Open fold
vim.keymap.set('n', 'zc', 'zc', { noremap = true })  -- Close fold
vim.keymap.set('n', 'zR', 'zR', { noremap = true })  -- Open all folds
vim.keymap.set('n', 'zM', 'zM', { noremap = true })  -- Close all folds


-- Set up GitSigns with minimal config
vim.defer_fn(function()
  local ok, gitsigns = pcall(require, 'gitsigns')
  if ok then
    gitsigns.setup({
  -- Just use default settings
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    -- Only the most essential keymaps
    vim.keymap.set('n', ']c', gs.next_hunk, {buffer=bufnr})
    vim.keymap.set('n', '[c', gs.prev_hunk, {buffer=bufnr})
    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {buffer=bufnr})
    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {buffer=bufnr})
    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {buffer=bufnr})
  end
    })
  end
end, 100)

-- Minimal completion setup (manual trigger only)
vim.defer_fn(function()
  local ok, cmp = pcall(require, 'cmp')
  if ok then
    cmp.setup({
      completion = {
        autocomplete = false,  -- Disable auto-trigger
      },
      mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),  -- Manual trigger
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Esc>'] = cmp.mapping.abort(),
      },
      sources = {
        { name = 'nvim_lsp' },
      }
    })
  end
end, 300)


-- Set up dingllm
vim.defer_fn(function()
  local ok, dingllm = pcall(require, 'dingllm')
  if ok then
    local helpful_prompt = 'You are a helpful assistant. What I have sent are my notes so far.'
    local system_prompt = 'You should replace the code that you are sent, only following the comments. Do not talk at all. Only output valid code. Do not provide any backticks that surround the code. Never ever output backticks like this ```. Any comment that is asking you for something should be removed after you satisfy them. Other comments should left alone. Do not output backticks. You should feel free to think out loud in inline comments or docstrings'

    local function anthropic_help()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.anthropic.com/v1/messages',
        model = 'claude-3-5-sonnet-20241022',
        api_key_name = 'ANTHROPIC_API_KEY',
        system_prompt = helpful_prompt,
        replace = false,
      }, dingllm.make_anthropic_spec_curl_args, dingllm.handle_anthropic_spec_data)
    end

    local function anthropic_replace()
      dingllm.invoke_llm_and_stream_into_editor({
        url = 'https://api.anthropic.com/v1/messages',
        model = 'claude-3-5-sonnet-20241022',
        api_key_name = 'ANTHROPIC_API_KEY',
        system_prompt = system_prompt,
        replace = true,
      }, dingllm.make_anthropic_spec_curl_args, dingllm.handle_anthropic_spec_data)
    end

    -- Set up keymaps (original streaming mode)
    vim.keymap.set({ 'n', 'v' }, '<leader>k', anthropic_replace, { desc = 'LLM replace with Claude' })
    vim.keymap.set({ 'n', 'v' }, '<leader>i', anthropic_help, { desc = 'LLM help with Claude' })

    -- Multi-file refactor keybindings (calls Python tool)
    -- Usage: write task as trailing comment, press <leader>r + key
    local refactor_cmd = 'python -m tools.refactor.refactor'
    local refactor_dir = '~/research/rollouts'

    local function run_refactor(model, thinking)
      local file = vim.fn.expand('%:p')
      vim.cmd('write')  -- Save current file first
      vim.cmd(string.format(
        'split | terminal cd %s && %s %s --model %s --thinking %s',
        refactor_dir,
        refactor_cmd,
        vim.fn.shellescape(file),
        model,
        thinking
      ))
    end

    -- Claude Sonnet
    vim.keymap.set('n', '<leader>rs', function() run_refactor('anthropic/claude-sonnet-4-5-20250929', 'medium') end, { desc = 'Refactor: Sonnet' })
    vim.keymap.set('n', '<leader>rS', function() run_refactor('anthropic/claude-sonnet-4-5-20250929', 'high') end, { desc = 'Refactor: Sonnet (high)' })

    -- GPT-5.1
    vim.keymap.set('n', '<leader>rg', function() run_refactor('openai/gpt-5.1', 'medium') end, { desc = 'Refactor: GPT-5.1' })
    vim.keymap.set('n', '<leader>rG', function() run_refactor('openai/gpt-5.1', 'high') end, { desc = 'Refactor: GPT-5.1 (high)' })

    -- Gemini 3
    vim.keymap.set('n', '<leader>ri', function() run_refactor('google/gemini-3-pro-preview', 'medium') end, { desc = 'Refactor: Gemini 3' })
    vim.keymap.set('n', '<leader>rI', function() run_refactor('google/gemini-3-pro-preview', 'high') end, { desc = 'Refactor: Gemini 3 (high)' })

    -- Claude Opus
    vim.keymap.set('n', '<leader>ro', function() run_refactor('anthropic/claude-opus-4-1-20250805', 'medium') end, { desc = 'Refactor: Opus' })
    vim.keymap.set('n', '<leader>rO', function() run_refactor('anthropic/claude-opus-4-1-20250805', 'high') end, { desc = 'Refactor: Opus (high)' })

    -- Dry run (preview prompt)
    vim.keymap.set('n', '<leader>rd', function()
      local file = vim.fn.expand('%:p')
      vim.cmd('write')
      vim.cmd(string.format(
        'split | terminal cd %s && %s %s --dry-run',
        refactor_dir,
        refactor_cmd,
        vim.fn.shellescape(file)
      ))
    end, { desc = 'Refactor: Dry run (preview)' })
  end
end, 400)




-- Set up 99 (AI plugin)
vim.defer_fn(function()
  local ok, _99 = pcall(require, "99")
  if ok then
    _99.setup({})
    vim.keymap.set("v", "<leader>9v", function() _99.visual() end, { desc = "99: visual AI replace" })
    vim.keymap.set("n", "<leader>9s", function() _99.search() end, { desc = "99: AI search" })
  end
end, 400)

require('lean').setup{ mappings = true }

-- Set up orgmode
vim.defer_fn(function()
  local ok, orgmode = pcall(require, 'orgmode')
  if ok then
    orgmode.setup({
      org_agenda_files = {'~/org/**/*'},
      org_default_notes_file = '~/org/notes.org',
    })
  end
end, 100)


-- Terminal buffer naming
local function term_with_name(cmd)
  local name = vim.fn.input("buffer name: ")
  vim.cmd("terminal " .. (cmd or ""))
  if name ~= "" then
    vim.cmd("keepalt file term " .. vim.fn.fnameescape(name))
  end
end

vim.api.nvim_create_user_command('Term', function(opts)
  term_with_name(opts.args)
end, { nargs = '*' })

vim.cmd('cabbrev term Term')

vim.api.nvim_create_user_command('TermRename', function(opts)
  vim.cmd("keepalt file term " .. vim.fn.fnameescape(opts.args))
end, { nargs = 1 })
vim.cmd('cabbrev termrename TermRename')

vim.keymap.set('n', '<leader>tr', ':termrename ', { noremap = true })

-- netrw: classic single-pane browser that *enters* dirs on <CR>
vim.g.netrw_liststyle = 0        -- 0 (thin) or 1 (long). **not** 3 (tree)
vim.g.netrw_browse_split = 0     -- reuse the same window
vim.g.netrw_keepdir = 0          -- update cwd to the dir you enter (like `nvim .`)
vim.g.netrw_use_errorwindow = 0
vim.g.netrw_banner = 0

