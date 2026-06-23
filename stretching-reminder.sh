#!/bin/bash

# ============================================
#   STRETCHING REMINDER - Setiap Jam Kerja
# ============================================

DISPLAY=:0
export DISPLAY

# Ambil DBUS session untuk notifikasi desktop
USER_ID=$(id -u)
DBUS_FILE="/run/user/$USER_ID/bus"

if [ -S "$DBUS_FILE" ]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_FILE"
else
    export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS \
        /proc/$(pgrep -u $USER gnome-shell | head -1)/environ \
        2>/dev/null | tr -d '\0' | cut -d= -f2-)
fi

HOUR=$(date +%H)
EXERCISES=(
    "🧘 Stretch leher – putar kepala perlahan 5x kiri & kanan"
    "🏋️ Squat ringan – 10 kali, jaga punggung tetap lurus"
    "🙆 Stretch bahu – angkat & putar bahu ke belakang 10x"
    "🦵 Stretch kaki – berdiri & angkat tumit 10x"
    "💪 Stretch tangan – rentangkan jari & tahan 10 detik"
    "🔄 Rotasi pinggang – tangan di pinggang, putar badan 5x"
    "🧍 Stretch punggung – berdiri tegak, condong ke belakang 5x"
    "👁️ Istirahat mata – tutup mata & tatap jauh 20 detik"
    "🫁 Tarik napas dalam – hirup 4 detik, tahan 4, buang 4"
)

# Pilih gerakan secara bergantian berdasarkan jam
INDEX=$(( (10#$HOUR - 8) % ${#EXERCISES[@]} ))
EXERCISE="${EXERCISES[$INDEX]}"

# --- Bunyi Bel (pilih yang tersedia) ---
play_sound() {
    if command -v paplay &>/dev/null; then
        paplay /usr/share/sounds/freedesktop/stereo/bell.oga 2>/dev/null && return
        paplay /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null && return
    fi
    if command -v aplay &>/dev/null; then
        aplay /usr/share/sounds/alsa/Front_Center.wav 2>/dev/null && return
    fi
    if command -v ffplay &>/dev/null; then
        ffplay -nodisp -autoexit -f lavfi "sine=frequency=880:duration=0.3" 2>/dev/null
        sleep 0.5
        ffplay -nodisp -autoexit -f lavfi "sine=frequency=660:duration=0.5" 2>/dev/null
    fi
}

play_sound

# --- Tampilkan Notifikasi ---
notify-send \
    --urgency=normal \
    --icon="preferences-desktop-accessibility" \
    --expire-time=15000 \
    "🕐 Waktunya Stretching! (Jam $HOUR:00)" \
    "$EXERCISE\n\n⏱️ Hanya butuh 1–2 menit!\nYuk gerak sebentar! 💪"

echo "[$(date '+%Y-%m-%d %H:%M')] Reminder dikirim: $EXERCISE"
