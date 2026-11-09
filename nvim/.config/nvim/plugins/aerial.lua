require("aerial").setup({
  backends = { "lsp", "treesitter", "markdown" },
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Struct"
  }
})
vim.keymap.set("n", "<leader>s", "<cmd>AerialToggle!<CR>", { desc = "Toggle code outline" })
