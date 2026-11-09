vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.winborder = "rounded"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
--Writing
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_gb"
    vim.opt_local.colorcolumn = "80"
    vim.keymap.set('n', '<leader>ss', 'z=', { desc = 'Spell Suggestions' })
  end,
})
--Reload
vim.keymap.set('n', '<leader>o', ':update<CR> :source %<CR>', { desc = 'Reload Neovim script' })
--File controls
vim.keymap.set('n', '<leader>w', vim.cmd.write, { desc = 'Write' })             --Write
vim.keymap.set('n', '<leader>W', ':write!<CR>', { desc = 'Force Write' })      --Force write
vim.keymap.set('n', '<leader>q', vim.cmd.quit, { desc = 'Quit' })               --Quit
vim.keymap.set('n', '<leader>Q', ':quit!<CR>', { desc = 'Force Quit' })        --Force quit
vim.keymap.set('n', '<leader>x', ':wq<CR>', { desc = 'Write and Quit' })       --Write and quit
--Terminal
vim.keymap.set('n', '<leader>t', ':terminal<CR>', { desc = 'Enter terminal' }) --Enter terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal' })       --Exit terminal
--Clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'copy' })       --copy
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"+d', { desc = 'cut' })        --cut
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'paste' })      --paste
--Move selected lines
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })
--Scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll to bottom of view' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll to top of view' })
--Window management
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { desc = 'Create vertical split' })  --Create verticle split
vim.keymap.set('n', '<leader>sh', ':split<CR>', { desc = 'Create horizontal split' }) --Create horizontal split
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to a left window' })            --Movement
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to a below window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to an above window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to a right window' })
-- Resize splits with Alt + direction
vim.keymap.set('n', '<A-h>', '<C-w><', { desc = 'Decrease split width' })
vim.keymap.set('n', '<A-l>', '<C-w>>', { desc = 'Increase split width' })
vim.keymap.set('n', '<A-j>', '<C-w>-', { desc = 'Decrease split height' })
vim.keymap.set('n', '<A-k>', '<C-w>+', { desc = 'Increase split height' })
--Buffer management
-- vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Move to next buffer' })
-- vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Move to previos buffer' })
vim.keymap.set('n',   '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', { desc = 'Close other buffers' })
vim.keymap.set('n', '<leader>bp', '<cmd>BufferLinePick<CR>', { desc = 'Pick buffer' })
--Pickers
vim.keymap.set('n', '<leader>f', ':Pick files<CR>', { desc = 'Open file picker' })
vim.keymap.set('n', '<leader>h', ':Pick help<CR>', { desc = 'Open help picker' })
vim.keymap.set('n', '<leader>e', function() require('mini.files').open() end, { desc = 'Open file explorer' })
vim.keymap.set("n", "<leader>sg", ":Pick grep_live<CR>", { desc = "Search project" })
--Git
-- vim.keymap.set('n', '<leader>g', ":LazyGit<CR>", { desc = 'Open lazy git' })
vim.keymap.set('n', '<leader>g', ":terminal lazygit<CR>", { desc = 'Open lazy git' })
--Plugins
vim.pack.add({ --local plugins
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  --Git
  -- { src = "https://github.com/kdheepak/lazygit.nvim" },
  --LSP
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  --Notes
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  --UI
  { src = "https://github.com/stevearc/aerial.nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" }
})
require "mini.icons".setup()
require "mini.pick".setup({ source = { files = { tool = { "fd", "--type", "f", "--hidden", "--exclude", ".git" } } } })
require "mini.files".setup({ windows = { preview = true } })
require "mini.cmdline".setup()
require "mini.diff".setup({ view = { style = 'sign' } })
require "mini.statusline".setup()
require "mini.comment".setup()
local MiniMisc = require "mini.misc"
MiniMisc.setup()
MiniMisc.setup_auto_root()
--LSP servers
require "nvim-treesitter.config".setup({
  ensure_installed = { "lua", "python", "c", "cpp", "c_sharp", "html", "css", "javascript", "typescript", "jsx", "tsx", "astro", "json", "markdown", "markdown_inline", "bash" },
  highlight = { enable = true }
})
vim.lsp.enable({ "lua_ls", "basedpyright", "clangd", "omnisharp", "html", "cssls", "ts_ls", "astro", "marksman", "jsonls", "bashls", "emmetls" })
vim.api.nvim_create_autocmd('LspAttach', { --lsp autocompletion
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    --LSP controls
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { buffer = ev.buf, desc = 'LSP: Format file' })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'LSP: view definition' })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = 'LSP: view references' })
    vim.keymap.set('n', '<K>', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'LSP: View hover' })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'LSP: Rename symbol' })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'LSP: Code action' })
  end,
})
vim.cmd("set completeopt+=noselect")
vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  end
  return "<Tab>"
end, { expr = true })
--external files
package.path = os.getenv("HOME") .. "/.config/nvim/?.lua;" .. package.path
require "execution"
require "plugins.aerial"
require "plugins.bufferline"
--appearance
vim.cmd("colorscheme kanagawa-wave")
