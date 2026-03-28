return {
  "echasnovski/mini.bufremove",
  keys = {
    { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "关闭当前 buffer" },
  },
}
