#!/usr/bin/env bash
#!/usr/bin/env bash

set -u

# Detect theme 
CURRENT_THEME=$(xfconf-query -c xsettings -p /Net/ThemeName 2>/dev/null || echo "")

if [[ "$CURRENT_THEME" == "Materia-dark-compact" ]]; then
    NEW_THEME="Materia-light-compact"
    NEW_ICONS="Papirus"
    KV="MateriaLight"
    G_MODE="prefer-light"
    GTK_DARK="false"
    FP_THEME="org.gtk.Gtk3theme.Materia"
else
    NEW_THEME="Materia-dark-compact"
    NEW_ICONS="Papirus-Dark"
    KV="MateriaDark"
    G_MODE="prefer-dark"
    GTK_DARK="true"
    FP_THEME="org.gtk.Gtk3theme.Materia-dark"
fi

# XFCE Config
if command -v xfconf-query >/dev/null 2>&1; then
    xfconf-query -c xsettings -p /Net/ThemeName -s "$NEW_THEME"
    xfconf-query -c xsettings -p /Net/IconThemeName -s "$NEW_ICONS"
    xfconf-query -c xfwm4 -p /general/theme -s "$NEW_THEME"
fi

# GNOME / GTK 
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface color-scheme "$G_MODE" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface gtk-theme "$NEW_THEME" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "$NEW_ICONS" 2>/dev/null || true
fi

mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"

cat > "$HOME/.config/gtk-3.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=$NEW_THEME
gtk-icon-theme-name=$NEW_ICONS
gtk-application-prefer-dark-theme=$GTK_DARK
EOF

cat > "$HOME/.config/gtk-4.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=$NEW_THEME
gtk-icon-theme-name=$NEW_ICONS
gtk-application-prefer-dark-theme=$GTK_DARK
EOF

# Kvantum
if command -v kvantummanager >/dev/null 2>&1; then
    kvantummanager --set "$KV" >/dev/null 2>&1 || true
fi

# Flatpak 
if command -v flatpak >/dev/null 2>&1; then
   flatpak install -y flathub "$FP_THEME" org.gtk.Gtk3theme.Papirus >/dev/null 2>&1 || true

    # Global environment overrides for Flatpak apps
    flatpak override --user \
        --env=GTK_THEME="$NEW_THEME" \
        --env=ADW_DEBUG_COLOR_SCHEME="$G_MODE" \
        --filesystem="$HOME/.themes:ro" \
        --filesystem="$HOME/.icons:ro" \
        --filesystem="$HOME/.config/gtk-3.0:ro" \
        --filesystem="$HOME/.config/gtk-4.0:ro" >/dev/null 2>&1
fi

# Reload XFCE 
if command -v xfsettingsd >/dev/null 2>&1; then
    xfsettingsd --replace >/dev/null 2>&1 &
fi
