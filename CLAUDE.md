# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS using GNU Stow for symlink management. The configuration targets `~/.config` as the primary configuration directory and includes setups for terminal, editors, window managers, and development tools.

## Installation & Setup

### Initial Setup
```bash
# Install/update all dotfiles using stow
./setup.sh

# Or manually with stow
stow .
```

**Important**: Stow is configured via `.stowrc` to target `~/.config` as the installation directory, with specific ignore patterns for `.stowrc`, `DS_Store`, and `atuin/*`.

### Component-Specific Setup

**Tmux Plugin Manager (TPM):**
```bash
# First-time install
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install plugins (inside tmux)
# Press: Ctrl+A then Shift+I
```

**Hammerspoon Config Path:**
```bash
# Configure Hammerspoon to use ~/.config location
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
```

**Neovim (LazyVim):**
- First launch will auto-install lazy.nvim plugin manager
- Plugins auto-install on first run
- Config follows LazyVim structure

## Architecture & Key Components

### Configuration Structure

**Neovim (`nvim/`):**
- Based on LazyVim distribution
- Core config: `lua/config/` (autocmds, keymaps, options, lazy.lua)
- Custom plugins: `lua/plugins/` (codesnap, conform, copilot, go, markdown-preview, surround, theme, windsurf)
- Plugin manager: lazy.nvim with auto-bootstrap in `lua/config/lazy.lua`

**Tmux (`tmux/`):**
- Main config: `tmux.conf` with reset file: `tmux.reset.conf`
- Prefix key: `Ctrl+A` (not default Ctrl+B)
- Custom scripts: `scripts/` (aws_account.sh, kube_context.sh, cal.sh)
- Theme: Catppuccin (via omerxx fork)
- Key plugins: sessionx (session manager), floax (floating windows), aws-tmux, fzf integrations
- Important bindings:
  - `Ctrl+A =` - sessionx (session manager)
  - `Ctrl+A t` - floax (floating terminal)
- Sessionx custom paths include this dotfiles directory

**Shell (`zshrc/.zshrc`):**
- Extensive PATH management for Homebrew, dev tools
- Multi-language support: Java (jenv), Node (nvm), Go, Python (pyenv commented)
- AWS, Ansible, and SSH configuration
- Starship prompt integration

**Window Management:**
- `aerospace/` - AeroSpace tiling window manager (aerospace.toml)
- `skhd/` - Hotkey daemon with AppleScripts
- `hammerspoon/` - Lua-based automation (app launcher, calendar integration)
  - Uses spoons: AClock, GoMaCal
  - Custom hotkeys: Cmd+Alt+C (clock), Cmd+Alt+A (Arc browser), Alt+R (reload)

**Terminal:**
- `ghostty/` - Ghostty terminal emulator config
- `starship/` - Cross-shell prompt configuration (starship.toml)

**Status Bar:**
- `sketchybar/` - macOS status bar replacement
  - Main config: `sketchybarrc`
  - Helpers: `colors.sh`, `icons.sh`
  - Modular structure: `items/`, `plugins/`, `helper/`

**Other Tools:**
- `karabiner/` - Keyboard customization (karabiner.json)
- `atuin/` - Shell history management (ignored by stow)
- `nix-darwin/` - Nix package management (flake.nix, home.nix)
- `ssh/` - SSH configuration

## Common Commands

### Dotfiles Management
```bash
# Apply/update all configurations
stow .

# Remove all symlinks
stow -D .

# Dry run to see what would change
stow -n .

# Re-stow (useful after config changes)
stow -R .
```

### Tmux Operations
```bash
# Reload tmux config (or inside tmux: Ctrl+A then :source-file ~/.config/tmux/tmux.conf)
tmux source-file ~/.config/tmux/tmux.conf

# Install/update plugins (inside tmux)
# Ctrl+A then Shift+I

# List installed plugins
ls ~/.tmux/plugins/
```

### Neovim
```bash
# Launch Neovim
nvim

# Inside Neovim - LazyVim commands:
# :Lazy - Plugin manager UI
# :LazyExtras - Install optional LazyVim features
# :Mason - LSP/formatter/linter installer
# :checkhealth - Diagnostic info
```

### Hammerspoon
```bash
# Reload config (or use Alt+R hotkey)
hs.reload()

# Check console for errors
# Open Hammerspoon.app and check console
```

### Shell Tools
```bash
# Reload zsh config
source ~/.zshrc

# Check PATH
echo $PATH | tr ':' '\n'
```

## Development Workflow

### Making Configuration Changes

1. **Edit files directly** in the dotfiles directory structure
2. **Test changes** (reload the specific tool: tmux, nvim, hammerspoon, etc.)
3. **Commit changes** following the global git workflow preferences
4. Changes are live immediately due to stow symlinks

### Adding New Neovim Plugins

Create a new file in `nvim/lua/plugins/` following the pattern:
```lua
return {
  "username/plugin-name",
  config = function()
    -- plugin configuration
  end,
}
```

### Adding Tmux Plugins

Add to `tmux/tmux.conf`:
```bash
set -g @plugin 'author/plugin-name'
# Add plugin options as needed
```
Then reload tmux and press `Ctrl+A Shift+I` to install.

## Important Notes

- **Stow target**: All configs symlink to `~/.config/`, not `~/`
- **Tmux prefix**: Changed from default `Ctrl+B` to `Ctrl+A`
- **Neovim**: LazyVim-based, not vanilla Neovim - check LazyVim docs for conventions
- **macOS-specific**: Configuration heavily tailored for macOS (Homebrew paths, AeroSpace, SketchyBar)
- **Hammerspoon hardcoded path**: Contains reference to `/Users/omerxx/` in calendar config (line 23 of init.lua) - may need updating for different users
- **Multi-language dev**: Java 17, Node (nvm), Go, Python (pyenv) all configured in zshrc
- **AWS/K8s integration**: Tmux status bar shows AWS account, region, and Kubernetes context via custom scripts

## File Modification Considerations

- **Before editing tmux.conf**: Always source `tmux.reset.conf` first (already configured)
- **Karabiner**: JSON is auto-backed up in `automatic_backups/`
- **Neovim lockfile**: `nvim/lazy-lock.json` tracks exact plugin versions
- **Nix**: `nix-darwin/flake.lock` pins Nix dependencies

## References

- LazyVim documentation: https://lazyvim.github.io/
- GNU Stow manual: https://www.gnu.org/software/stow/manual/
- Tmux Plugin Manager: https://github.com/tmux-plugins/tpm
- AeroSpace WM: Check aerospace.toml for keybindings
- Starship prompt: https://starship.rs/config/
