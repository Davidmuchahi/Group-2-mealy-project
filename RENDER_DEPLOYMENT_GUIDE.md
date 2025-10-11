# Deploy Mealy to Render

Complete guide to deploy the Mealy food ordering platform to Render (free tier available).

## Prerequisites

- A [Render account](https://render.com) (sign up free)
- Your code in a Git repository (GitHub/GitLab/Bitbucket)

## Quick Deploy (5 Minutes)

### Step 1: Sign In to Render
1. Go to https://render.com
2. Sign in with GitHub (recommended)

### Step 2: Deploy Using Blueprint
1. Click **"New +"** → **"Blueprint"**
2. Connect your repository: `Group-2-mealy-project`
3. Render detects `render.yaml` automatically
4. Click **"Apply"** to start deployment

### Step 3: Wait for Deployment (5-10 minutes)
Render will automatically create:
- PostgreSQL database (`mealy-postgres`)
- Flask backend API (`mealy-backend`)
- React frontend (`mealy-frontend`)

### Step 4: Update Frontend API URL
Once backend is deployed:

1. Go to **mealy-backend** service
2. Copy the URL (e.g., `https://mealy-backend-abc123.onrender.com`)
3. Go to **mealy-frontend** service
4. Click **"Environment"** tab
5. Update `REACT_APP_API_URL` with your backend URL
6. Save (triggers automatic redeploy)

### Step 5: Access Your App
- Frontend: `https://mealy-frontend.onrender.com`
- Backend: `https://mealy-backend.onrender.com`
- Test at: `https://mealy-backend.onrender.com/health` (should return `{"ok": true}`)

## Manual Deployment (Alternative)

If you prefer to deploy services individually:

### A. Deploy PostgreSQL Database

1. Dashboard → **"New"** → **"PostgreSQL"**
2. Configure:
   - Name: `mealy-postgres`
   - Database: `mealy`
   - User: `mealy`
   - Plan: **Free**
3. Click **"Create Database"**
4. Copy the **Internal Database URL**

### B. Deploy Backend (Flask API)

1. Dashboard → **"New"** → **"Web Service"**
2. Connect your repository
3. Configure:
   - **Name**: `mealy-backend`
   - **Runtime**: Python 3
   - **Build Command**:
     ```bash
     cd server && pip install --upgrade pip && pip install -r requirements.txt && flask db upgrade
     ```
   - **Start Command**:
     ```bash
     cd server && gunicorn --bind 0.0.0.0:$PORT --workers 2 --timeout 120 app:app
     ```
   - **Plan**: Free

4. Add Environment Variables:
   ```
   FLASK_APP=app.py
   FLASK_ENV=production
   DATABASE_URL=(paste Internal Database URL from step A)
   JWT_SECRET_KEY=(generate random secure string)
   SECRET_KEY=(generate random secure string)
   PORT=5000
   ```

5. Click **"Create Web Service"**

### C. Deploy Frontend (React)

1. Dashboard → **"New"** → **"Static Site"**
2. Connect your repository
3. Configure:
   - **Name**: `mealy-frontend`
   - **Build Command**:
     ```bash
     cd client && npm install && npm run build
     ```
   - **Publish Directory**: `client/build`
   - **Plan**: Free

4. Add Environment Variables:
   ```
   REACT_APP_API_URL=(your backend URL from step B)
   DISABLE_ESLINT_PLUGIN=true
   ```

5. Click **"Create Static Site"**

## Environment Variables Reference

### Backend Required Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `FLASK_APP` | `app.py` | Flask entry point |
| `FLASK_ENV` | `production` | Environment mode |
| `DATABASE_URL` | Auto-connected | PostgreSQL connection |
| `JWT_SECRET_KEY` | Auto-generated | JWT token secret |
| `SECRET_KEY` | Auto-generated | Flask secret key |
| `PORT` | `5000` | Server port |

### Backend Optional Variables (OAuth)

| Variable | Description |
|----------|-------------|
| `GOOGLE_CLIENT_ID` | Google OAuth client ID |
| `APPLE_CLIENT_ID` | Apple Sign In client ID |

### Frontend Required Variables

| Variable | Example | Description |
|----------|---------|-------------|
| `REACT_APP_API_URL` | `https://mealy-backend.onrender.com` | Backend API URL |
| `DISABLE_ESLINT_PLUGIN` | `true` | Disable build warnings |

## Database Migrations

When you update database schema:

1. Go to backend service in Render Dashboard
2. Open the **"Shell"** tab
3. Run:
   ```bash
   cd server
   flask db migrate -m "description of changes"
   flask db upgrade
   ```

## Free Tier Limitations

- **Database**: 1GB storage
- **Services spin down** after 15 minutes of inactivity
- **First request** after spin-down takes 30-60 seconds
- **750 hours/month** free usage per service

### Keep Services Active (Free)

Use a free uptime monitor to ping your backend every 10-15 minutes:
- [UptimeRobot](https://uptimerobot.com)
- [Cronitor](https://cronitor.io)
- [Better Uptime](https://betteruptime.com)

### Upgrade to Always-On ($7/month)

1. Go to **mealy-backend** service
2. Click **"Settings"** → **"Upgrade Plan"**
3. Select **"Starter"** plan

## Troubleshooting

### Build Failures

**Backend build fails:**
- Check that `requirements.txt` exists in `server/` directory
- Verify Python version compatibility (3.8+)
- Review build logs in Render dashboard

**Frontend build fails:**
- Ensure `package.json` exists in `client/` directory
- Check Node version (should be 18.x)
- Review build logs for missing dependencies

### "Failed to fetch" Error

- **Cause**: Backend is spinning up or wrong API URL
- **Solution**:
  - Wait 30-60 seconds for backend to wake up
  - Verify `REACT_APP_API_URL` is correct in frontend settings

### Database Connection Error

- Wait 2-3 minutes for database to fully initialize
- Verify `DATABASE_URL` environment variable is set
- Check database status in Render dashboard

### 404 on Frontend Route Refresh

- The `_redirects` file in `client/public/` handles this
- Verify it contains: `/*    /index.html   200`

### CORS Errors

Backend is configured with `CORS(app, resources={r"/*": {"origins": "*"}})`.

For production, restrict to your frontend domain in `server/app.py:37`:
```python
CORS(app, resources={r"/*": {"origins": ["https://mealy-frontend.onrender.com"]}})
```

## Monitoring and Logs

1. **View Logs**: Service → "Logs" tab
2. **Metrics**: Monitor CPU, memory, request counts
3. **Health Check**: Backend automatically monitors `/health` endpoint

## Automatic Redeployment

Render automatically redeploys when you push to your connected Git branch.

To disable:
- Service Settings → "Build & Deploy" → Disable "Auto-Deploy"

## Database Backups

- **Automatic**: Daily backups (retained 7 days on free tier)
- **Manual**: Go to PostgreSQL service → "Backups" tab

## Security Recommendations

1. **Strong Secrets**: Use auto-generated values for JWT_SECRET_KEY and SECRET_KEY
2. **Restrict CORS**: Limit origins to your frontend domain only
3. **HTTPS**: Automatically enabled by Render
4. **Database Access**: Use internal database URL (not external)
5. **No Secrets in Git**: Never commit environment variables to repository

## Cost Breakdown

**Free Tier (Current Setup):**
- PostgreSQL: $0/month (1GB)
- Backend: $0/month (with spin-down)
- Frontend: $0/month (100GB bandwidth)
- **Total: $0/month**

**With Backend Always Active:**
- Backend Starter Plan: $7/month
- **Total: $7/month**

**Professional Setup:**
- Backend: $25/month (priority support, 2GB RAM)
- Database: $7/month (10GB storage)
- **Total: $32/month**

## Post-Deployment Testing

1. Visit backend: `https://your-backend.onrender.com/health`
2. Register a new user via frontend
3. Login with credentials
4. Browse menu and place an order
5. Check order history

## Support Resources

- [Render Documentation](https://render.com/docs)
- [Render Community Forum](https://community.render.com)
- [Flask Deployment Best Practices](https://flask.palletsprojects.com/en/latest/deploying/)
- [React Deployment Guide](https://create-react-app.dev/docs/deployment/)

## Architecture Overview

```
┌─────────────────────────────────────────┐
│         Render Platform (Cloud)          │
├─────────────────────────────────────────┤
│                                          │
│  ┌────────────────┐   ┌──────────────┐ │
│  │ mealy-frontend │──▶│ mealy-backend│ │
│  │  (React SPA)   │   │  (Flask API) │ │
│  │  Static Site   │   │  Web Service │ │
│  └────────────────┘   └──────┬───────┘ │
│                               │          │
│                      ┌────────▼───────┐ │
│                      │ mealy-postgres │ │
│                      │   (Database)   │ │
│                      └────────────────┘ │
└─────────────────────────────────────────┘
```

## Configuration Files

- `render.yaml` - Render Blueprint configuration (database, backend, frontend)
- `client/.env.production` - Production environment variables template
- `server/requirements.txt` - Python dependencies
- `client/package.json` - Node.js dependencies

## Ready to Deploy

Follow the **Quick Deploy** steps above to get your Mealy app live in 5 minutes!

---

**Questions?** Check the troubleshooting section or visit [Render's documentation](https://render.com/docs).
