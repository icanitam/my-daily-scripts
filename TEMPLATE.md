# [emoji] Script Name

> One short sentence describing what this script does.

---

## 📋 Summary

| Info | Detail |
|------|--------|
| **File** | `script-name.sh` |
| **Location** | `~/.local/bin/script-name.sh` |
| **Run by** | Manual / Crontab / Systemd |
| **Schedule** | _(e.g. Every day at 23:00, or Mon–Fri 08:00–17:00)_ |
| **Created** | YYYY-MM-DD |
| **Last updated** | YYYY-MM-DD |

---

## ✨ Features

- First feature
- Second feature
- Third feature

---

## 🖥️ System Requirements

```bash
sudo apt install package-1 package-2
```

| Package | Purpose |
|---------|---------|
| `package-1` | What it's used for |
| `package-2` | What it's used for |

---

## 🚀 Installation

### 1. Copy script to directory

```bash
cp script-name.sh ~/.local/bin/
chmod +x ~/.local/bin/script-name.sh
```

### 2. Register with crontab _(if scheduled)_

```bash
crontab -e
```

Add the following line:

```
# Brief description of this cron job
* * * * * /bin/bash ~/.local/bin/script-name.sh >> ~/script-name.log 2>&1
```

---

## ▶️ Usage

### Run manually

```bash
bash ~/.local/bin/script-name.sh
```

### With arguments _(if any)_

```bash
bash ~/.local/bin/script-name.sh --option value
```

| Argument | Description | Default |
|----------|-------------|---------|
| `--option` | Explanation | `default_value` |

---

## ⚙️ Customization

Variables you can change directly inside the script:

```bash
# Inside script-name.sh
VARIABLE_1=value     # Brief explanation
VARIABLE_2=value     # Brief explanation
```

---

## 📊 Log

```bash
# Follow the latest log in real time
tail -f ~/script-name.log

# View the full log
cat ~/script-name.log

# Clear old log
> ~/script-name.log
```

Sample normal log output:

```
[2025-06-10 08:00] Success log message
[2025-06-10 09:00] Success log message
```

---

## 🐛 Troubleshooting

### Common issue 1

**Symptom:** What happens  
**Cause:** Why it happens  
**Fix:**

```bash
command to resolve
```

### Common issue 2

**Symptom:** What happens  
**Cause:** Why it happens  
**Fix:**

```bash
command to resolve
```

---

## 🔄 After Reinstalling the OS

```bash
# 1. Install dependencies
sudo apt install package-1 package-2

# 2. Copy script and make it executable
cp script-name.sh ~/.local/bin/
chmod +x ~/.local/bin/script-name.sh

# 3. Re-register the cron job (if applicable)
crontab -e
```

---

## 📝 Notes

- Additional notes worth remembering
- Things to watch out for
