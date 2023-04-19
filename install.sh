#!/bin/bash
# dwm.sh
# This script will install dwm and all of its dependencies

SHELL_FOLDER=$(
    cd "$(dirname "$0")" || exit
    pwd
)

function installAlacritty() {
    # Install dependencies
    if sudo pacman -S cmake pkg-config; then
        echo "Dependencies installed successfully"
    else
        echo "Dependencies failed to install"
        exit 1
    fi

    # Install Alacritty
    if yay -S alacritty tmux; then
        echo "Alacritty installed successfully"
    else
        echo "Alacritty failed to install"
        exit 1
    fi

    if [ -d ~/.config/alacritty ]; then
        if rm -rf ~/.config/alacritty/alacritty.yml; then
            echo "Alacritty config file deleted successfully"
        else
            echo "Alacritty config file failed to delete"
            exit 1
        fi

        if cp "$SHELL_FOLDER"/alacritty.yml.bak ~/.config/alacritty/alacritty.yml; then
            echo "Alacritty config file copied successfully"
        else
            echo "Alacritty config file failed to copy"
            exit 1
        fi
    else
        mkdir -p ~/.config/alacritty
        if cp "$SHELL_FOLDER"/alacritty.yml.bak ~/.config/alacritty/alacritty.yml; then
            echo "Alacritty config file copied successfully"
        else
            echo "Alacritty config file failed to copy"
            exit 1
        fi
    fi

    if [ -f ~/.tmux.conf ]; then
        if ! rm -rf ~/.tmux.conf; then
            echo "Tmux config file failed to delete"
            exit 1
        fi

        if cp "$SHELL_FOLDER"/tmux.conf.bak ~/.tmux.conf; then
            echo "Tmux config file copied successfully"
        else
            echo "Tmux config file failed to copy"
            exit 1
        fi
    else
        if cp "$SHELL_FOLDER"/tmux.conf.bak ~/.tmux.conf; then
            echo "Tmux config file copied successfully"
        else
            echo "Tmux config file failed to copy"
            exit 1
        fi
    fi
}

# Install dependencies
if sudo pacman -S xorg-xinit xdg-user-dirs-gtk xsetroot xorg xorg-apps yay base-devel git make; then
    echo "Dependencies installed successfully"
else
    echo "Dependencies failed to install"
    exit 1
fi

# Install Dependent program
if yay -S dunst picom flameshot feh bluetoothctl coproc rofi slock st; then
    echo "Dependent programs installed successfully"
else
    echo "Dependent programs failed to install"
    exit 1
fi

# Install fonts
if yay -S wqy-microhei wps-office-mui-zh-cn ttf-wps-fonts nerd-fonts-jetbrains-mono ttf-material-design-icons ttf-joypixels ttf-dejavu; then
    echo "Fonts installed successfully"
else
    echo "Fonts failed to install"
    exit 1
fi

# Install Alacritty
installAlacritty

# Install dwm
if sudo make clean install; then
    echo "dwm installed successfully"
else
    echo "dwm failed to install"
    exit 1
fi

# Join the lightdm
if [ -d /user/share/xsessions ]; then
    if cat >/usr/share/xsessions/dwm.desktop <<EOF; then
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=dynamic window manager
Exec=/usr/local/bin/dwm
Icon=dwm
Type=XSession
EOF
        echo "dwm.desktop created successfully"
    else
        echo "dwm.desktop failed to create"
        exit 1
    fi
else
    echo "lightdm not installed"
    exit 1
fi

# Config scripts
if [ -d ~/scripts ]; then
    if cp "$SHELL_FOLDER"/scripts/* ~/scripts; then
        echo "Scripts copied successfully"
    else
        echo "Scripts failed to copy"
        exit 1
    fi
else
    mkdir ~/scripts
    if cp "$SHELL_FOLDER"/scripts/* ~/scripts; then
        echo "Scripts copied successfully"
    else
        echo "Scripts failed to copy"
        exit 1
    fi
fi

chmod +x ~/scripts/*.sh

if [ -d ~/.dwm ]; then
    if cp "$SHELL_FOLDER"/DEF/* ~/.dwm; then
        echo "Dwm config files copied successfully"
    else
        echo "Dwm config files failed to copy"
        exit 1
    fi
else
    mkdir ~/.dwm
    if cp "$SHELL_FOLDER"/DEF/* ~/.dwm; then
        echo "Dwm config files copied successfully"
    else
        echo "Dwm config files failed to copy"
        exit 1
    fi
fi

if find ~/.dwm -type f -name "*.sh" -exec chmod +x {} \;; then
    echo "Scripts permissions changed successfully"
else
    echo "Scripts permissions failed to change"
    exit 1
fi