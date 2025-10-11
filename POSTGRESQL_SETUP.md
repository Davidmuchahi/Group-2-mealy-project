# PostgreSQL Setup Guide for Mealy

This guide will help you set up PostgreSQL as the database backend for the Mealy application.

## Why PostgreSQL?

- **Production-ready**: Industry-standard database for web applications
- **Better performance**: Handles concurrent connections efficiently
- **ACID compliance**: Ensures data integrity
- **Scalable**: Grows with your application
- **Feature-rich**: Advanced querying and indexing capabilities

## Quick Start

### 1. Install PostgreSQL

#### macOS (using Homebrew)
```bash
brew install postgresql@14
brew services start postgresql@14
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### Windows
1. Download from [postgresql.org/download/windows](https://www.postgresql.org/download/windows/)
2. Run the installer
3. Remember your postgres user password
4. Default port: 5432

### 2. Create the Database

```bash
# Access PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE mealy_db;

# Exit
\q
```

**Alternative one-liner:**
```bash
createdb -U postgres mealy_db
```

### 3. Configure Your Application

Update your `server/.env` file:

```env
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/mealy_db
JWT_SECRET_KEY=super-secret-key
SECRET_KEY=another-secret
FLASK_ENV=development
FLASK_DEBUG=True
FLASK_PORT=5001
```

**Connection String Format:**
```
postgresql://username:password@host:port/database_name
```

### 4. Install Dependencies

The PostgreSQL driver is already in your requirements.txt:

```bash
cd server
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 5. Run Migrations

```bash
cd server
source venv/bin/activate  # Windows: venv\Scripts\activate

# Initialize migrations (if not already done)
flask db init

# Create migration
flask db migrate -m "Initial migration"

# Apply migration
flask db upgrade
```

### 6. Seed the Database

```bash
python seed_menu.py  # Windows: python seed_menu.py
```

### 7. Start the Server

```bash
python app.py
```

Your server should now be running with PostgreSQL on `http://localhost:5001`

## Common PostgreSQL Commands

```bash
# Connect to PostgreSQL
psql -U postgres

# List all databases
\l

# Connect to mealy_db
\c mealy_db

# List all tables
\dt

# Describe a table
\d users

# Show table contents
SELECT * FROM users;

# Exit
\q
```

## Troubleshooting

### Connection Refused

**Error:** `psycopg2.OperationalError: could not connect to server`

**Solution:**
```bash
# Check if PostgreSQL is running
# macOS
brew services list

# Linux
sudo systemctl status postgresql

# Start PostgreSQL if not running
# macOS
brew services start postgresql

# Linux
sudo systemctl start postgresql
```

### Authentication Failed

**Error:** `FATAL: password authentication failed for user "postgres"`

**Solution:**
1. Reset your PostgreSQL password:
```bash
# macOS/Linux
sudo -u postgres psql
ALTER USER postgres PASSWORD 'new_password';
\q
```

2. Update your `.env` file with the new password

### Database Does Not Exist

**Error:** `FATAL: database "mealy_db" does not exist`

**Solution:**
```bash
createdb -U postgres mealy_db
```

### Port Already in Use

**Error:** Port 5432 is already in use

**Solution:**
```bash
# Find process using port 5432
# macOS/Linux
lsof -i :5432

# Kill the process if needed
kill -9 <PID>

# Or change PostgreSQL port in postgresql.conf
```

## PostgreSQL vs SQLite

| Feature | PostgreSQL | SQLite |
|---------|-----------|---------|
| Setup | Requires installation | No installation |
| Performance | Excellent for concurrent users | Good for single user |
| Production Ready | ✅ Yes | ❌ Not recommended |
| Data Types | Rich type system | Limited types |
| Concurrent Writes | ✅ Handles well | ❌ Locks database |
| Max DB Size | Unlimited | ~281 TB (theoretical) |
| Use Case | Production apps | Development/testing |

## Production Deployment

When deploying to platforms like Heroku, Render, or Railway:

1. **They provide DATABASE_URL automatically**
2. **No changes needed** - the app already handles this in `app.py:25-28`
3. **The connection string will look like:**
   ```
   postgresql://user:pass@host.compute.amazonaws.com:5432/dbname
   ```

The app automatically converts old-style `postgres://` URLs to `postgresql://` for compatibility.

## Database Backups

### Create a Backup
```bash
pg_dump -U postgres mealy_db > backup.sql
```

### Restore from Backup
```bash
psql -U postgres mealy_db < backup.sql
```

### Backup with Compression
```bash
pg_dump -U postgres -Fc mealy_db > backup.dump
```

### Restore Compressed Backup
```bash
pg_restore -U postgres -d mealy_db backup.dump
```

## Performance Tips

1. **Create indexes** on frequently queried columns:
```sql
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_id ON orders(user_id);
```

2. **Use connection pooling** in production (already configured in SQLAlchemy)

3. **Monitor query performance:**
```sql
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 1;
```

4. **Regular maintenance:**
```sql
VACUUM ANALYZE;
```

## Switching from SQLite to PostgreSQL

If you're migrating from SQLite:

1. **Backup your SQLite data** (export to JSON/CSV if needed)
2. **Set up PostgreSQL** (steps above)
3. **Update DATABASE_URL** in `.env`
4. **Run migrations**: `flask db upgrade`
5. **Re-seed the database**: `python seed_menu.py`

Your Flask app will automatically handle the database switch!

## Additional Resources

- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [SQLAlchemy PostgreSQL Dialects](https://docs.sqlalchemy.org/en/14/dialects/postgresql.html)
- [Flask-Migrate Documentation](https://flask-migrate.readthedocs.io/)
- [Alembic Tutorial](https://alembic.sqlalchemy.org/en/latest/tutorial.html)

## Support

If you encounter issues:
1. Check PostgreSQL is running: `pg_isready`
2. Verify connection: `psql -U postgres -d mealy_db`
3. Check logs: `tail -f /usr/local/var/log/postgresql@14.log` (macOS)
4. Ensure `.env` has correct DATABASE_URL
5. Try recreating the database: Drop and create new

For more help, see `SETUP.md` or open an issue on GitHub.
