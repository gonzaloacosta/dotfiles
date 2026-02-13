return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
      -- Show symlinks with arrow indicator
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".git",
          ".DS_Store",
        },
      },
    },
    default_component_configs = {
      -- Configure symlink display
      symlink_target = {
        enabled = true,
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
      -- Customize icon for symlinks
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        folder_empty_open = "",
        default = "",
      },
      git_status = {
        symbols = {
          -- Add a different symbol for symlinks in git
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
    window = {
      width = 35,
      mappings = {
        -- Show symlink target on hover
        ["l"] = "open",
        ["h"] = "close_node",
      },
    },
    -- Custom renderer for symlinks
    renderers = {
      file = {
        { "icon" },
        { "name", use_git_status_colors = true },
        -- Show symlink arrow and target
        {
          "symlink_target",
          highlight = "NeoTreeSymbolicLinkTarget",
        },
        { "git_status", highlight = "NeoTreeGitStatus" },
      },
    },
  },
  init = function()
    -- Custom highlight for symlinks
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        -- Make symlink targets visible with distinct color
        vim.api.nvim_set_hl(0, "NeoTreeSymbolicLinkTarget", {
          fg = "#7aa2f7",  -- Blue color for symlink targets
          italic = true,
        })
        -- Make symlink file names slightly different
        vim.api.nvim_set_hl(0, "NeoTreeFileNameSymlink", {
          fg = "#bb9af7",  -- Purple-ish color
          italic = true,
        })
      end,
    })

    -- Trigger the highlights for current colorscheme
    vim.schedule(function()
      vim.cmd("doautocmd ColorScheme")
    end)
  end,
}
