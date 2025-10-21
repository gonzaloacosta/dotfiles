return {
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]() -- runs the npm install step
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Preview (toggle)" },
      { "<leader>mo", "<cmd>MarkdownPreview<CR>", desc = "Markdown Preview (open)" },
      { "<leader>mq", "<cmd>MarkdownPreviewStop<CR>", desc = "Markdown Preview (stop)" },
    },
    config = function()
      -- Do not auto-close the preview when leaving the buffer
      vim.g.mkdp_auto_close = 0
      -- Use your default browser; set explicitly if you prefer:
      -- vim.g.mkdp_browser = "Google Chrome"
      -- Only enable for markdown buffers
      vim.g.mkdp_filetypes = { "markdown" }
      -- Refresh on save only (reduce noise while typing)
      vim.g.mkdp_refresh_slow = 1
    end,
  },
}
