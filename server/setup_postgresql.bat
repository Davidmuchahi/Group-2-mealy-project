@echo off
REM PostgreSQL Setup Script for Mealy (Windows)
REM This script helps automate the PostgreSQL setup process on Windows

echo ==========================================
echo Mealy PostgreSQL Setup Script (Windows)
echo ==========================================
echo.

REM Check if PostgreSQL is installed
echo Checking PostgreSQL installation...
where psql >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] PostgreSQL is not installed or not in PATH
    echo.
    echo Please install PostgreSQL first:
    echo   Download from: https://www.postgresql.org/download/windows/
    echo   Make sure to add PostgreSQL to your PATH during installation
    pause
    exit /b 1
)

echo [OK] PostgreSQL is installed
psql --version
echo.

REM Get database configuration
echo Database Configuration
echo ======================
set /p DB_USER="Enter PostgreSQL username [postgres]: "
if "%DB_USER%"=="" set DB_USER=postgres

set /p DB_PASS="Enter PostgreSQL password [postgres]: "
if "%DB_PASS%"=="" set DB_PASS=postgres

set /p DB_NAME="Enter database name [mealy_db]: "
if "%DB_NAME%"=="" set DB_NAME=mealy_db

set /p DB_HOST="Enter host [localhost]: "
if "%DB_HOST%"=="" set DB_HOST=localhost

set /p DB_PORT="Enter port [5432]: "
if "%DB_PORT%"=="" set DB_PORT=5432

echo.

REM Create database
echo Creating database '%DB_NAME%'...
set PGPASSWORD=%DB_PASS%
psql -U %DB_USER% -h %DB_HOST% -p %DB_PORT% -lqt | findstr /C:"%DB_NAME%" >nul 2>nul
if %errorlevel% equ 0 (
    echo [WARNING] Database '%DB_NAME%' already exists
) else (
    createdb -U %DB_USER% -h %DB_HOST% -p %DB_PORT% %DB_NAME%
    if %errorlevel% equ 0 (
        echo [OK] Database '%DB_NAME%' created successfully
    ) else (
        echo [ERROR] Failed to create database
        pause
        exit /b 1
    )
)
echo.

REM Update .env file
echo Updating .env file...
set DATABASE_URL=postgresql://%DB_USER%:%DB_PASS%@%DB_HOST%:%DB_PORT%/%DB_NAME%

if exist .env (
    REM Backup existing .env
    copy .env .env.backup >nul
    echo [OK] Backed up existing .env to .env.backup

    REM Create new .env with updated DATABASE_URL
    powershell -Command "(gc .env) -replace '^DATABASE_URL=.*', 'DATABASE_URL=%DATABASE_URL%' | Out-File -encoding ASCII .env.tmp"
    move /y .env.tmp .env >nul
    echo [OK] Updated DATABASE_URL in .env
) else (
    echo [WARNING] .env file not found, creating new one
    (
        echo DATABASE_URL=%DATABASE_URL%
        echo JWT_SECRET_KEY=super-secret-key
        echo SECRET_KEY=another-secret
        echo FLASK_ENV=development
        echo FLASK_DEBUG=True
        echo FLASK_PORT=5001
        echo.
        echo # Google OAuth Configuration
        echo GOOGLE_CLIENT_ID=YOUR_ACTUAL_GOOGLE_CLIENT_ID.apps.googleusercontent.com
        echo GOOGLE_CLIENT_SECRET=your-google-client-secret
        echo.
        echo # Apple Sign In Configuration
        echo APPLE_CLIENT_ID=your-apple-client-id
        echo APPLE_TEAM_ID=your-apple-team-id
        echo APPLE_KEY_ID=your-apple-key-id
        echo APPLE_PRIVATE_KEY_PATH=path/to/apple/private/key.p8
    ) > .env
    echo [OK] Created new .env file
)
echo.

REM Check virtual environment
echo Checking Python virtual environment...
if exist venv\ (
    echo [OK] Virtual environment found
) else (
    echo [WARNING] Virtual environment not found
    set /p CREATE_VENV="Create virtual environment? (y/n): "
    if /i "%CREATE_VENV%"=="y" (
        python -m venv venv
        echo [OK] Created virtual environment
    )
)
echo.

REM Install dependencies
echo Installing dependencies...
if exist venv\ (
    call venv\Scripts\activate
    pip install -r requirements.txt
    echo [OK] Dependencies installed
) else (
    echo [WARNING] Skipping dependency installation (no virtual environment)
)
echo.

REM Run migrations
echo Running database migrations...
if exist venv\ (
    call venv\Scripts\activate

    if exist migrations\ (
        flask db upgrade
        echo [OK] Migrations applied successfully
    ) else (
        echo [WARNING] No migrations directory found
        set /p INIT_MIGRATIONS="Initialize migrations? (y/n): "
        if /i "%INIT_MIGRATIONS%"=="y" (
            flask db init
            flask db migrate -m "Initial migration"
            flask db upgrade
            echo [OK] Migrations initialized and applied
        )
    )
) else (
    echo [WARNING] Skipping migrations (no virtual environment)
)
echo.

REM Test connection
echo Testing database connection...
if exist venv\ (
    call venv\Scripts\activate
    python -c "import os; from sqlalchemy import create_engine; from dotenv import load_dotenv; load_dotenv(); engine = create_engine(os.getenv('DATABASE_URL')); connection = engine.connect(); connection.close(); print('[OK] Database connection successful')"
    if %errorlevel% equ 0 (
        echo [OK] Database connection test passed
    ) else (
        echo [ERROR] Database connection test failed
        pause
        exit /b 1
    )
)
echo.

echo ==========================================
echo [OK] PostgreSQL setup complete!
echo ==========================================
echo.
echo Next steps:
echo 1. Activate virtual environment:
echo    venv\Scripts\activate
echo.
echo 2. Seed the database with sample data:
echo    python seed_menu.py
echo.
echo 3. Start the server:
echo    python app.py
echo.
echo Database connection string:
echo %DATABASE_URL%
echo.

pause
