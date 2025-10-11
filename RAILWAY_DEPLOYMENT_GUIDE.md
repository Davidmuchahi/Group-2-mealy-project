# Deploy Mealy to Railway - Completely FREE

Complete guide to deploy the Mealy food ordering platform to Railway using their free tier.

## Why Railway?

**Railway offers a completely FREE tier:**
- **$5 in free usage credits per month** (enough for small to medium projects)
- **PostgreSQL database included** (FREE)
- **Both frontend and backend** can run on free tier
- **Easy deployment** from GitHub
- **No credit card required** for free tier

---

## Prerequisites

- A [Railway account](https://railway.app) (sign up free with GitHub)
- Your code pushed to a GitHub repository
- GitHub account

---

## Quick Deploy (10 Minutes)

### Step 1: Sign Up for Railway

1. Go to https://railway.app
2. Click **"Login"** or **"Start a New Project"**
3. Sign in with GitHub (recommended)
4. Authorize Railway to access your repositories

### Step 2: Create a New Project

1. Click **"New Project"**
2. Select **"Deploy from GitHub repo"**
3. Choose your repository: `Group-2-mealy-project`
4. Railway will detect your project automatically

### Step 3: Deploy Backend Service

1. Railway will show detected services
2. Click **"Add variables"** or configure the backend:

**Backend Configuration:**
- **Service Name**: `mealy-backend`
- **Root Directory**: `server` (IMPORTANT!)
- **Build Command**: Auto-detected from `nixpacks.toml`
- **Start Command**: Auto-detected from `nixpacks.toml`

3. **Add Environment Variables** (click "Variables" tab):

   | Variable Name | Value |
   |---------------|-------|
   | `FLASK_APP` | `app.py` |
   | `FLASK_ENV` | `production` |
   | `JWT_SECRET_KEY` | Click "Generate" or use: `railway-secret-$(openssl rand -hex 32)` |
   | `SECRET_KEY` | Click "Generate" or use: `railway-secret-$(openssl rand -hex 32)` |
   | `PORT` | `5000` |
   | `PYTHON_VERSION` | `3.11.0` |

   **Note**: Don't add DATABASE_URL yet - we'll do that after creating the database.

4. Click **"Deploy"**

### Step 4: Add PostgreSQL Database

1. In your project dashboard, click **"New"**
2. Select **"Database"**
3. Choose **"Add PostgreSQL"**
4. Railway will automatically:
   - Create a PostgreSQL database
   - Generate a `DATABASE_URL` environment variable
   - Link it to your backend service

5. **Verify DATABASE_URL** is automatically added to backend service
   - Go to backend service → "Variables"
   - You should see `DATABASE_URL` with value `${{Postgres.DATABASE_URL}}`

### Step 5: Deploy Frontend Service

1. In your project dashboard, click **"New"**
2. Select **"GitHub Repo"**
3. Choose the same repository: `Group-2-mealy-project`
4. Click **"Add Service"**

**Frontend Configuration:**

1. **Settings** tab:
   - **Service Name**: `mealy-frontend`
   - **Root Directory**: `client`
   - **Build Command**: `npm install && npm run build`
   - **Start Command**: `npx serve -s build -l $PORT`

2. **Variables** tab - Add environment variables:

   | Variable Name | Value |
   |---------------|-------|
   | `NODE_VERSION` | `18.x` |
   | `REACT_APP_API_URL` | Your backend URL (see below) |
   | `PORT` | `3000` |

3. **Get Backend URL**:
   - Go to backend service → "Settings" tab
   - Under "Networking", click **"Generate Domain"**
   - Copy the URL (e.g., `https://mealy-backend-production-abc123.up.railway.app`)
   - Go back to frontend "Variables" tab
   - Set `REACT_APP_API_URL` to the backend URL

4. **Generate Frontend Domain**:
   - In frontend service → "Settings" → "Networking"
   - Click **"Generate Domain"**
   - Your frontend will be available at this URL

5. Click **"Deploy"**

### Step 6: Wait for Deployments

- Backend: 3-5 minutes
- Frontend: 2-3 minutes
- Watch the logs in the "Deployments" tab

### Step 7: Test Your Application

1. **Test Backend**:
   - Visit: `https://your-backend.up.railway.app/health`
   - Should return: `{"ok": true}`

2. **Test Frontend**:
   - Visit: `https://your-frontend.up.railway.app`
   - Should load the Mealy homepage

3. **Test Full Flow**:
   - Register a new user
   - Login
   - Browse menu
   - Place an order

---

## Alternative: Deploy Using Railway CLI

### Install Railway CLI

```bash
# macOS/Linux
curl -fsSL https://railway.app/install.sh | sh

# Windows (PowerShell)
iwr https://railway.app/install.ps1 | iex

# Or with npm
npm install -g @railway/cli
```

### Login

```bash
railway login
```

### Deploy Backend

```bash
# Initialize project
railway init

# Link to your project
railway link

# Add PostgreSQL
railway add --database postgres

# Deploy backend
cd server
railway up

# Set environment variables
railway variables set FLASK_APP=app.py
railway variables set FLASK_ENV=production
railway variables set JWT_SECRET_KEY=$(openssl rand -hex 32)
railway variables set SECRET_KEY=$(openssl rand -hex 32)
railway variables set PORT=5000
```

### Deploy Frontend

```bash
# Create new service for frontend
railway service create mealy-frontend

# Deploy frontend
cd ../client
railway up

# Set environment variables
railway variables set NODE_VERSION=18.x
railway variables set REACT_APP_API_URL=https://your-backend.up.railway.app
railway variables set PORT=3000
```

---

## Environment Variables Reference

### Backend Environment Variables

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `DATABASE_URL` | Yes | PostgreSQL connection string | Auto-generated by Railway |
| `FLASK_APP` | Yes | Flask entry point | `app.py` |
| `FLASK_ENV` | Yes | Environment mode | `production` |
| `JWT_SECRET_KEY` | Yes | JWT token secret | Generate with `openssl rand -hex 32` |
| `SECRET_KEY` | Yes | Flask secret key | Generate with `openssl rand -hex 32` |
| `PORT` | Yes | Server port | `5000` |
| `PYTHON_VERSION` | Yes | Python version | `3.11.0` |
| `GOOGLE_CLIENT_ID` | No | Google OAuth (optional) | Your Google client ID |
| `APPLE_CLIENT_ID` | No | Apple OAuth (optional) | Your Apple client ID |

### Frontend Environment Variables

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `REACT_APP_API_URL` | Yes | Backend API URL | `https://mealy-backend.up.railway.app` |
| `NODE_VERSION` | Yes | Node.js version | `18.x` |
| `PORT` | Yes | Frontend port | `3000` |

---

## Configuration Files

### `nixpacks.toml` (Backend)

This file is already created in your repository. It tells Railway how to build the backend:

```toml
[phases.setup]
nixPkgs = ["python311", "postgresql"]

[phases.install]
cmds = [
  "cd server",
  "pip install --upgrade pip",
  "pip install -r requirements.txt"
]

[phases.build]
cmds = [
  "cd server",
  "flask db upgrade"
]

[start]
cmd = "cd server && gunicorn --bind 0.0.0.0:$PORT --workers 2 --timeout 120 app:app"
```

### `railway.json` (General Config)

Already exists in your repository:

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "nixpacks"
  },
  "deploy": {
    "healthcheckPath": "/health",
    "healthcheckTimeout": 100
  }
}
```

---

## Database Migrations

Railway automatically runs migrations during deployment (configured in `nixpacks.toml`).

### Manual Migrations (if needed)

1. Go to backend service in Railway dashboard
2. Click **"Settings"** → **"Deploy"** tab
3. Update build command to include migration:
   ```bash
   cd server && flask db migrate -m "your message" && flask db upgrade
   ```

Or use Railway CLI:

```bash
railway run flask db migrate -m "your message"
railway run flask db upgrade
```

---

## Troubleshooting

### Build Failures

**Backend build fails**:
- Check logs in "Deployments" tab
- Verify `nixpacks.toml` is in root directory
- Ensure `server/requirements.txt` is complete
- Check Python version compatibility

**Frontend build fails**:
- Verify `client/package.json` exists
- Check Node version (18.x recommended)
- Review build logs for missing dependencies
- Try building locally first: `cd client && npm install && npm run build`

### Runtime Errors

**"Failed to fetch" or "Network Error"**:
- Backend is starting (wait 30 seconds)
- Wrong `REACT_APP_API_URL` in frontend
- CORS issue (check backend logs)
- Backend service crashed (check logs)

**Database Connection Error**:
- DATABASE_URL not set correctly
- Database service not running
- Database not linked to backend service
- Check: Go to Variables tab and verify `DATABASE_URL`

**Module Not Found Errors**:
- Missing dependency in requirements.txt or package.json
- Add the missing package and redeploy

**Port Binding Issues**:
- Make sure backend uses `$PORT` environment variable
- Check `app.py` uses: `port = int(os.getenv("PORT", 5000))`

### Frontend Issues

**Blank page or 404 on routes**:
- Check `client/public/_redirects` exists with: `/*    /index.html   200`
- Verify build completed successfully
- Check browser console for errors

**Environment variables not working**:
- Must rebuild frontend after changing variables
- React env vars must start with `REACT_APP_`
- Check Variables tab shows correct values

---

## Monitoring Your Application

### View Logs

1. Go to your service in Railway dashboard
2. Click **"Deployments"** tab
3. Click on latest deployment
4. View real-time logs

### Monitor Usage

1. Go to project dashboard
2. Click **"Usage"** tab
3. See:
   - Current usage vs. $5 free credit
   - CPU and memory usage
   - Network usage
   - Database size

### Set Up Alerts

1. Go to project settings
2. Click **"Notifications"**
3. Add email or Discord webhook
4. Get notified of:
   - Deployment failures
   - Service crashes
   - High usage warnings

---

## Cost Management

### Free Tier Details

- **$5 in credits per month** (resets monthly)
- **Usage includes**:
  - CPU time
  - Memory usage
  - Network bandwidth
  - Database storage

### Typical Usage for Mealy

**Expected monthly usage** (small to medium traffic):
- Backend: $2-3/month
- Frontend: $1-2/month
- Database: $0.50-1/month
- **Total: $3.50-6/month** (within free tier!)

### If You Exceed Free Tier

**Option 1**: Optimize usage
- Reduce dyno count
- Lower memory allocation
- Optimize database queries

**Option 2**: Upgrade to paid plan
- **Developer Plan**: $5/month (additional $5 credit)
- **Team Plan**: $20/month (additional $20 credit)

### Monitor Usage

Check usage regularly:
```bash
railway status
```

Or in dashboard: Project → "Usage" tab

---

## Automatic Deployments

Railway automatically redeploys when you push to your connected GitHub branch:

```bash
git add .
git commit -m "Update feature"
git push origin main
```

Railway detects the push and automatically redeploys affected services.

### Disable Auto-Deploy

1. Go to service settings
2. Scroll to "Deploy"
3. Toggle off "Automatic Deployments"

---

## Database Backups

### Manual Backup

Using Railway CLI:

```bash
# Backup database to local file
railway run pg_dump $DATABASE_URL > backup.sql

# Restore from backup
railway run psql $DATABASE_URL < backup.sql
```

### Automatic Backups

Railway doesn't provide automatic backups on free tier. Consider:

1. **Manual backups** weekly:
   ```bash
   railway run pg_dump $DATABASE_URL > backup-$(date +%Y%m%d).sql
   ```

2. **Cron job** for automated backups (requires separate service)

3. **Upgrade to paid plan** for automatic backups

---

## Custom Domain (Optional)

### Add Custom Domain

1. Go to frontend service
2. Click **"Settings"** → **"Networking"**
3. Click **"Custom Domain"**
4. Enter your domain: `mealy.com`
5. Add DNS records as shown:
   ```
   CNAME mealy.com -> your-app.up.railway.app
   ```
6. Wait for SSL certificate (automatic, ~5 minutes)

**Note**: Custom domains are free on Railway!

---

## Security Best Practices

1. **Use Strong Secrets**:
   ```bash
   # Generate strong secrets
   openssl rand -hex 32
   ```

2. **Restrict CORS** in production:
   ```python
   # server/app.py
   CORS(app, resources={r"/*": {
       "origins": ["https://your-frontend.up.railway.app"]
   }})
   ```

3. **HTTPS Only**:
   - Automatically enabled by Railway
   - All traffic is encrypted

4. **Database Access**:
   - Use private networking (automatic on Railway)
   - Database only accessible from your services

5. **Environment Variables**:
   - Never commit secrets to Git
   - Use Railway's environment variable management
   - Rotate secrets regularly

---

## Scaling Your Application

### Horizontal Scaling

Railway supports multiple instances:

1. Go to service settings
2. Increase replica count
3. Railway handles load balancing automatically

**Note**: This increases usage and may exceed free tier.

### Vertical Scaling

Increase resources per instance:

1. Go to service settings
2. Adjust memory/CPU allocation
3. Redeploy

---

## CI/CD Integration

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Railway

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install Railway CLI
        run: npm install -g @railway/cli

      - name: Deploy
        run: railway up
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
```

Add `RAILWAY_TOKEN` to GitHub secrets:
1. Railway dashboard → Settings → Tokens
2. Generate new token
3. Add to GitHub repo secrets

---

## Comparing Railway vs Render

| Feature | Railway (FREE) | Render (FREE + Paid) |
|---------|----------------|----------------------|
| Backend | $5 credit/month | $7/month (paid) |
| Frontend | $5 credit/month | FREE |
| Database | Included in credit | FREE |
| **Total Cost** | **$0-5/month** | **$7/month** |
| Build Time | Fast | Medium |
| Ease of Setup | Very Easy | Easy |
| Custom Domains | FREE | Paid plan only |
| Auto-deploy | Yes | Yes |
| Logs | Real-time | Real-time |

**Winner for FREE deployment: Railway**

---

## Post-Deployment Checklist

- [ ] Backend health check returns `{"ok": true}`
- [ ] Frontend loads correctly
- [ ] User registration works
- [ ] User login works
- [ ] Menu items display
- [ ] Orders can be placed
- [ ] Database connected
- [ ] Environment variables set
- [ ] CORS configured
- [ ] HTTPS enabled (automatic)
- [ ] Logs show no errors
- [ ] Usage within free tier ($5/month)

---

## Getting Help

### Railway Resources
- **Documentation**: https://docs.railway.app
- **Discord Community**: https://discord.gg/railway
- **Status Page**: https://status.railway.app
- **GitHub**: https://github.com/railwayapp/nixpacks

### Railway CLI Help
```bash
railway help
railway logs --help
railway status --help
```

### Common Commands
```bash
# View logs
railway logs

# Check service status
railway status

# Open dashboard
railway open

# Run commands in production
railway run <command>

# Connect to database
railway run psql
```

---

## Maintenance

### Update Dependencies

**Backend**:
```bash
# Update Python packages
pip install --upgrade -r server/requirements.txt
pip freeze > server/requirements.txt
git commit -am "Update Python dependencies"
git push
```

**Frontend**:
```bash
# Update npm packages
cd client
npm update
npm audit fix
git commit -am "Update npm dependencies"
git push
```

### Monitor Health

Set up monitoring:
1. Use Railway's built-in metrics
2. Add external monitoring (UptimeRobot, Pingdom)
3. Set up error tracking (Sentry)

### Regular Tasks

- **Weekly**: Check logs for errors
- **Bi-weekly**: Review usage metrics
- **Monthly**: Update dependencies
- **Quarterly**: Security audit

---

## Advanced Configuration

### Environment-Specific Variables

Railway supports multiple environments:

1. Create new environment: `production`, `staging`
2. Set different variables per environment
3. Deploy branches to different environments

### Private Networking

Railway provides private networking between services:
- Services can communicate via internal URLs
- More secure than public URLs
- Faster response times

### Custom Build Command

Override `nixpacks.toml` if needed:

**Backend Settings** → **Deploy**:
- Build Command: `cd server && pip install -r requirements.txt && flask db upgrade`
- Start Command: `cd server && gunicorn --bind 0.0.0.0:$PORT app:app`

---

## Migration from Render to Railway

If you already deployed on Render:

1. **Export Render database**:
   ```bash
   pg_dump $RENDER_DATABASE_URL > render_backup.sql
   ```

2. **Import to Railway**:
   ```bash
   railway run psql $DATABASE_URL < render_backup.sql
   ```

3. **Update DNS** to point to Railway URLs

4. **Cancel Render services** to avoid charges

---

## Summary

**Railway Deployment**:
- **Cost**: $0/month (within $5 free tier)
- **Time to Deploy**: ~10 minutes
- **Difficulty**: Easy
- **Best For**: Small to medium projects, hobby projects, MVPs

**Services Deployed**:
1. PostgreSQL Database (FREE)
2. Flask Backend API (FREE)
3. React Frontend (FREE)

**Total Monthly Cost**: **$0** (if usage stays under $5 credit)

---

**Ready to deploy?** Follow the Quick Deploy steps above and have Mealy live on Railway in 10 minutes!

**Questions?** Check Railway's excellent documentation at https://docs.railway.app

**Last Updated**: 2025-10-11
