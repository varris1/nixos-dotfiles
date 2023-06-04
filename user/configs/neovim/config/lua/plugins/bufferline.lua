require("bufferline").setup({
  options = {
    show_tab_indicators = true,
    -- separator_style = { "", "" },
    indicator = { style = "icon", icon = "" },
    color_icons = true,
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        text_align = "center",
        separator = true,
      },
    },
  },
})
