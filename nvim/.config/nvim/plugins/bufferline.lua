require("bufferline").setup({
  options = {
    mode = "buffers",
    style_preset = require("bufferline").style_preset.minimal,
    diagnostics = "nvim_lsp",
    show_buffer_close_icons = true,
    show_close_icon = false,
    separator_style = "thin",
  },
})
