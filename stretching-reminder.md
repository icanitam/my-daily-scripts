# 🧘 Stretching Reminder

A bash script that reminds you to do light stretching every hour during work hours (08:00–17:00), with a desktop notification and a soft bell sound.

---

## 📋 Features

- Automatic desktop notification every hour (08:00–17:00)
- Soft bell sound when notification appears
- Different exercise variation each hour (squats, neck stretch, shoulders, back, etc.)
- Runs automatically in the background via crontab
- Active Monday–Friday only (configurable)
- Activity log saved automatically

---

## 🖥️ System Requirements

- Ubuntu / Linux with a desktop environment (GNOME, KDE, XFCE, etc.)
- `libnotify-bin` — for the `notify-send` command
- `pulseaudio-utils` — for the `paplay` command (sound)

Install dependencies:

```bash
sudo apt install libnotify-bin pulseaudio-utils
```

---

## 📁 File Structure

```
~/.local/bin/
└── stretching-reminder.sh   ← main script

~/
└── stretching-reminder.log  ← activity log (created automatically)
```

---

## 🚀 Installation

### 1. Create the directory (if it doesn't exist)

```bash
mkdir -p ~/.local/bin
```

### 2. Save the script

```bash
nano ~/.local/bin/stretching-reminder.sh
```

Paste the script content into the file, then save with `Ctrl+O` and exit with `Ctrl+X`.

### 3. Make it executable

```bash
chmod +x ~/.local/bin/stretching-reminder.sh
```

### 4. Register with crontab

```bash
crontab -e
```

Add the following line at the bottom:

```
# Stretching Reminder — Monday to Friday, 08:00–17:00
0 8-17 * * 1-5 /bin/bash ~/.local/bin/stretching-reminder.sh >> ~/stretching-reminder.log 2>&1
```

---

## ✅ Manual Test

Run the script directly to make sure the notification appears:

```bash
bash ~/.local/bin/stretching-reminder.sh
```

---

## 📊 Checking the Log

```bash
# Follow the latest log in real time
tail -f ~/stretching-reminder.log

# View the full log
cat ~/stretching-reminder.log
```

Sample log output:

```
[2025-06-10 08:00] Reminder sent: 🏋️ Light squats – 10 reps, keep your back straight
[2025-06-10 09:00] Reminder sent: 🙆 Shoulder stretch – lift & roll shoulders backward 10x
```

---

## 🔧 Customization

### Change active hours

Edit the crontab line — for example, active from 09:00–16:00:

```
0 9-16 * * 1-5 /bin/bash ~/.local/bin/stretching-reminder.sh >> ~/stretching-reminder.log 2>&1
```

### Enable on weekends too

Change `1-5` to `*`:

```
0 8-17 * * * /bin/bash ~/.local/bin/stretching-reminder.sh >> ~/stretching-reminder.log 2>&1
```

### Add or change exercises

Edit the `EXERCISES` array inside the script:

```bash
EXERCISES=(
    "🧘 Neck stretch – slowly rotate head 5x left & right"
    "🏋️ Light squats – 10 reps, keep your back straight"
    # add new exercises here
)
```

---

## 🐛 Troubleshooting

### Notification doesn't appear from crontab

Crontab runs without a desktop session, so it needs the `DBUS_SESSION_BUS_ADDRESS` variable. Run this to get the correct value:

```bash
echo $DBUS_SESSION_BUS_ADDRESS
```

Then hardcode it at the top of the script:

```bash
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
#                                                      ^^^^
#                                 replace with your User ID (check with: id -u)
```

### No sound

Make sure `paplay` is available:

```bash
which paplay
```

If not found, install it:

```bash
sudo apt install pulseaudio-utils
```

### Check if the cron job is registered

```bash
crontab -l
```

---

## 🔄 After Reinstalling the OS

1. Install dependencies:
   ```bash
   sudo apt install libnotify-bin pulseaudio-utils
   ```

2. Recreate the directory and copy the script:
   ```bash
   mkdir -p ~/.local/bin
   # copy stretching-reminder.sh to ~/.local/bin/
   chmod +x ~/.local/bin/stretching-reminder.sh
   ```

3. Re-register the cron job:
   ```bash
   crontab -e
   # re-add the crontab line from the Installation section above
   ```

> 💡 **Tip:** Back up this script to a private GitHub repository so it's easy to restore after a reinstall. See the Backup section below.

---

## ☁️ Backup to GitHub (Optional but Recommended)

```bash
cd ~/.local/bin
git init
git add stretching-reminder.sh
git commit -m "add: stretching reminder script"
git remote add origin https://github.com/username/my-scripts.git
git push -u origin main
```

After reinstalling, simply run:

```bash
git clone https://github.com/username/my-scripts.git ~/.local/bin
chmod +x ~/.local/bin/stretching-reminder.sh
crontab -e  # re-register the cron job
```

---

## 📄 License

Free to use and modify for personal use.
