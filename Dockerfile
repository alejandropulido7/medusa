# Multi-stage Dockerfile for MedusaJS
FROM node:20-alpine AS builder

WORKDIR /app

RUN apk add --no-cache python3 make g++

COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
RUN npm ci || yarn install --frozen-lockfile || npm install

COPY . .
RUN npm run build || yarn build

# Stage 2: Production runner
FROM node:20-alpine AS runner

WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.medusa ./.medusa
COPY --from=builder /app/medusa-config.* ./

EXPOSE 9000

CMD ["sh", "-c", "npx medusa db:migrate && npm run start"]
