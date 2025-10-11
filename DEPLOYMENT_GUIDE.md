# Mealy Project - Deployment Guide

## 🚀 Choose Your Deployment Platform

This guide provides instructions for deploying the Mealy full-stack application on different platforms.

---

## 📋 Deployment Options

### Option 1: Railway (Recommended - Completely FREE)
**Best for**: Free deployment, easy setup, full-stack apps

- **Cost**: $0/month (within $5 free credit)
- **Includes**: Backend + Frontend + Database
- **Setup Time**: ~10 minutes
- **Difficulty**: Easy

**📖 [Railway Deployment Guide →](./RAILWAY_DEPLOYMENT_GUIDE.md)**

---

### Option 2: Render (Partially FREE)
**Best for**: Those who prefer Render or already have an account

- **Cost**: $7/month (backend only - frontend & database are free)
- **Includes**: Backend (paid) + Frontend (free) + Database (free)
- **Setup Time**: ~15 minutes
- **Difficulty**: Easy

**📖 [Render Deployment Guide →](./RENDER_DEPLOYMENT_GUIDE.md)**

---

## 🎯 Quick Comparison

| Feature | Railway | Render |
|---------|---------|--------|
| **Backend Cost** | FREE ($5 credit) | $7/month |
| **Frontend Cost** | FREE ($5 credit) | FREE |
| **Database Cost** | FREE ($5 credit) | FREE |
| **Total Monthly Cost** | **$0** | **$7** |
| **Build Speed** | Fast | Medium |
| **Ease of Setup** | Very Easy | Easy |
| **Custom Domains** | FREE | Paid only |
| **Auto-deploy** | ✅ Yes | ✅ Yes |
| **CLI Tool** | ✅ Yes | ❌ No |

---

## 🏆 Our Recommendation

### For Most Users: Railway

**Why Railway?**
- ✅ Completely FREE (within $5/month credit)
- ✅ Typically uses $3-6/month for small to medium apps
- ✅ Easy to set up and deploy
- ✅ Great developer experience
- ✅ Includes everything you need
- ✅ No credit card required for free tier

**When to use Render:**
- You already have a Render account
- You're willing to pay $7/month for backend
- You prefer Render's interface

---

## 📚 Detailed Deployment Guides

### Railway Deployment

**Follow this guide for completely FREE deployment:**

**📖 [Complete Railway Deployment Guide](./RAILWAY_DEPLOYMENT_GUIDE.md)**

**Quick Summary:**
1. Sign up for Railway with GitHub
2. Create new project from your repository
3. Add PostgreSQL database
4. Deploy backend service
5. Deploy frontend service
6. Set environment variables
7. Test your application

**Total Time**: ~10 minutes
**Total Cost**: $0/month

---

### Render Deployment

**Follow this guide if you prefer Render:**

**📖 [Complete Render Deployment Guide](./RENDER_DEPLOYMENT_GUIDE.md)**

**Quick Summary:**
1. Sign up for Render with GitHub
2. Create PostgreSQL database (FREE)
3. Deploy backend web service ($7/month)
4. Deploy frontend static site (FREE)
5. Set environment variables
6. Test your application

**Total Time**: ~15 minutes
**Total Cost**: $7/month

---

## 🔑 Environment Variables Needed

### Backend Environment Variables

Both platforms require these backend environment variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection | Auto-generated |
| `FLASK_APP` | Flask entry point | `app.py` |
| `FLASK_ENV` | Environment mode | `production` |
| `JWT_SECRET_KEY` | JWT token secret | Generate with `openssl rand -hex 32` |
| `SECRET_KEY` | Flask secret key | Generate with `openssl rand -hex 32` |
| `PORT` | Server port | `5000` |

### Frontend Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `REACT_APP_API_URL` | Backend URL | `https://your-backend.up.railway.app` |
| `NODE_VERSION` | Node.js version | `18.x` |

---

## 📦 What Gets Deployed

### Backend (Flask API)
- **Location**: `server/` directory
- **Runtime**: Python 3.11
- **Framework**: Flask
- **Database**: PostgreSQL
- **Server**: Gunicorn
- **Key Features**:
  - User authentication (JWT)
  - Menu management
  - Order processing
  - Admin dashboard

### Frontend (React App)
- **Location**: `client/` directory
- **Runtime**: Node.js 18.x
- **Framework**: React
- **Build Tool**: Create React App
- **Key Features**:
  - User registration/login
  - Menu browsing
  - Order placement
  - Order history

### Database (PostgreSQL)
- **Type**: PostgreSQL 15
- **Tables**:
  - Users
  - Caterers
  - Daily Menus
  - Dishes
  - Orders
  - Order Items

---

## 🧪 Testing Your Deployment

After deployment, test these endpoints:

### 1. Backend Health Check
```
URL: https://your-backend-url/health
Expected Response: {"ok": true}
```

### 2. Backend API Info
```
URL: https://your-backend-url/
Expected Response: JSON with all API endpoints
```

### 3. Frontend Application
```
URL: https://your-frontend-url
Expected: Mealy homepage loads
```

### 4. Full Integration Test
1. Visit frontend URL
2. Register a new user
3. Login with credentials
4. Browse menu (if available)
5. Place an order (if menu exists)

---

## 🔧 Configuration Files

These files are already configured in your repository:

### For Railway:
- `railway.json` - General Railway configuration
- `nixpacks.toml` - Build and deployment instructions
- `server/requirements.txt` - Python dependencies
- `client/package.json` - Node.js dependencies

### For Render:
- `render.yaml` - Blueprint configuration
- `server/requirements.txt` - Python dependencies
- `client/package.json` - Node.js dependencies
- `client/public/_redirects` - React Router configuration

---

## 🐛 Common Issues

### Issue 1: Build Fails

**Symptoms**: Deployment fails during build phase

**Solutions**:
- Check build logs for specific errors
- Verify all dependencies are in `requirements.txt` or `package.json`
- Ensure correct Python/Node version
- Try building locally first

### Issue 2: Database Connection Error

**Symptoms**: Backend can't connect to database

**Solutions**:
- Verify `DATABASE_URL` is set correctly
- Check database service is running
- Ensure database and backend are in same region (Render)
- Check database is linked to backend service (Railway)

### Issue 3: Frontend Can't Connect to Backend

**Symptoms**: "Network Error" or "Failed to fetch" in frontend

**Solutions**:
- Verify `REACT_APP_API_URL` is set correctly
- Must rebuild frontend after changing env vars
- Check backend is running and accessible
- Verify CORS is configured in backend

### Issue 4: 404 on Frontend Routes

**Symptoms**: Refreshing a route gives 404 error

**Solutions**:
- Ensure `client/public/_redirects` exists
- Verify file contains: `/*    /index.html   200`
- Check redirect rules in platform settings

---

## 🔄 Continuous Deployment

Both platforms support automatic deployments:

### Setup
1. Connect your GitHub repository
2. Choose branch to deploy (usually `main`)
3. Enable auto-deploy

### Workflow
```bash
# Make changes locally
git add .
git commit -m "Update feature"
git push origin main

# Platform automatically detects push and redeploys
```

### Disable Auto-Deploy
- **Railway**: Service Settings → Deployment → Toggle off
- **Render**: Service Settings → Build & Deploy → Toggle off

---

## 🔐 Security Best Practices

### 1. Use Strong Secrets
```bash
# Generate secure secrets
openssl rand -hex 32
```

### 2. Restrict CORS in Production
```python
# server/app.py
CORS(app, resources={r"/*": {
    "origins": ["https://your-frontend-url.com"]
}})
```

### 3. Never Commit Secrets
- Use platform's environment variable management
- Never commit `.env` files to Git
- Add `.env` to `.gitignore`

### 4. Use HTTPS Only
- Both platforms provide HTTPS automatically
- Never use HTTP in production

### 5. Keep Dependencies Updated
```bash
# Backend
pip list --outdated
pip install --upgrade -r requirements.txt

# Frontend
npm outdated
npm update
```

---

## 📊 Monitoring & Maintenance

### Monitor Usage
- **Railway**: Project → Usage tab
- **Render**: Service → Metrics tab

### View Logs
- **Railway**: Service → Deployments → View logs
- **Render**: Service → Logs tab

### Set Up Alerts
- **Railway**: Project Settings → Notifications
- **Render**: Not available on free tier

### Regular Maintenance Tasks
- **Weekly**: Check logs for errors
- **Bi-weekly**: Review usage metrics
- **Monthly**: Update dependencies
- **Quarterly**: Security audit

---

## 💰 Cost Optimization

### Railway (FREE)
**To stay within free tier ($5/month):**
- Typical usage: $3-6/month
- Monitor usage regularly
- Optimize database queries
- Use caching where possible

**If you exceed:**
- Upgrade to Developer Plan: $5/month (additional $5 credit)

### Render (PAID)
**Current cost: $7/month**

**To reduce costs:**
- Keep frontend on free tier
- Use free PostgreSQL database
- Optimize backend resource usage

---

## 🎓 Learning Resources

### Platform Documentation
- **Railway**: https://docs.railway.app
- **Render**: https://render.com/docs

### Framework Documentation
- **Flask**: https://flask.palletsprojects.com
- **React**: https://react.dev
- **PostgreSQL**: https://www.postgresql.org/docs

### Community Support
- **Railway Discord**: https://discord.gg/railway
- **Render Community**: https://community.render.com

---

## ✅ Deployment Checklist

Before deploying:
- [ ] Code is pushed to GitHub
- [ ] `requirements.txt` is up to date
- [ ] `package.json` is up to date
- [ ] All tests pass locally
- [ ] Environment variables are documented

After deploying:
- [ ] Backend health check works
- [ ] Frontend loads correctly
- [ ] User registration works
- [ ] User login works
- [ ] Database is connected
- [ ] CORS is configured
- [ ] HTTPS is enabled
- [ ] Logs show no errors

---

## 🆘 Getting Help

### Platform Support
- **Railway**: Discord community, documentation
- **Render**: Email support (paid plans), community forum

### Project Issues
- Create issue in GitHub repository
- Check existing issues first
- Provide detailed error messages and logs

### Quick Debugging
1. Check platform status page
2. Review deployment logs
3. Verify environment variables
4. Test backend health endpoint
5. Check browser console for frontend errors

---

## 🎉 Next Steps After Deployment

1. **Test thoroughly**:
   - Register users
   - Create menus (as admin)
   - Place orders
   - Check order history

2. **Set up monitoring**:
   - Add uptime monitoring
   - Configure error alerts
   - Track usage metrics

3. **Add custom domain** (optional):
   - Register a domain
   - Configure DNS
   - Add to platform settings

4. **Implement CI/CD** (optional):
   - Add automated tests
   - Set up staging environment
   - Configure deployment pipelines

5. **Scale as needed**:
   - Monitor performance
   - Upgrade resources if needed
   - Add caching for optimization

---

## 📖 Deployment Guide Links

- **Railway (FREE)**: [RAILWAY_DEPLOYMENT_GUIDE.md](./RAILWAY_DEPLOYMENT_GUIDE.md)
- **Render ($7/month)**: [RENDER_DEPLOYMENT_GUIDE.md](./RENDER_DEPLOYMENT_GUIDE.md)

---

## 🔗 Record Your Deployment

After successful deployment, record your URLs:

**Platform Used**: `________________` (Railway / Render)

**Backend URL**: `_________________________________`

**Frontend URL**: `_________________________________`

**Database**: `_________________________________`

**Deployment Date**: `_________________________________`

**Monthly Cost**: `_________________________________`

---

**Ready to deploy?** Choose your platform above and follow the detailed guide!

**Need help?** Check the troubleshooting section or reach out to the platform's support community.

**Last Updated**: 2025-10-11
