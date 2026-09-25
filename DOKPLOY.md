# Deploying MedusaJS on Dokploy

This setup includes everything needed to run MedusaJS alongside PostgreSQL 16 and Redis 7 in a self-hosted Dokploy instance.

---

## 1. Quick Overview

- **Medusa Backend**: Runs on port `9000` (Node.js runtime with built-in Admin dashboard).
- **PostgreSQL 16**: Relational database with automatic health check before Medusa boots.
- **Redis 7**: Pub/sub, workflow event bus, and caching.
- **Persistence**: Volumes `medusa_pgdata` and `medusa_redisdata` ensure data is persisted across deployments.

---

## 2. Dokploy Deployment Steps

1. **Create Service**:
   - In your Dokploy Project dashboard, click **Create Service** and choose **Compose**.
   - Connect this GitHub repository and select the target branch (`deploy/dokploy`).

2. **Configure Environment Variables**:
   - Open the **Environment** tab in your Dokploy Compose service.
   - Copy the keys from `.env.example` and set secure values:
     - Generate secrets with `openssl rand -base64 32` for `JWT_SECRET` and `COOKIE_SECRET`.
     - Set your domain in `MEDUSA_BACKEND_URL`, `ADMIN_CORS`, `STORE_CORS`, and `AUTH_CORS`.

3. **Configure Domains & Traefik Routing**:
   - In the **Domains** section of your Dokploy service:
     - Domain: `api.yourdomain.com` (or your chosen subdomain).
     - Target Service: `medusa`.
     - Port: `9000`.
     - Enable **HTTPS / Let's Encrypt** certificate.

4. **Deploy**:
   - Click **Deploy**. Dokploy will start PostgreSQL and Redis, wait until healthy, run database migrations (`npx medusa db:migrate`), and start Medusa.

5. **Create the First Admin User**:
   - Once running, open the terminal of the `medusa` container from the Dokploy UI and run:
     ```bash
     npx medusa user --email admin@yourdomain.com --password YourSecurePassword
     ```
   - Access your Admin dashboard at `https://api.yourdomain.com/app`.
