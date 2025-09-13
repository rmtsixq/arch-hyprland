# Hyprland Rice Kurulum Rehberi

Bu rehber, Arch Linux üzerinde bu Hyprland rice'ını kurmak için gerekli adımları açıklar.

## 🚀 Hızlı Kurulum

### Otomatik Kurulum (Önerilen)

```bash
# Scripti çalıştırılabilir yap
chmod +x setup.sh

# Kurulumu başlat
./setup.sh
```

### Manuel Kurulum

Eğer otomatik kurulum istemiyorsanız, aşağıdaki adımları takip edebilirsiniz.

## 📋 Gereksinimler

- Arch Linux (veya Arch tabanlı dağıtım)
- AUR helper (yay veya paru)
- İnternet bağlantısı

## 📦 Gerekli Paketler

### Ana Paketler
```bash
sudo pacman -S --needed \
    hyprland hypridle hyprlock hyprpaper waybar swaync swww \
    kitty zsh yazi rofi-wayland nautilus firefox thunderbird \
    discord spotify vesktop telegram-desktop fastfetch cava \
    grim slurp hyprpicker brightnessctl pavucontrol blueman \
    network-manager-applet polkit-gnome xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk ttf-jetbrains-mono-nerd ttf-font-awesome \
    ttf-material-design-icons adwaita-icon-theme colloid-icon-theme \
    wlogout jq curl wget git
```

### AUR Paketleri
```bash
yay -S --needed matugen hyprland-nvidia
```

## ⚙️ Konfigürasyon

### 1. Konfigürasyon Dosyalarını Kopyala

```bash
# Ana .config klasörünü oluştur
mkdir -p ~/.config

# Tüm konfigürasyonları kopyala
cp -r .config/* ~/.config/

# Script dosyalarını çalıştırılabilir yap
chmod +x ~/.config/hypr/scripts/*.sh
```

### 2. Wallpaper Klasörünü Hazırla

```bash
# Wallpaper klasörünü oluştur
mkdir -p ~/Pictures/wallpapers

# Wallpaper'ları kopyala
cp wallpapers/* ~/Pictures/wallpapers/

# İlk wallpaper'ı ayarla
swww init
swww img ~/Pictures/wallpapers/37.jpg
ln -sf ~/Pictures/wallpapers/37.jpg ~/.config/hypr/current_wallpaper
```

### 3. Zsh Konfigürasyonu

```bash
# Zsh konfigürasyonunu kopyala
cp .zshrc ~/

# Zsh'i varsayılan shell yap
chsh -s /bin/zsh
```

### 4. Sistem Servislerini Etkinleştir

```bash
# Kullanıcı servislerini etkinleştir
systemctl --user enable hypridle
systemctl --user enable hyprlock
```

### 5. Hyprland Oturumunu Etkinleştir

```bash
# .xinitrc dosyasına ekle
echo "exec Hyprland" >> ~/.xinitrc
```

### 6. Desktop Dosyası Oluştur

```bash
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/hyprland.desktop << EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF
```

### 7. Renk Şemasını Oluştur

```bash
# Matugen ile renk şeması oluştur
matugen image ~/Pictures/wallpapers/37.jpg
```

## 🎮 Kullanım

### Temel Kısayollar

| Kısayol | Açıklama |
|---------|----------|
| `Super + Enter` | Terminal aç |
| `Super + D` | Uygulama menüsü |
| `Super + Q` | Aktif pencereyi kapat |
| `Super + W` | Wallpaper seçici |
| `Super + L` | Ekranı kilitle |
| `Super + R` | Waybar'ı yeniden başlat |
| `Super + H` | Waybar'ı gizle/göster |
| `Super + Ctrl + B` | Waybar stilleri |
| `Super + Alt + B` | Waybar düzeni |

### Özellikler

- **Matugen**: Otomatik renk şeması oluşturma
- **Swww**: Wallpaper yönetimi
- **Waybar**: Modern status bar
- **Rofi**: Uygulama launcher
- **SwayNC**: Bildirim merkezi
- **Hyprlock**: Ekran kilidi
- **Cava**: Ses görselleştirme

## 🔧 Özelleştirme

### Wallpaper Değiştirme

```bash
# Wallpaper seçiciyi aç
Super + W

# Manuel olarak wallpaper ayarla
swww img /path/to/wallpaper.jpg
matugen image /path/to/wallpaper.jpg
```

### Waybar Stilleri

```bash
# Waybar stillerini değiştir
Super + Ctrl + B

# Stil dosyaları: ~/.config/waybar/style/
```

### Renk Şeması

```bash
# Yeni wallpaper ile renk şeması oluştur
matugen image /path/to/wallpaper.jpg

# Manuel renk ayarları: ~/.config/hypr/colors.conf
```

## 🐛 Sorun Giderme

### Yaygın Sorunlar

1. **Waybar görünmüyor**
   ```bash
   # Waybar'ı yeniden başlat
   Super + R
   ```

2. **Wallpaper yüklenmiyor**
   ```bash
   # Swww'yi yeniden başlat
   pkill swww
   swww init
   swww img ~/Pictures/wallpapers/37.jpg
   ```

3. **Renkler doğru görünmüyor**
   ```bash
   # Matugen'i yeniden çalıştır
   matugen image ~/Pictures/wallpapers/37.jpg
   ```

4. **Ses çalışmıyor**
   ```bash
   # PulseAudio'yu yeniden başlat
   pulseaudio --kill
   pulseaudio --start
   ```

### Log Dosyaları

```bash
# Hyprland logları
journalctl --user -u hyprland

# Waybar logları
waybar --log-level debug
```

## 📁 Dosya Yapısı

```
~/.config/
├── hypr/                 # Hyprland konfigürasyonu
│   ├── hyprland.conf     # Ana konfigürasyon
│   ├── colors.conf       # Renk şeması
│   ├── configs/          # Alt konfigürasyonlar
│   └── scripts/          # Özel scriptler
├── waybar/               # Waybar konfigürasyonu
├── rofi/                 # Rofi konfigürasyonu
├── kitty/                # Terminal konfigürasyonu
├── swaync/               # Bildirim merkezi
├── matugen/              # Renk şeması oluşturucu
└── cava/                 # Ses görselleştirme
```

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add amazing feature'`)
4. Push yapın (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 🙏 Teşekkürler

- [JaKooLit](https://github.com/JaKooLit) - Scriptler ve Waybar ayarları için
- [Matugen](https://github.com/InioX/matugen) - Renk şeması oluşturucu için
- [Hyprland](https://github.com/hyprwm/Hyprland) - Wayland compositor için

---

**Not**: Bu rice, Arch Linux üzerinde test edilmiştir. Diğer dağıtımlarda bazı paket isimleri farklı olabilir.
