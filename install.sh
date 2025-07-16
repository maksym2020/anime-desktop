#!/bin/bash

echo "⏳ Встановлення Anime Desktop Environment..."

mkdir -p ~/anime-desktop/{themes,icons,fonts,wallpapers,music,scripts,autostart}

echo "🎨 Встановлення тем і іконок..."
git clone https://github.com/EliverLara/Sweet.git ~/anime-desktop/themes/Sweet
sudo apt install -y papirus-icon-theme

echo "🔤 Встановлення шрифтів..."
mkdir -p ~/.local/share/fonts
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip -o /tmp/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv

echo "🖼️ Завантаження шпалер..."
cd ~/anime-desktop/wallpapers
for i in {1..10}; do
  curl -s -O https://raw.githubusercontent.com/makxdev/anime-wallpapers/main/lofi$i.jpg
done

echo "🎵 Завантаження музики..."
cd ~/anime-desktop/music
for i in {1..5}; do
  curl -s -O https://raw.githubusercontent.com/makxdev/anime-music/main/track$i.mp3
done

echo "🔊 Створення скрипта автозапуску музики..."
cat << EOF > ~/anime-desktop/scripts/start_music.sh
#!/bin/bash
cvlc --play-and-exit --volume 512 ~/anime-desktop/music/track1.mp3 &
for i in {1..10}; do
  sleep 2
  pactl set-sink-volume @DEFAULT_SINK@ -5%
done
EOF
chmod +x ~/anime-desktop/scripts/start_music.sh

mkdir -p ~/.config/autostart
cat << EOF > ~/.config/autostart/lofi-music.desktop
[Desktop Entry]
Type=Application
Exec=/bin/bash \$HOME/anime-desktop/scripts/start_music.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Anime Lofi Startup Music
Comment=Play lofi track with fade
EOF

echo "🕒 Налаштування автоматичної зміни шпалер..."
(crontab -l 2>/dev/null; echo "0 * * * * DISPLAY=:0 feh --bg-scale --randomize ~/anime-desktop/wallpapers/*") | crontab -

echo "🌊 Встановлення Latte Dock..."
sudo apt install -y latte-dock

echo "✅ Встановлення завершено!"
echo "📦 Перезавантаж систему або вийди з сесії Plasma, щоб зміни вступили в силу."
