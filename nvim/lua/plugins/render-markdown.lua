return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    { "nvim-tree/nvim-web-devicons", lazy = true },
  },
  ft = { "markdown" },
  opts = {
    heading = {
      enabled = true,
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      enabled = true,
      sign = true,
      style = "full",
      width = "block",
      border = "thin",
    },
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰱒 " },
    },
    pipe_table = {
      enabled = true,
      style = "full",
    },
  },
  keys = {
    { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Render Markdown (toggle)" },
  },
}
