return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    cursor_style = {
      normal = "line",
      insert = "line",
      terminal = "line",
    }, require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        size = 20,
        open_mapping = [[<c-j>]],
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = 'horizontal',
        close_on_exit = true,
        clear_env = false,
        persist_size = true,
        direction = "horizontal",
        auto_scroll = true,
        shell = vim.o.shell,
    })
  end,
}
