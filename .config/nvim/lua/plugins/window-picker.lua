return {
  "s1n7ax/nvim-window-picker",
  version = "2.*",
  lazy = true,
  opts = {
    hint = "floating-big-letter",
    filter_rules = {
      include_current_win = false,
      autoselect_one = true,
      bo = {
        filetype = {
          "snacks_layout_box",
          "snacks_picker_list",
          "snacks_picker_input",
          "snacks_picker_preview",
          "notify",
        },
        buftype = { "terminal", "quickfix" },
      },
    },
  },
}
