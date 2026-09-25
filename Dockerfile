# Multi-stage Dockerfile for Medusa v2
FROM node:20-alpine AS builder

WORKDIR /app

RUN apk add --no-cache python3 make g++

RUN corepack enable || true

COPY package.json yarn.lock* .yarnrc.yml* ./
COPY .yarn ./.yarn

RUN yarn install

COPY . .

RUN yarn build

# Production runner
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.medusa ./.medusa
COPY --from=builder /app/medusa-config.ts ./
COPY --from=builder /app/src ./src

EXPOSE 9000

CMD ["sh", "-c", "npx medusa db:migrate && npm run start"]
