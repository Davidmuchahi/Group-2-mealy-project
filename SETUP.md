# Mealy 

This guide will help you set up and run the Mealy application on **Windows**, **Linux**, and **macOS**.

## Prerequisites

### All Platforms
- **Node.js** (v14 or higher) - [Download](https://nodejs.org/)
- **Python** (v3.8 or higher) - [Download](https://www.python.org/)
- **Git** - [Download](https://git-scm.com/)

---

## Initial Setup

### 1. Clone the Repository
```bash
git clone <https://github.com/steveofficial254/Group-2-mealy-project>
cd Group-2-mealy-project
```

---

## Backend Setup (Flask)

### Windows

1. **Navigate to server directory:**
   ```cmd
   cd server
   ```

2. **Create virtual environment:**
   ```cmd
   python -m venv venv
   ```

3. **Activate virtual environment:**
   ```cmd
   venv\Scripts\activate
   ```

4. **Install dependencies:**
   ```cmd
   pip install -r requirements.txt
   ```

5. **Set up environment variables:**
   - Copy `.env` file or create one with:
   ```
   # PostgreSQL Database (recommended for production)
   DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mealy_db

   # OR use SQLite for development (simpler setup)
   # DATABASE_URL=sqlite:///mealy.db

   JWT_SECRET_KEY=super-secret-key
   SECRET_KEY=another-secret
   FLASK_ENV=development
   FLASK_DEBUG=True
   FLASK_PORT=5001
   ```

6. **Run the server:**
   ```cmd
   python app.py
   ```

### Linux / macOS

1. **Navigate to server directory:**
   ```bash
   cd server
   ```

2. **Create virtual environment:**
   ```bash
   python3 -m venv venv
   ```

3. **Activate virtual environment:**
   ```bash
   source venv/bin/activate
   ```

4. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

5. **Set up environment variables:**
   - Copy `.env` file or create one with:
   ```
   # PostgreSQL Database (recommended for production)
   DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mealy_db

   # OR use SQLite for development (simpler setup)
   # DATABASE_URL=sqlite:///mealy.db

   JWT_SECRET_KEY=super-secret-key
   SECRET_KEY=another-secret
   FLASK_ENV=development
   FLASK_DEBUG=True
   FLASK_PORT=5001
   ```

6. **Run the server:**
   ```bash
   python app.py
   ```

---

## Frontend Setup (React)

### All Platforms (Windows, Linux, macOS)

1. **Navigate to client directory:**
   ```bash
   cd client
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Set up environment variables:**
   - Ensure `.env` file exists with:
   ```
   REACT_APP_API_URL=http://localhost:5001
   REACT_APP_GOOGLE_CLIENT_ID=YOUR_ACTUAL_GOOGLE_CLIENT_ID.apps.googleusercontent.com
   REACT_APP_APPLE_CLIENT_ID=your-apple-client-id
   ```

4. **Run the development server:**
   ```bash
   npm start
   ```

The application will open at `http://localhost:3000`

---

## Running Both Servers

### Option 1: Separate Terminals

**Terminal 1 - Backend:**
- Windows: `cd server && venv\Scripts\activate && python app.py`
- Linux/Mac: `cd server && source venv/bin/activate && python app.py`

**Terminal 2 - Frontend:**
```bash
cd client && npm start
```

### Option 2: Using npm Scripts (Recommended)

You can create a `package.json` in the root directory with scripts to run both:

```json
{
  "scripts": {
    "start:server": "cd server && python app.py",
    "start:client": "cd client && npm start",
    "start": "concurrently \"npm run start:server\" \"npm run start:client\""
  }
}
```

Then run:
```bash
npm install concurrently --save-dev
npm start
```

---

## Port Configuration

**Important:** The backend runs on port **5001** (not 5000).

- Backend: `http://localhost:5001`
- Frontend: `http://localhost:3000`

Make sure these ports are not in use by other applications.

---

## Database Setup

### Option 1: PostgreSQL (Recommended for Production)

PostgreSQL is a robust, production-ready database that provides better performance and scalability.

#### Installing PostgreSQL

**Windows:**
1. Download PostgreSQL from [postgresql.org](https://www.postgresql.org/download/windows/)
2. Run the installer and remember your password
3. Default port is 5432

**macOS:**
```bash
# Using Homebrew
brew install postgresql
brew services start postgresql

# Create default postgres user (if needed)
createdb mealy_db
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### Setting Up PostgreSQL Database

1. **Access PostgreSQL:**
   ```bash
   # macOS/Linux
   psql -U postgres

   # Windows (via Command Prompt as Administrator)
   psql -U postgres
   ```

2. **Create the database:**
   ```sql
   CREATE DATABASE mealy_db;
   \q
   ```

3. **Configure your `.env` file:**
   ```
   DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mealy_db
   ```

   Format: `postgresql://username:password@host:port/database_name`

4. **Run migrations:**
   ```bash
   cd server
   source venv/bin/activate  # Windows: venv\Scripts\activate
   flask db upgrade
   ```

### Option 2: SQLite (Quick Setup for Development)

SQLite is simpler and requires no installation, but not recommended for production.

The SQLite database will be created automatically on first run at:
- `server/mealy.db`

Configure your `.env` file:
```
DATABASE_URL=sqlite:///mealy.db
```

To reset the database, simply delete `mealy.db` and restart the server.

### Seeding the Database with Sample Data (IMPORTANT!)

**After first setup, you MUST run the seed script to populate the database with:**
- Admin user (email: admin@mealy.com, password: admin123)
- Caterer
- Today's daily menu
- All menu items across all categories (Pizzas, Garlic Bread, Calzone, Kebabas, Salads, etc.)

**To seed the database:**

#### Windows
```cmd
cd server
venv\Scripts\activate
python seed_menu.py
```

#### Linux / macOS
```bash
cd server
source venv/bin/activate
python3 seed_menu.py
```

**Expected output:**
```
✓ Created admin user: admin@mealy.com
✓ Created caterer: Mealy Kitchen (ID: 1)
✓ Created daily menu for 2025-10-03 (ID: 1)

Adding 44 dishes to menu...
✓ Successfully added 44 dishes

============================================================
DATABASE SEEDING COMPLETE
============================================================
Caterer ID: 1
Daily Menu ID: 1
Menu Date: 2025-10-03
Total Dishes: 44
============================================================

You can now use this menu in your application!
```

**Important Notes:**
- Run this script every day to create today's menu with all dishes
- If you see "already exists" messages, the script will skip creating duplicates
- You can run this script multiple times safely - it won't create duplicates
- All menu categories will be populated: Daily Menu, Pizzas, Garlic Bread, Calzone, Kebabas, Salads, Cold drinks, Happy Mealy, Desserts, Coffee, Sauces, and KUKU

### Alternative: Manual Daily Menu Creation (Advanced)

If you only need to create a daily menu without dishes:

```bash
cd server
python3 -c "
from app import create_app
from models import db, DailyMenu
from datetime import datetime, date

app = create_app()
with app.app_context():
    today = date.today()
    cutoff_time = datetime.combine(today, datetime.strptime('16:00:00', '%H:%M:%S').time())

    menu = DailyMenu(
        caterer_id=1,
        menu_date=today,
        cutoff_at=cutoff_time
    )

    db.session.add(menu)
    db.session.commit()

    print(f'✓ Created daily menu for {today}')
"
```

This creates a menu with a 4:00 PM cutoff time. Repeat this daily or create a cron job to automate it.

---

## Common Issues

### Issue 1: "Menu not available, please refresh the page" error during checkout
**Symptoms:** Customer sees error "Menu not available. Please refresh the page and try again." when trying to checkout.

**Root Cause:** No daily menu exists for today in the database.

**Solution:**
1. Run the seed script to create today's menu:
   ```bash
   cd server
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   python3 seed_menu.py       # On Windows: python seed_menu.py
   ```
2. Refresh the customer page
3. The menu should now load successfully

### Issue 2: "No menu available for today" error in admin dashboard
**Solution:** Same as Issue 1 - run the seed script to create today's menu.

### Issue 3: "Failed to fetch" or port mismatch errors
**Solution:**
- Ensure backend is running on port 5001 and client `.env` has `REACT_APP_API_URL=http://localhost:5001`
- All API calls now use the `API_BASE` constant from environment variables
- Check both `client/.env` and `server/.env` have correct port configuration

### Issue 4: Python command not found
**Solution:**
- Windows: Use `python` or add Python to PATH
- Linux/Mac: Use `python3` or create an alias

### Issue 5: Port already in use
**Solution:**
- Windows: `netstat -ano | findstr :5001` then `taskkill /PID <PID> /F`
- Linux/Mac: `lsof -ti:5001 | xargs kill -9`

### Issue 6: Virtual environment activation issues
**Solution:**
- Windows: May need to run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` in PowerShell
- Linux/Mac: Ensure `venv/bin/activate` has execute permissions: `chmod +x venv/bin/activate`

### Issue 7: PostgreSQL connection errors
**Symptoms:**
- "could not connect to server"
- "FATAL: password authentication failed"
- "psycopg2.OperationalError"

**Solutions:**
1. **PostgreSQL not running:**
   ```bash
   # macOS
   brew services start postgresql

   # Linux
   sudo systemctl start postgresql

   # Windows - Start PostgreSQL service from Services app
   ```

2. **Wrong credentials:**
   - Check your DATABASE_URL in `.env`
   - Default PostgreSQL username is `postgres`
   - If you forgot the password, you may need to reset it

3. **Database doesn't exist:**
   ```bash
   psql -U postgres -c "CREATE DATABASE mealy_db;"
   ```

4. **Port conflict:**
   - Ensure PostgreSQL is running on port 5432
   - Check with: `psql -U postgres -p 5432`

### Issue 8: Migration errors
**Symptoms:** "Target database is not up to date" or migration fails

**Solution:**
```bash
cd server
source venv/bin/activate  # Windows: venv\Scripts\activate
flask db stamp head  # Mark current state
flask db migrate -m "sync database"
flask db upgrade
```

---

## Building for Production

### Backend
```bash
cd server
pip install gunicorn
gunicorn app:app --bind 0.0.0.0:5001
```

### Frontend
```bash
cd client
npm run build
```

The production build will be in `client/build/` directory.

---

## Environment Variables Summary

### Backend (.env in server/)
```
# Database - Choose one:
# PostgreSQL (recommended for production):
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/mealy_db
# SQLite (simpler for development):
# DATABASE_URL=sqlite:///mealy.db

JWT_SECRET_KEY=super-secret-key
SECRET_KEY=another-secret
FLASK_ENV=development
FLASK_DEBUG=True
FLASK_PORT=5001

# OAuth (optional)
GOOGLE_CLIENT_ID=<your-google-client-id>
GOOGLE_CLIENT_SECRET=<your-google-secret>
```

### Frontend (.env in client/)
```
REACT_APP_API_URL=http://localhost:5001
REACT_APP_GOOGLE_CLIENT_ID=<your-google-client-id>
REACT_APP_APPLE_CLIENT_ID=<your-apple-client-id>
```

---

#

## Support

If you encounter any issues:
1. Check that all prerequisites are installed
2. Verify environment variables are set correctly
3. Ensure ports 3000 and 5001 are available
4. Check that virtual environment is activated for backend


