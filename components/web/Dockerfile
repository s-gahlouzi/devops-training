FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build

FROM node:20-alpine AS runtime

WORKDIR /app

# Copy public assets
COPY --from=builder /app/public ./public

# Copy the standalone build
COPY --from=builder /app/.next/standalone ./

# Copy static assets (CSS, JS bundles, etc.)
COPY --from=builder /app/.next/static ./.next/static

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
USER nextjs

CMD ["node", "server.js"]
