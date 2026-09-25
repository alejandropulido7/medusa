# Deploying Medusa v2 on Dokploy

This repository contains a clean, production-ready **Medusa v2** store backend configured for **Dokploy** with PostgreSQL 16 and Redis 7.

---

## Architecture

- **Medusa Backend**: Port `9000` (Node 20 runtime, built-in Admin at `/app`).
- **PostgreSQL 16**: Relational database with automatic health check before Medusa starts.
- **Redis 7**: Workflow execution engine, pub/sub, and caching.
- **Data Persistence**: Docker volumes `medusa_pgdata` and `medusa_redisdata`.

---

## Step-by-Step Dokploy Deployment

1. **Create Service**:
   - In your Dokploy project, click **Create Service** and choose **Compose**.
   - Link this repository (`https://github.com/alejandropulido7/medusa`) and select branch `main`.

2. **Configure Environment Variables**:
   - Open the **Environment** tab in your Dokploy Compose service.
   - Set the variables based on `.env.example`:
     - Generate secure keys with `openssl rand -base64 32` for `JWT_SECRET` and `COOKIE_SECRET`.
     - Set `MEDUSA_BACKEND_URL` to your backend URL (e.g. `https://api.yourdomain.com`).
     - Set `STORE_CORS` to your Vercel storefront URL (e.g. `https://your-store.vercel.app`).
     - Set `ADMIN_CORS` to your backend domain (e.g. `https://api.yourdomain.com`).
     - Set `AUTH_CORS` with both backend and storefront domains comma-separated.

3. **Domain & Routing**:
   - In the **Domains** section of your Dokploy service:
     - Domain: `api.yourdomain.com` (or your subdomain).
     - Service: `medusa`.
     - Port: `9000`.
     - Enable **HTTPS / Let's Encrypt**.

4. **Deploy**:
   - Click **Deploy**. Dokploy will build the image, start Postgres and Redis, run migrations (`npx medusa db:migrate`), and launch the Medusa server.

5. **Create First Admin User**:
   - In Dokploy, open the terminal of the running `medusa` container and execute:
     ```bash
     npx medusa user --email admin@yourdomain.com --password YourSecurePassword
     ```
   - Access the Admin panel at `https://api.yourdomain.com/app`.
