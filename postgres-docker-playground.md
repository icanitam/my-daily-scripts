# 🐘 newdb.sh: PostgreSQL Playground

> Creates a separate database and user per demo/PoC inside a single PostgreSQL Docker container.

---

## 📋 Summary

| Info             | Detail                                             |
| ---------------- | -------------------------------------------------- |
| **File**         | `newdb.sh`                                         |
| **Location**     | `~/.local/bin/newdb.sh`                            |
| **Run by**       | Manual                                             |
| **Schedule**     | _(none; run whenever a new demo needs a database)_ |
| **Created**      | 2026-11-10                                         |
| **Last updated** | 2026-11-10                                         |

Related file: `~/.pg-playground/docker-compose.yml` (defines the Postgres container the script talks to).

---

## ✨ Features

- One Postgres instance serves many databases (tutorials, demos, PoCs)
- Each project gets its own database and its own user (role)
- Data persists in a Docker named volume, even if the container is recreated
- Port is bound to `127.0.0.1` only, so it is not exposed to the network
- Prints a ready-to-use connection string after creation
- Demo apps running in Docker can connect through a shared network

---

## 🖥️ System Requirements

```bash
sudo apt install docker.io docker-compose-v2
```

| Package             | Purpose                                             |
| ------------------- | --------------------------------------------------- |
| `docker.io`         | Container runtime                                   |
| `docker-compose-v2` | Provides `docker compose` to run the Postgres stack |

---

## 🚀 Installation

### 1. Create the Postgres container

```bash
mkdir -p ~/.pg-playground && cd ~/.pg-playground
```

Create `docker-compose.yml`:

```yaml
services:
  postgres:
    image: postgres:17
    container_name: pg-playground
    restart: unless-stopped
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: change_this_password
    ports:
      - "127.0.0.1:5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks: [shared]

volumes:
  pgdata:

networks:
  shared:
    name: shared
```

Start it:

```bash
docker compose up -d
```

| Setting                      | Reason                                                            |
| ---------------------------- | ----------------------------------------------------------------- |
| `127.0.0.1:5432:5432`        | Reachable only from your own machine (safe on public wifi)        |
| Named volume `pgdata`        | Data persists even if the container is deleted                    |
| `postgres:17` (not `latest`) | Avoids accidental major version upgrades that break existing data |
| `shared` network             | Lets demo apps in Docker reach Postgres by container name         |

### 2. Copy script to directory

Create `newdb.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

CONTAINER=pg-playground   # Postgres container name
PG_ADMIN=admin            # Superuser defined in docker-compose.yml
PG_HOST=localhost         # Host shown in the printed connection string
PG_PORT=5432              # Port shown in the printed connection string

NAME="${1:?Usage: newdb.sh <name> [password]}"
PASS="${2:-$NAME}"        # Default password = db name (fine for local use)

docker exec -i "$CONTAINER" psql -U "$PG_ADMIN" <<SQL
CREATE USER "$NAME" WITH PASSWORD '$PASS';
CREATE DATABASE "$NAME" OWNER "$NAME";
SQL

echo "postgresql://$NAME:$PASS@$PG_HOST:$PG_PORT/$NAME"
```

Install it:

```bash
cp newdb.sh ~/.local/bin/
chmod +x ~/.local/bin/newdb.sh
```

### 3. Register with crontab _(optional: nightly backup)_

Not needed for `newdb.sh` itself. If you want automatic backups of all databases:

```bash
crontab -e
```

Add the following line:

```
# Nightly backup of every database in pg-playground
0 23 * * * docker exec pg-playground pg_dumpall -U admin > ~/pg-backup/all-$(date +\%F).sql 2>> ~/newdb.log
```

Create the target folder first: `mkdir -p ~/pg-backup`.

---

## ▶️ Usage

### Run manually

```bash
bash ~/.local/bin/newdb.sh demo_todo
```

### With arguments

```bash
bash ~/.local/bin/newdb.sh demo_todo my_password
```

| Argument     | Description                            | Default          |
| ------------ | -------------------------------------- | ---------------- |
| `<name>`     | Database name and user name (required) | _(none)_         |
| `[password]` | Password for the new user              | Same as `<name>` |

Connection string printed by the script:

```
postgresql://demo_todo:demo_todo@localhost:5432/demo_todo
```

### Open psql

```bash
docker exec -it pg-playground psql -U admin
```

### Remove a demo database

```bash
docker exec -it pg-playground psql -U admin \
  -c 'DROP DATABASE demo_todo;' \
  -c 'DROP USER demo_todo;'
```

### Connect from an app running in Docker

Inside an app container, `localhost` points to the app container itself. Join the shared network and use the container name as the host:

```yaml
services:
  app:
    # ...
    environment:
      DATABASE_URL: postgresql://demo_todo:demo_todo@pg-playground:5432/demo_todo
    networks: [shared]

networks:
  shared:
    external: true
```

Alternative: use `host.docker.internal` as the host. It works out of the box on Docker Desktop; on Linux add this to the app service:

```yaml
extra_hosts:
  - "host.docker.internal:host-gateway"
```

---

## ⚙️ Customization

Variables you can change directly inside the script:

```bash
# Inside newdb.sh
CONTAINER=pg-playground   # Postgres container name
PG_ADMIN=admin            # Superuser defined in docker-compose.yml
PG_HOST=localhost         # Host shown in the printed connection string
PG_PORT=5432              # Port shown in the printed connection string
```

Optional isolation so a user can only connect to its own database:

```sql
REVOKE CONNECT ON DATABASE demo_todo FROM PUBLIC;
GRANT CONNECT ON DATABASE demo_todo TO demo_todo;
```

By default any user can connect to any database. For local tutorials/PoCs this can be skipped, but it is a good habit.

Need a common starting schema? Create one database as a template and clone it:

```sql
CREATE DATABASE new_project TEMPLATE template_name;
```

---

## 📊 Log

The script itself does not write a log. Use the container log instead:

```bash
# Follow the latest log in real time
docker logs -f pg-playground

# View the last 100 lines
docker logs --tail 100 pg-playground

# Check container status
docker ps --filter name=pg-playground
```

Sample normal output after startup:

```
LOG:  database system is ready to accept connections
```

Quick backup and restore of a single database:

```bash
# Backup
docker exec pg-playground pg_dump -U admin demo_todo > demo_todo.sql

# Restore
docker exec -i pg-playground psql -U admin -d demo_todo < demo_todo.sql
```

---

## 🐛 Troubleshooting

### Error: No such container: pg-playground

**Symptom:** The script fails with `Error response from daemon: No such container`  
**Cause:** The container is not running or has a different name  
**Fix:**

```bash
cd ~/.pg-playground && docker compose up -d
```

### Error: role or database already exists

**Symptom:** `ERROR: role "demo_todo" already exists` or `database "demo_todo" already exists`  
**Cause:** A demo with the same name was created before  
**Fix:**

```bash
docker exec -it pg-playground psql -U admin \
  -c 'DROP DATABASE IF EXISTS demo_todo;' \
  -c 'DROP USER IF EXISTS demo_todo;'
```

### App in Docker cannot connect

**Symptom:** `connection refused` when the app uses `localhost`  
**Cause:** `localhost` inside a container refers to the container itself  
**Fix:** Join the `shared` network and use `pg-playground` as the host (see Usage), or use `host.docker.internal`.

### Port 5432 already in use

**Symptom:** `bind: address already in use` on `docker compose up`  
**Cause:** A local Postgres service or another container is using port 5432  
**Fix:**

```bash
# Find what is using the port
sudo ss -ltnp | grep 5432

# Or change the host port in docker-compose.yml, e.g. "127.0.0.1:5433:5432"
```

### Postgres refuses to start after changing the image version

**Symptom:** `database files are incompatible with server`  
**Cause:** The data directory was created by a different major version  
**Fix:** Go back to the original major version, or dump the data and restore it into a fresh volume on the new version.

---

## 🔄 After Reinstalling the OS

```bash
# 1. Install dependencies
sudo apt install docker.io docker-compose-v2

# 2. Restore the compose file and script, then make the script executable
mkdir -p ~/.pg-playground ~/.local/bin
cp docker-compose.yml ~/.pg-playground/
cp newdb.sh ~/.local/bin/
chmod +x ~/.local/bin/newdb.sh

# 3. Start Postgres
cd ~/.pg-playground && docker compose up -d

# 4. Restore data from backup (if any)
docker exec -i pg-playground psql -U admin < ~/pg-backup/all-YYYY-MM-DD.sql

# 5. Re-register the cron job (if applicable)
crontab -e
```

The Docker volume is wiped with the OS, so keep your `.sql` backups somewhere outside the machine.

---

## 📝 Notes

- All databases share the same CPU, memory, `max_connections`, Postgres version, and extensions
- If a demo needs a different Postgres version or special config, run a separate instance for it (e.g. port `5433` with its own volume)
- For extensions such as pgvector or PostGIS, use an image that includes them from the start, e.g. `pgvector/pgvector:pg17`
- `docker compose down -v` deletes the volume and **all** databases; it cannot be undone
- Default passwords equal to the database name are fine for local demos only; never reuse this pattern on a shared or public host
- Optional GUIs: DBeaver or TablePlus from the host, or add pgAdmin/Adminer to the compose file
