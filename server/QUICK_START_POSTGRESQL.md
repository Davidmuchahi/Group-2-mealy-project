# PostgreSQL Quick Start Guide

## 1. Install PostgreSQL

```bash
# macOS
brew install postgresql
brew services start postgresql

# Linux (Ubuntu/Debian)
sudo apt update && sudo apt install postgresql
sudo systemctl start postgresql

# Windows
# Download from: https://www.postgresql.org/download/windows/
```

## 2. Create Database

```bash
createdb -U postgres mealy_db
```

Or using psql:
```bash
psql -U postgres
CREATE DATABASE mealy_db;
\q
```

## 3. Configure Environment

Your `.env` is already set up with:
```env
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mealy_db
```

**Update only if your PostgreSQL password is different!**

## 4. Install Dependencies

```bash
cd server
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## 5. Run Migrations

```bash
flask db upgrade
```

## 6. Seed Database

```bash
python seed_menu.py
```

## 7. Start Server

```bash
python app.py
```

Visit: http://localhost:5001

---

## Or Use Automated Setup

**Linux/macOS:**
```bash
cd server
./setup_postgresql.sh
```

**Windows:**
```cmd
cd server
setup_postgresql.bat
```

---

## Useful PostgreSQL Commands

```bash
# Check if PostgreSQL is running
pg_isready

# Connect to database
psql -U postgres -d mealy_db

# Inside psql:
\l              # List databases
\c mealy_db     # Connect to database
\dt             # List tables
\d users        # Describe users table
\q              # Quit
```

## Troubleshooting

**Connection refused?**
```bash
brew services start postgresql  # macOS
sudo systemctl start postgresql  # Linux
```

**Database doesn't exist?**
```bash
createdb -U postgres mealy_db
```

**Authentication failed?**
- Check password in `.env` matches your PostgreSQL password
- Default username: `postgres`
- Default password: `postgres`

---

## Need More Help?

- Detailed guide: `POSTGRESQL_SETUP.md`
- Full setup: `SETUP.md`
- Migration info: `POSTGRESQL_MIGRATION_SUMMARY.md`
