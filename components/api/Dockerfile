# a multi-stage build pattern

# 1. Build Stage
# Based on node:20-alpine.
# Installs dependencies, compiles TypeScript into /dist.
# Produces build artifacts but may contain unnecessary files (devDependencies, TS source code, etc.).
FROM node:20-alpine AS builder
WORKDIR /api
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts
COPY . .
RUN npm run prisma:generate
RUN npm run build

# 2. Production Stage
# Copies only what’s necessary to run the app (dist/, node_modules, package.json).
#Each FROM creates a new, independent image layer

FROM node:20-alpine AS runtime
WORKDIR /api
ENV NODE_ENV=production
COPY --from=builder /api/node_modules ./node_modules
COPY --from=builder /api/dist ./dist
COPY --from=builder /api/prisma ./prisma
ENV PORT=3001
EXPOSE 3001
CMD ["node", "dist/index.js"]
