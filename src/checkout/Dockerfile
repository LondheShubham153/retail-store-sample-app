# # ---- Stage 1: Build ----
# FROM node:20-alpine AS builder

# WORKDIR /app

# # dependencies install
# COPY package.json yarn.lock ./
# RUN yarn install --frozen-lockfile

# # source code copy
# COPY . .

# # build the app
# RUN yarn build

# # ---- Stage 2: Production ----
# FROM node:20-alpine

# WORKDIR /app

# # only production deps
# COPY package.json yarn.lock ./
# RUN yarn install --frozen-lockfile --production

# # copy built files from builder
# COPY --from=builder /app/dist ./dist

# # expose port (Nest default 3000)
# EXPOSE 3000

# # run app
# CMD ["node", "dist/main"]

# optimized dockerfile for better caching and smaller image size, using multi-stage builds and only copying necessary files to the final image
# ---- Build Stage ----
# ---- Build Stage ----
# ---- Build Stage ----
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies (including dev for build)
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy source & build
COPY . .
RUN yarn build

# ---- Production Stage ----
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

# Install ONLY production dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production=true \
    && yarn cache clean

# Copy built app
COPY --from=builder /app/dist ./dist

# Security: non-root user
RUN addgroup -S app && adduser -S app -G app
USER app

# App port
EXPOSE 3000

# Start app
CMD ["node", "dist/main"]