vim.g.mapleader = " "

local Plug = vim.fn["plug#"]
vim.call("plug#begin")

Plug("catppuccin/nvim", { ["as"] = "catppuccin" })
Plug("nvim-tree/nvim-web-devicons")
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
Plug("numToStr/Comment.nvim")

Plug("nvim-lua/plenary.nvim")
Plug("junegunn/fzf", { ["do"] = function() vim.fn["fzf#install"]() end })
Plug("junegunn/fzf.vim")

Plug("tpope/vim-fugitive")
Plug("sindrets/diffview.nvim")
Plug("NeogitOrg/neogit")
Plug("sgeb/vim-diff-fold")
Plug("lewis6991/gitsigns.nvim")

Plug("chiraagbalu/diff-syntax.nvim")

vim.call("plug#end")

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.foldmethod = "indent"

pcall(vim.cmd.colorscheme, "catppuccin")

local ok_neogit, neogit = pcall(require, "neogit")
if ok_neogit then
  neogit.setup({
    integrations = { diffview = true },
  })
end

local ok_diffview, diffview = pcall(require, "diffview")
if ok_diffview then
  diffview.setup({
    view = {
      default = { layout = "diff1_plain" },
      file_history = { layout = "diff1_plain" },
    },
  })
end

local ok_diff_syntax, diff_syntax = pcall(require, "diff-syntax")
if ok_diff_syntax then
  diff_syntax.setup({ theme = "graphite" })
end

vim.defer_fn(function()
  local ok, comment = pcall(require, "Comment")
  if ok then
    comment.setup()
  end
end, 100)

vim.defer_fn(function()
  local ok, ts = pcall(require, "nvim-treesitter.configs")
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
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
end, 100)

vim.keymap.set("n", "<leader>g", "<cmd>Neogit<cr>", { desc = "Open Neogit" })
vim.keymap.set("n", "<leader>f", ":Files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>/", ":Rg<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>b", ":Buffers<cr>", { desc = "Buffers" })

vim.keymap.set("n", "zf", "zf", { noremap = true })
vim.keymap.set("n", "za", "za", { noremap = true })
vim.keymap.set("n", "zo", "zo", { noremap = true })
vim.keymap.set("n", "zc", "zc", { noremap = true })
vim.keymap.set("n", "zR", "zR", { noremap = true })
vim.keymap.set("n", "zM", "zM", { noremap = true })

vim.defer_fn(function()
  local ok, gitsigns = pcall(require, "gitsigns")
  if ok then
    gitsigns.setup({
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "]c", gs.next_hunk, { buffer = bufnr, desc = "Next hunk" })
        vim.keymap.set("n", "[c", gs.prev_hunk, { buffer = bufnr, desc = "Previous hunk" })
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
        vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
        vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
      end,
    })
  end
end, 100)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "diff",
  callback = function()
    vim.keymap.set("n", "go", function() _G.diff_show_version("old") end, { buffer = true, desc = "Show old file" })
    vim.keymap.set("n", "gn", function() _G.diff_show_version("new") end, { buffer = true, desc = "Show new file" })
  end,
})

local function current_diff_paths()
  local lnum = vim.fn.line(".")
  while lnum > 0 do
    local line = vim.fn.getline(lnum)
    local a_path, b_path = line:match("^diff %-%-git a/(.+) b/(.+)$")
    if a_path then
      return a_path, b_path
    end
    lnum = lnum - 1
  end
end

local diff_stash = {}

function _G.diff_show_version(version)
  local bufnr = vim.api.nvim_get_current_buf()
  local a_path, b_path = current_diff_paths()
  if not a_path then
    vim.notify("no diff --git header found above cursor", vim.log.levels.WARN)
    return
  end

  local range = vim.b.diff_range or "HEAD"
  diff_stash[bufnr] = {
    lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false),
    range = range,
  }

  local ref, path
  if version == "old" then
    ref = range:match("^(.-)%.%.") or (range .. "^")
    path = a_path
  else
    ref = range:match("%.%.(.+)$") or range
    path = b_path
  end

  local result = vim.fn.systemlist({ "git", "show", ref .. ":" .. path })
  if vim.v.shell_error ~= 0 then
    vim.notify("git show failed: " .. table.concat(result, "\n"), vim.log.levels.ERROR)
    diff_stash[bufnr] = nil
    return
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, result)
  vim.bo[bufnr].filetype = vim.filetype.match({ filename = path }) or "text"
  vim.keymap.set("n", "gd", function() _G.diff_restore(bufnr) end, { buffer = true, desc = "Restore diff" })
end

function _G.diff_restore(bufnr)
  local stash = diff_stash[bufnr]
  if not stash then
    return
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, stash.lines)
  vim.b[bufnr].diff_range = stash.range
  vim.bo[bufnr].filetype = "diff"
  diff_stash[bufnr] = nil
end

vim.g.netrw_liststyle = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_keepdir = 0
vim.g.netrw_use_errorwindow = 0
vim.g.netrw_banner = 0
