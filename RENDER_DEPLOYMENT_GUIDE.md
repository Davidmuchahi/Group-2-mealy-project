# Deploy Mealy to Render - Updated Guide

Complete guide to deploy the Mealy food ordering platform to Render.

## IMPORTANT: Render Free Tier Update

**As of 2024**, Render no longer offers a free plan for web services. Here's what's available:

- **Database (PostgreSQL)**: FREE (with limitations)
- **Static Sites (Frontend)**: FREE (unlimited)
- **Web Services (Backend)**: PAID ($7/month minimum)

### Your Free Options

**Option 1**: Deploy frontend only on Render (FREE) + backend on Railway/Fly.io (FREE)
**Option 2**: Pay $7/month for backend on Render
**Option 3**: Deploy everything on Railway or Fly.io (FREE)

This guide covers **Option 2** (Frontend FREE + Backend PAID on Render).

---

## Prerequisites

- A [Render account](https://render.com) (sign up free)
- Your code in a Git repository (GitHub/GitLab/Bitbucket)
- Credit card (required for paid backend service)

---

## Quick Deploy Instructions

### Step 1: Sign In to Render
1. Go to https://render.com
2. Sign in with GitHub (recommended)

### Step 2: Deploy PostgreSQL Database (FREE)

1. Click **"New +"** → **"PostgreSQL"**
2. Configure:
   - **Name**: `mealy-postgres`
   - **Database**: `mealy`
   - **User**: `mealy`
   - **Region**: Choose closest to you
   - **PostgreSQL Version**: 15
   - **Plan**: **Free**
3. Click **"Create Database"**
4. Wait 2-3 minutes for initialization
5. **Save the Internal Database URL** (you'll need this later)

### Step 3: Deploy Backend API (PAID - $7/month)

1. Click **"New +"** → **"Web Service"**
2. Connect your repository: `Group-2-mealy-project`
3. Configure:
   - **Name**: `mealy-backend`
   - **Region**: Same as database
   - **Branch**: `main`
   - **Root Directory**: Leave empty
   - **Runtime**: Python 3
   - **Build Command**:
     ```bash
     cd server && pip install --upgrade pip && pip install -r requirements.txt && flask db upgrade
     ```
   - **Start Command**:
     ```bash
     cd server && gunicorn --bind 0.0.0.0:$PORT --workers 2 --timeout 120 app:app
     ```
   - **Plan**: **Starter** ($7/month)

4. **Add Environment Variables**:
   Click "Advanced" → "Add Environment Variable"

   | Key | Value |
   |-----|-------|
   | `FLASK_APP` | `app.py` |
   | `FLASK_ENV` | `production` |
   | `DATABASE_URL` | Click "Add from Database" → Select `mealy-postgres` |
   | `JWT_SECRET_KEY` | Click "Generate" for random value |
   | `SECRET_KEY` | Click "Generate" for random value |
   | `PYTHON_VERSION` | `3.11.0` |
   | `PORT` | `5000` |

5. Click **"Create Web Service"**
6. Wait 5-10 minutes for build and deployment
7. **Copy your backend URL** (e.g., `https://mealy-backend.onrender.com`)

### Step 4: Deploy Frontend (FREE)

1. Click **"New +"** → **"Static Site"**
2. Connect your repository: `Group-2-mealy-project`
3. Configure:
   - **Name**: `mealy-frontend`
   - **Branch**: `main`
   - **Build Command**:
     ```bash
     cd client && npm install && npm run build
     ```
   - **Publish Directory**: `client/build`
   - **Auto-Deploy**: Yes

4. **Add Environment Variables**:

   | Key | Value |
   |-----|-------|
   | `NODE_VERSION` | `18.x` |
   | `REACT_APP_API_URL` | Your backend URL from Step 3 (e.g., `https://mealy-backend.onrender.com`) |

5. **Add Redirect Rule** (for React Router):
   - Scroll to "Redirects/Rewrites"
   - Add rule:
     - **Source**: `/*`
     - **Destination**: `/index.html`
     - **Action**: Rewrite

6. Click **"Create Static Site"**
7. Wait 3-5 minutes for build

### Step 5: Test Your Deployment

1. **Test Backend**:
   - Visit: `https://mealy-backend.onrender.com/health`
   - Should return: `{"ok": true}`

2. **Test Frontend**:
   - Visit: `https://mealy-frontend.onrender.com`
   - Should load the Mealy homepage

3. **Test Full Functionality**:
   - Register a new user
   - Login
   - Browse menu
   - Place an order

---

## Alternative: Deploy Using render.yaml Blueprint

**Note**: The current `render.yaml` has been updated to only include free services (frontend + database). You'll need to manually add the backend.

### Using Blueprint (Partial Deployment)

1. Push your code to GitHub:
   ```bash
   git add .
   git commit -m "Prepare for Render deployment"
   git push origin main
   ```

2. In Render Dashboard:
   - Click **"New +"** → **"Blueprint"**
   - Connect your repository
   - Select branch: `main`
   - Click **"Apply"**

This will create:
- PostgreSQL database (FREE)
- Frontend static site (FREE)

3. Then manually add the backend following **Step 3** above.

---

## Environment Variables Reference

### Backend Environment Variables

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `FLASK_APP` | Yes | Flask entry point | `app.py` |
| `FLASK_ENV` | Yes | Environment mode | `production` |
| `DATABASE_URL` | Yes | PostgreSQL connection | Auto-linked from database |
| `JWT_SECRET_KEY` | Yes | JWT token secret | Auto-generated |
| `SECRET_KEY` | Yes | Flask secret key | Auto-generated |
| `PORT` | Yes | Server port | `5000` |
| `PYTHON_VERSION` | Yes | Python version | `3.11.0` |
| `GOOGLE_CLIENT_ID` | No | Google OAuth (optional) | Your Google client ID |
| `APPLE_CLIENT_ID` | No | Apple OAuth (optional) | Your Apple client ID |

### Frontend Environment Variables

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `REACT_APP_API_URL` | Yes | Backend API URL | `https://mealy-backend.onrender.com` |
| `NODE_VERSION` | Yes | Node.js version | `18.x` |
| `DISABLE_ESLINT_PLUGIN` | No | Disable ESLint warnings | `true` |

---

## Database Migrations

When you update your database schema:

### Option 1: Via Render Shell
1. Go to your backend service in Render
2. Click **"Shell"** tab
3. Run:
   ```bash
   cd server
   flask db migrate -m "description of changes"
   flask db upgrade
   ```

### Option 2: Via Build Command
Add migrations to your build command:
```bash
cd server && pip install --upgrade pip && pip install -r requirements.txt && flask db upgrade
```

---

## Troubleshooting

### Build Failures

**Backend Build Fails**:
- Check `server/requirements.txt` exists and is complete
- Verify Python version (3.8+ required)
- Review build logs in Render dashboard
- Common issue: Missing dependencies

**Frontend Build Fails**:
- Check `client/package.json` exists
- Verify Node version (18.x recommended)
- Review build logs for errors
- Try: `npm install` locally first

### Runtime Errors

**"Failed to fetch" or "Network Error"**:
- Backend service is starting up (wait 30-60 seconds)
- Wrong `REACT_APP_API_URL` in frontend
- CORS issue (check backend logs)

**Database Connection Error**:
- Database not fully initialized (wait 2-3 minutes)
- Wrong `DATABASE_URL` environment variable
- Database service stopped (check Render dashboard)

**404 on Frontend Route Refresh**:
- Missing redirect rule in static site settings
- Add rewrite rule: `/*` → `/index.html`

**CORS Errors**:
Backend should have CORS enabled. Check `server/app.py`:
```python
from flask_cors import CORS
CORS(app, resources={r"/*": {"origins": "*"}})
```

For production, restrict to your frontend domain:
```python
CORS(app, resources={r"/*": {"origins": ["https://mealy-frontend.onrender.com"]}})
```

---

## Monitoring and Maintenance

### View Logs
1. Go to your service in Render dashboard
2. Click **"Logs"** tab
3. View real-time logs or search history

### Monitor Performance
- **Metrics** tab shows:
  - CPU usage
  - Memory usage
  - Request count
  - Response times

### Health Checks
- Backend automatically monitors `/health` endpoint
- If endpoint fails, service restarts automatically

---

## Automatic Deployments

Render automatically redeploys when you push to your connected Git branch:

```bash
git add .
git commit -m "Update feature"
git push origin main
```

**To disable auto-deploy**:
- Service Settings → "Build & Deploy" → Disable "Auto-Deploy"

---

## Database Backups

**Automatic Backups**:
- Free tier: Daily backups (7 days retention)
- Paid tier: More frequent backups (longer retention)

**Manual Backup**:
1. Go to PostgreSQL service
2. Click **"Backups"** tab
3. Click **"Create Backup"**

**Restore from Backup**:
1. Click on backup in list
2. Click **"Restore"**

---

## Cost Breakdown

### Current Setup (Frontend Free + Backend Paid)

| Service | Plan | Cost |
|---------|------|------|
| PostgreSQL Database | Free | $0/month |
| Backend Web Service | Starter | $7/month |
| Frontend Static Site | Free | $0/month |
| **Total** | | **$7/month** |

### Free Tier Limitations

**Database (Free)**:
- 1GB storage
- 97 max connections
- Expires after 90 days of inactivity

**Static Site (Free)**:
- 100GB bandwidth/month
- Unlimited builds

**Backend (Starter - $7/month)**:
- 512MB RAM
- Always on (no spin-down)
- Priority support

### Upgrade Options

**Backend Standard ($25/month)**:
- 2GB RAM
- Better performance
- Priority support

**Database Standard ($7/month)**:
- 10GB storage
- No expiration
- Better performance

---

## Security Best Practices

1. **Use Strong Secrets**:
   - Always use auto-generated values for JWT_SECRET_KEY and SECRET_KEY
   - Never commit secrets to Git

2. **Restrict CORS**:
   ```python
   CORS(app, resources={r"/*": {
       "origins": ["https://mealy-frontend.onrender.com"]
   }})
   ```

3. **HTTPS Only**:
   - Automatically enabled by Render
   - All traffic is encrypted

4. **Database Access**:
   - Use Internal Database URL (not External)
   - Internal URL only accessible within Render network

5. **Environment Variables**:
   - Never commit `.env` files to Git
   - Use Render's environment variable management

---

## Custom Domain (Optional)

To use your own domain:

1. Go to frontend service settings
2. Click **"Custom Domain"**
3. Add your domain (e.g., `mealy.com`)
4. Update DNS records as shown
5. Wait for SSL certificate (automatic)

**Note**: Custom domains require verification. Backend custom domains require paid plan.

---

## Post-Deployment Checklist

- [ ] Backend `/health` endpoint returns `{"ok": true}`
- [ ] Frontend loads correctly
- [ ] User registration works
- [ ] User login works
- [ ] Menu items display
- [ ] Order placement works
- [ ] Database migrations applied
- [ ] Environment variables set correctly
- [ ] CORS configured properly
- [ ] HTTPS enabled (automatic)
- [ ] Logs show no errors

---

## Getting Help

- **Render Documentation**: https://render.com/docs
- **Render Community**: https://community.render.com
- **GitHub Issues**: Report bugs in your repository
- **Render Support**: Available in dashboard (paid plans get priority)

---

## Alternative Free Platforms

If you prefer completely free hosting:

### Railway
- **Free tier**: $5 credit/month
- **Pros**: Easy setup, good for full-stack
- **Cons**: Credit expires monthly
- **Signup**: https://railway.app

### Fly.io
- **Free tier**: 3 VMs, 3GB storage
- **Pros**: Good performance, PostgreSQL included
- **Cons**: Slightly complex setup
- **Signup**: https://fly.io

### Vercel + Railway
- **Frontend**: Vercel (free, unlimited)
- **Backend**: Railway (free $5/month credit)
- **Pros**: Best performance for React apps
- **Cons**: Two platforms to manage

---

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
│  │     FREE       │   │   $7/month   │ │
│  └────────────────┘   └──────┬───────┘ │
│                               │          │
│                      ┌────────▼───────┐ │
│                      │ mealy-postgres │ │
│                      │   (Database)   │ │
│                      │      FREE      │ │
│                      └────────────────┘ │
└─────────────────────────────────────────┘
```

---

## Summary

**Total Cost**: $7/month (Backend only - Frontend and Database are FREE)

**Deployment Time**: ~15 minutes

**Steps**:
1. Create PostgreSQL database (FREE)
2. Deploy backend web service ($7/month)
3. Deploy frontend static site (FREE)
4. Configure environment variables
5. Test application

**Alternative**: Use Railway or Fly.io for completely free hosting

---

**Ready to deploy?** Follow the steps above, and you'll have Mealy live in ~15 minutes!

**Need help?** Check the troubleshooting section or contact Render support.

**Last Updated**: 2025-10-11
