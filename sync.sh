#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

action="${1:-save}"

case "$action" in
    save)
        echo "==> Saving desktop environment changes into git repo..."
        
        # 1. Hyprland configuration
        mkdir -p "$REPO_DIR/compositors/hyprland"
        rsync -av --exclude="*backup*" "$HOME_DIR/.config/hypr/" "$REPO_DIR/compositors/hyprland/"
        
        # 2. Serpantinum settings
        if [ -d "$HOME_DIR/.config/serpantinum" ]; then
            mkdir -p "$REPO_DIR/config/serpantinum"
            rsync -av "$HOME_DIR/.config/serpantinum/" "$REPO_DIR/config/serpantinum/"
        fi
        
        # 3. Serpantinum src (Quickshell UI, scripts)
        if [ -d "$HOME_DIR/.local/share/serpantinum/src" ]; then
            mkdir -p "$REPO_DIR/src"
            rsync -av --exclude="version.txt" "$HOME_DIR/.local/share/serpantinum/src/" "$REPO_DIR/src/"
        fi
        
        # 4. Serpantinum bin
        if [ -d "$HOME_DIR/.local/share/serpantinum/bin" ]; then
            mkdir -p "$REPO_DIR/bin"
            rsync -av "$HOME_DIR/.local/share/serpantinum/bin/" "$REPO_DIR/bin/"
        fi
        
        echo ""
        echo "==> Done! Git status:"
        git -C "$REPO_DIR" status -s
        ;;

    apply)
        echo "==> Applying repository changes to live system..."
        
        # 1. Hyprland
        if [ -d "$REPO_DIR/compositors/hyprland" ]; then
            mkdir -p "$HOME_DIR/.config/hypr"
            rsync -av --exclude="*backup*" "$REPO_DIR/compositors/hyprland/" "$HOME_DIR/.config/hypr/"
        fi
        
        # 2. Serpantinum settings
        if [ -d "$REPO_DIR/config/serpantinum" ]; then
            mkdir -p "$HOME_DIR/.config/serpantinum"
            rsync -av "$REPO_DIR/config/serpantinum/" "$HOME_DIR/.config/serpantinum/"
        fi
        
        # 3. Serpantinum src & bin
        if [ -d "$REPO_DIR/src" ]; then
            mkdir -p "$HOME_DIR/.local/share/serpantinum/src"
            rsync -av "$REPO_DIR/src/" "$HOME_DIR/.local/share/serpantinum/src/"
        fi
        if [ -d "$REPO_DIR/bin" ]; then
            mkdir -p "$HOME_DIR/.local/share/serpantinum/bin"
            rsync -av "$REPO_DIR/bin/" "$HOME_DIR/.local/share/serpantinum/bin/"
        fi
        
        echo ""
        echo "==> Reloading Hyprland and Serpantinum..."
        hyprctl reload 2>/dev/null || true
        serpantinum reload 2>/dev/null || true
        echo "==> Done!"
        ;;

    status)
        echo "==> Status in git repo:"
        git -C "$REPO_DIR" status
        ;;

    *)
        echo "Usage: ./sync.sh [save|apply|status]"
        echo "  save   - Copy changes from ~/.config/hypr, ~/.config/serpantinum, ~/.local/share/serpantinum into repo"
        echo "  apply  - Apply changes from repo to live system (~/.config/hypr, ~/.local/share/serpantinum)"
        echo "  status - Show git status of the repository"
        exit 1
        ;;
esac
