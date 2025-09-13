#!/bin/bash

# The following will attempt to install all needed packages to run Hyprland
# This is a quick and dirty script there are no error checking
# This script is meant to run on a clean fresh system
#
# Below is a list of the packages that would be installed
#
# hyprland: This is the Hyprland compositor
# hypridle: This is the idle daemon for Hyprland
# hyprlock: This allows for the locking of the desktop
# waybar: Waybar now has hyprland support
# swaync: This is a graphical notification daemon
# swww: This is used to set a desktop background image
# kitty: This is the default terminal
# rofi-wayland: This is an application launcher menu
# wlogout: This is a logout menu that allows for shutdown, reboot and sleep
# nautilus: This is a graphical file manager
# ttf-jetbrains-mono-nerd: Some nerd fonts for icons and overall look
# ttf-font-awesome: Font awesome icons
# ttf-material-design-icons: Material design icons
# polkit-gnome: needed to get superuser access on some graphical application
# xdg-desktop-portal-hyprland: xdg-desktop-portal backend for hyprland
# matugen: Color scheme generator
# cava: Audio visualizer
# fastfetch: System information tool
# grim: This is a screenshot tool it grabs images from a Wayland compositor
# slurp: This helps with screenshots, it selects a region in a Wayland compositor
# hyprpicker: Color picker for Hyprland
# brightnessctl: used to control monitor bright level
# pavucontrol: Audio control panel
# blueman: Bluetooth manager
# network-manager-applet: Network manager applet
# wlogout: Logout menu

#### Check for yay ####
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then 
    echo -e "yay was located, moving on.\n"
    yay -Suy
else 
    echo -e "yay was not located, please install yay. Exiting script.\n"
    exit 
fi

### Disable wifi powersave mode ###
read -n1 -rep 'Would you like to disable wifi powersave? (y,n)' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
    LOC="/etc/NetworkManager/conf.d/wifi-powersave.conf"
    echo -e "The following has been added to $LOC.\n"
    echo -e "[connection]\nwifi.powersave = 2" | sudo tee -a $LOC
    echo -e "\n"
    echo -e "Restarting NetworkManager service...\n"
    sudo systemctl restart NetworkManager
    sleep 3
fi

### Install all of the above packages ####
read -n1 -rep 'Would you like to install the packages? (y,n)' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
    yay -S --noconfirm hyprland hypridle hyprlock waybar swaync swww \
    kitty rofi-wayland wlogout nautilus ttf-jetbrains-mono-nerd \
    ttf-font-awesome ttf-material-design-icons adwaita-icon-theme \
    colloid-icon-theme polkit-gnome xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk grim slurp hyprpicker brightnessctl \
    pavucontrol blueman network-manager-applet fastfetch cava \
    wlogout jq curl wget git

    # Install AUR packages
    echo -e "Installing AUR packages...\n"
    yay -S --noconfirm matugen hyprland-nvidia

    # Start the bluetooth service
    echo -e "Starting the Bluetooth Service...\n"
    sudo systemctl enable --now bluetooth.service
    sleep 2
    
    # Clean out other portals
    echo -e "Cleaning out conflicting xdg portals...\n"
    yay -R --noconfirm xdg-desktop-portal-gnome
fi

### Copy Config Files ###
read -n1 -rep 'Would you like to copy config files? (y,n)' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "Copying config files...\n"
    cp -R .config/hypr ~/.config/
    cp -R .config/waybar ~/.config/
    cp -R .config/rofi ~/.config/
    cp -R .config/kitty ~/.config/
    cp -R .config/swaync ~/.config/
    cp -R .config/matugen ~/.config/
    cp -R .config/cava ~/.config/
    cp -R .config/fastfetch ~/.config/
    cp -R .config/wlogout ~/.config/
    
    # Set some files as executable 
    chmod +x ~/.config/hypr/scripts/*.sh
fi

### Copy wallpapers ###
read -n1 -rep 'Would you like to copy wallpapers? (y,n)' WALL
if [[ $WALL == "Y" || $WALL == "y" ]]; then
    echo -e "Copying wallpapers...\n"
    mkdir -p ~/Pictures/wallpapers
    cp wallpapers/* ~/Pictures/wallpapers/
    
    # Set first wallpaper
    echo -e "Setting first wallpaper...\n"
    swww init
    swww img ~/Pictures/wallpapers/37.jpg
    ln -sf ~/Pictures/wallpapers/37.jpg ~/.config/hypr/current_wallpaper
fi

### Install the zsh shell ###
read -n1 -rep 'Would you like to install the zsh shell? (y,n)' ZSH
if [[ $ZSH == "Y" || $ZSH == "y" ]]; then
    # install zsh
    echo -e "Installing zsh...\n"
    yay -S --noconfirm zsh
    echo -e "Setting zsh as default shell...\n"
    chsh -s /bin/zsh
    echo -e "Copying zsh config file to ~/.config ...\n"
    cp .zshrc ~/
fi

### Generate color scheme ###
read -n1 -rep 'Would you like to generate color scheme? (y,n)' COLOR
if [[ $COLOR == "Y" || $COLOR == "y" ]]; then
    echo -e "Generating color scheme...\n"
    if [ -f ~/Pictures/wallpapers/37.jpg ]; then
        matugen image ~/Pictures/wallpapers/37.jpg
    fi
fi

### Enable user services ###
read -n1 -rep 'Would you like to enable user services? (y,n)' SERV
if [[ $SERV == "Y" || $SERV == "y" ]]; then
    echo -e "Enabling user services...\n"
    systemctl --user enable hypridle
    systemctl --user enable hyprlock
fi

### Create desktop entry ###
read -n1 -rep 'Would you like to create desktop entry? (y,n)' DESK
if [[ $DESK == "Y" || $DESK == "y" ]]; then
    echo -e "Creating desktop entry...\n"
    mkdir -p ~/.local/share/applications
    cat > ~/.local/share/applications/hyprland.desktop << EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF
fi

### Script is done ###
echo -e "Script had completed.\n"
echo -e "You can start Hyprland by typing Hyprland (note the capital H).\n"
echo -e "Key bindings:\n"
echo -e "Super + Enter: Open terminal\n"
echo -e "Super + D: Open application menu\n"
echo -e "Super + W: Wallpaper picker\n"
echo -e "Super + L: Lock screen\n"
echo -e "Super + R: Restart waybar\n"
echo -e "Super + Ctrl + B: Waybar styles\n"
read -n1 -rep 'Would you like to start Hyprland now? (y,n)' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    exec Hyprland
else
    exit
fi
