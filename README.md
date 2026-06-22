# 🛠️ My Scripts

A collection of bash scripts for automating everyday tasks on Ubuntu.

---

## 📦 Script List

| Script | Description | Schedule | Docs |
|--------|-------------|----------|------|
| `stretching-reminder.sh` | Hourly stretching notification during work hours | Mon–Fri, 08:00–17:00 | [📄 View](stretching-reminder.md) |
| _(next script)_ | | | |

---

## 📁 Directory Structure

```
~/.local/bin/
├── README.md                  ← this file
├── TEMPLATE.md                ← documentation template for new scripts
├── stretching-reminder.sh
├── stretching-reminder.md
└── ...
```

---

## 🚀 Initial Setup (After Reinstalling the OS)

```bash
# 1. Create the directory if it doesn't exist
mkdir -p ~/.local/bin

# 2. Clone from GitHub (if already backed up)
git clone https://github.com/username/my-scripts.git ~/.local/bin

# 3. Make all scripts executable
chmod +x ~/.local/bin/*.sh

# 4. Re-register all cron jobs
crontab -e
```

For per-script setup details, refer to each script's documentation file in the **Docs** column of the table above.

---

## ➕ Adding a New Script

1. Copy the documentation template:
   ```bash
   cp ~/.local/bin/TEMPLATE.md ~/.local/bin/new-script-name.md
   ```

2. Fill in the documentation for the new script.

3. Add a new row to the **Script List** table in this file.

---

## ☁️ Backup

This repo is backed up to GitHub:

```
https://github.com/username/my-scripts
```

```bash
# Push latest changes
cd ~/.local/bin
git add .
git commit -m "add: new-script-name"
git push
```
