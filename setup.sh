#!/bin/bash

# ===============================================
# HYPRLAND RICE SETUP SCRIPT
# ===============================================
# Bu script, Hyprland rice'ını kurmak için gerekli tüm paketleri yükler
# ve konfigürasyon dosyalarını doğru yerlere kopyalar.

set -e

# Renkli çıktı için
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logo
echo -e "${BLUE}"
echo "  _    _ _       _ _                   _     _ "
echo " | |  | | |     | | |                 | |   | |"
echo " | |  | | |_ __ | | |_ _ __ __ _ _ __ | |__ | |"
echo " | |/\| | | '_ \| | | | '__/ _\` | '_ \| '_ \| |"
echo " \  /\  / | |_) | | | | | | (_| | | | | |_) | |"
echo "  \/  \/|_| .__/|_|_|_|  \__,_|_| |_|_.__/|_|"
echo "          | |"
echo "          |_|"
echo -e "${NC}"
echo -e "${YELLOW}Hyprland Rice Setup Script${NC}"
echo "=================================="

# Sistem kontrolü
echo -e "${BLUE}[INFO]${NC} Sistem kontrolü yapılıyor..."

# Arch Linux kontrolü
if ! grep -q "Arch Linux" /etc/os-release 2>/dev/null; then
    echo -e "${RED}[HATA]${NC} Bu script sadece Arch Linux için tasarlanmıştır!"
    exit 1
fi

# Root kontrolü
if [[ $EUID -eq 0 ]]; then
    echo -e "${RED}[HATA]${NC} Bu scripti root olarak çalıştırmayın!"
    exit 1
fi

# AUR helper kontrolü
if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
    echo -e "${YELLOW}[UYARI]${NC} AUR helper bulunamadı. Yay kuruluyor..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
fi

# AUR helper seçimi
if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
else
    echo -e "${RED}[HATA]${NC} AUR helper kurulamadı!"
    exit 1
fi

echo -e "${GREEN}[OK]${NC} Sistem hazır!"

# Gerekli paketleri yükle
echo -e "${BLUE}[INFO]${NC} Gerekli paketler yükleniyor..."

# Ana paketler
PACKAGES=(
    # Hyprland ve Wayland
    "hyprland"
    "hypridle"
    "hyprlock"
    "hyprpaper"
    "waybar"
    "swaync"
    "swww"
    
    # Terminal ve Shell
    "kitty"
    "zsh"
    "yazi"
    
    # Uygulamalar
    "rofi-wayland"
    "nautilus"
    "firefox"
    "thunderbird"
    "discord"
    "spotify"
    "vesktop"
    "telegram-desktop"
    
    # Sistem araçları
    "fastfetch"
    "cava"
    "grim"
    "slurp"
    "hyprpicker"
    "brightnessctl"
    "pavucontrol"
    "blueman"
    "network-manager-applet"
    "polkit-gnome"
    "xdg-desktop-portal-hyprland"
    "xdg-desktop-portal-gtk"
    
    # Fontlar
    "ttf-jetbrains-mono-nerd"
    "ttf-font-awesome"
    "ttf-material-design-icons"
    "adwaita-icon-theme"
    "colloid-icon-theme"
    
    # Diğer
    "wlogout"
    "jq"
    "curl"
    "wget"
    "git"
)

# AUR paketleri
AUR_PACKAGES=(
    "matugen"
    "hyprland-nvidia"
)

echo -e "${BLUE}[INFO]${NC} Ana paketler yükleniyor..."
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

echo -e "${BLUE}[INFO]${NC} AUR paketleri yükleniyor..."
$AUR_HELPER -S --needed --noconfirm "${AUR_PACKAGES[@]}"

# Konfigürasyon dosyalarını kopyala
echo -e "${BLUE}[INFO]${NC} Konfigürasyon dosyaları kopyalanıyor..."

# Ana .config klasörünü oluştur
mkdir -p ~/.config

# Hyprland konfigürasyonu
echo -e "${BLUE}[INFO]${NC} Hyprland konfigürasyonu kopyalanıyor..."
cp -r .config/hypr ~/.config/

# Waybar konfigürasyonu
echo -e "${BLUE}[INFO]${NC} Waybar konfigürasyonu kopyalanıyor..."
cp -r .config/waybar ~/.config/

# Rofi konfigürasyonu
echo -e "${BLUE}[INFO]${NC} Rofi konfigürasyonu kopyalanıyor..."
cp -r .config/rofi ~/.config/

# Kitty konfigürasyonu
echo -e "${BLUE}[INFO]${NC} Kitty konfigürasyonu kopyalanıyor..."
cp -r .config/kitty ~/.config/

# SwayNC konfigürasyonu
echo -e "${BLUE}[INFO]${NC} SwayNC konfigürasyonu kopyalanıyor..."
cp -r .config/swaync ~/.config/

# Matugen konfigürasyonu
echo -e "${BLUE}[INFO]${NC} Matugen konfigürasyonu kopyalanıyor..."
cp -r .config/matugen ~/.config/

# Cava konfigürasyonu
echo -e "${BLUE}[INFO]${NC} Cava konfigürasyonu kopyalanıyor..."
cp -r .config/cava ~/.config/

# Fastfetch konfigürasyonu
echo -e "${BLUE}[INFO]${NC} Fastfetch konfigürasyonu kopyalanıyor..."
cp -r .config/fastfetch ~/.config/

# Wlogout konfigürasyonu
echo -e "${BLUE}[INFO]${NC} Wlogout konfigürasyonu kopyalanıyor..."
cp -r .config/wlogout ~/.config/

# Wallpaper klasörünü oluştur ve duvarları kopyala
echo -e "${BLUE}[INFO]${NC} Wallpaper klasörü oluşturuluyor..."
mkdir -p ~/Pictures/wallpapers
cp wallpapers/* ~/Pictures/wallpapers/

# Script dosyalarını çalıştırılabilir yap
echo -e "${BLUE}[INFO]${NC} Script dosyaları çalıştırılabilir yapılıyor..."
chmod +x ~/.config/hypr/scripts/*.sh

# Zsh konfigürasyonu
echo -e "${BLUE}[INFO]${NC} Zsh konfigürasyonu kopyalanıyor..."
if [ -f .zshrc ]; then
    cp .zshrc ~/
fi

# Sistem servislerini etkinleştir
echo -e "${BLUE}[INFO]${NC} Sistem servisleri etkinleştiriliyor..."
systemctl --user enable hypridle
systemctl --user enable hyprlock

# Hyprland oturumunu etkinleştir
echo -e "${BLUE}[INFO]${NC} Hyprland oturumu etkinleştiriliyor..."
if ! grep -q "Hyprland" ~/.xinitrc 2>/dev/null; then
    echo "exec Hyprland" >> ~/.xinitrc
fi

# Desktop dosyası oluştur
echo -e "${BLUE}[INFO]${NC} Desktop dosyası oluşturuluyor..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/hyprland.desktop << EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF

# İlk wallpaper'ı ayarla
echo -e "${BLUE}[INFO]${NC} İlk wallpaper ayarlanıyor..."
if [ -f ~/Pictures/wallpapers/37.jpg ]; then
    swww init
    swww img ~/Pictures/wallpapers/37.jpg
    ln -sf ~/Pictures/wallpapers/37.jpg ~/.config/hypr/current_wallpaper
fi

# Matugen ile renk şeması oluştur
echo -e "${BLUE}[INFO]${NC} Renk şeması oluşturuluyor..."
if [ -f ~/Pictures/wallpapers/37.jpg ]; then
    matugen image ~/Pictures/wallpapers/37.jpg
fi

# Tamamlandı mesajı
echo -e "${GREEN}"
echo "=================================="
echo "  KURULUM TAMAMLANDI! 🎉"
echo "=================================="
echo -e "${NC}"

echo -e "${YELLOW}Sonraki adımlar:${NC}"
echo "1. Sistemi yeniden başlatın"
echo "2. Giriş ekranında 'Hyprland' seçin"
echo "3. İlk girişte terminal açmak için: Super + Enter"
echo "4. Uygulama menüsü için: Super + D"
echo "5. Wallpaper değiştirmek için: Super + W"
echo "6. Waybar stillerini değiştirmek için: Super + Ctrl + B"

echo -e "${BLUE}Önemli notlar:${NC}"
echo "- NVIDIA kartınız varsa 'hyprland-nvidia' paketi kuruldu"
echo "- Tüm konfigürasyonlar ~/.config/ klasöründe"
echo "- Wallpaper'lar ~/Pictures/wallpapers/ klasöründe"
echo "- Script dosyaları ~/.config/hypr/scripts/ klasöründe"

echo -e "${GREEN}İyi kullanımlar! 🚀${NC}"
