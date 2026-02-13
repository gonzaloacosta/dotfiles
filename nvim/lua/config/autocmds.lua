-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Auto-open neo-tree when opening a directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    -- Check if the argument is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    if directory then
      -- Change to the directory
      vim.cmd.cd(data.file)
      -- Open neo-tree
      require("neo-tree.command").execute({ toggle = false, dir = data.file })
    end
  end,
})
