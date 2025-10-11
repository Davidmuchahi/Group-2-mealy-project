# Mealy — Online Food Ordering Platform

## Description

Mealy is a full-stack food ordering platform designed to connect customers with caterers. Admins (caterers) can manage daily menus and dishes, while customers can browse menus, place orders, and view order history. The system ensures smooth order tracking, user authentication, and role-based access using JWT.

**Live Deployment:** [https://group-2-mealy-project.onrender.com](https://group-2-mealy-project.onrender.com)

> **Note:** If you encounter a "Failed to fetch" error on the deployment link, please follow the local setup instructions below to run the server locally or run the link and start the server locally on your machine.

## Tools & Technologies Used

### Backend
- Python 3.13
- Flask (REST API framework)
- SQLAlchemy & Flask-Migrate (ORM and migrations)
- Flask-JWT-Extended (authentication)
- PostgreSQL (database)
- Pytest (testing)
- Thunder Client / Postman (API testing)

### Frontend
- React

### Version Control
- Git & GitHub (collaborative workflow)

## Setup Instructions

For detailed setup instructions for **Windows, Linux, and macOS**, please see:
- **[SETUP.md](SETUP.md)** - Complete setup guide (highly recommended)
- **[POSTGRESQL_SETUP.md](POSTGRESQL_SETUP.md)** - PostgreSQL-specific guide

### Quick PostgreSQL Setup

We provide automated setup scripts for PostgreSQL:

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

These scripts will automatically:
- Check PostgreSQL installation
- Create the database
- Configure your `.env` file
- Run migrations
- Test the connection

### 1. Clone the Repository
```bash
git clone https://github.com/steveofficial254/Group-2-mealy-project.git
cd Group-2-mealy-project
```

### 2. Set Up the Virtual Environment
```bash
pipenv install
pipenv shell
```

### 3. Navigate to the Backend Folder
```bash
cd backend
```

### 4. Create a .env File
In the `backend/` directory, create a `.env` file and add:

```env
FLASK_APP=app.py
FLASK_ENV=development
DATABASE_URL=postgresql://mealy:mealy@localhost/mealy
JWT_SECRET_KEY=supersecret
SECRET_KEY=flasksecret
```

### 5. Database Setup

#### Start PostgreSQL
```bash
brew services start postgresql@15
```

#### Create Database (only once)
```bash
psql postgres
```

Run the following SQL commands:
```sql
CREATE ROLE mealy WITH LOGIN PASSWORD 'mealy';
ALTER ROLE mealy CREATEDB;
CREATE DATABASE mealy OWNER mealy;
\q
```

#### Run Database Migrations
```bash
flask db init
flask db migrate -m "initial schema"
flask db upgrade
```

## How to Run the Application

Start the Flask development server:
```bash
flask run --debug
```

The app will be live at: **http://127.0.0.1:5000**

## API Testing via Thunder Client / Postman

### 1. Register a User
**POST** `/auth/register`

```json
{
  "email": "admin@mealy.io",
  "password": "admin123",
  "full_name": "Admin",
  "role": "admin"
}
```

### 2. Login
**POST** `/auth/login`

```json
{
  "email": "admin@test.com",
  "password": "admin123"
}
```

### 3. Create Caterer (Admin Only)
**POST** `/caterers`

```json
{
  "name": "Mama's Kitchen"
}
```

**Headers:**
```
Authorization: Bearer <access_token>
```

### 4. Add Dishes
**POST** `/dishes`

```json
{
  "daily_menu_id": 1,
  "name": "Beef Rice",
  "price_cents": 1500,
  "category": "Lunch",
  "available_qty": 30,
  
}
```

## Authors

| Name | Role |
|------|------|
| Mohamed Ali | Backend Developer |
| Vallary Onyando| Backend Developer |
| David Muchahi | Frontend Developer |
| Steve Mburu | Frontend Developer |

## Acknowledgements

Special thanks to **Moringa School** and our mentors for their guidance and project supervision.

## License

This project is licensed under the MIT License.








