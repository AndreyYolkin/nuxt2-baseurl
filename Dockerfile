FROM node:16.15.0 AS deps

WORKDIR /app
COPY ./package.json ./package-lock.json ./
RUN npm ci

FROM node:16.15.0 AS builder

WORKDIR /app
COPY --from=deps /app/node_modules node_modules
COPY . .

RUN npm run generate

FROM nginx:1.21.3-alpine as runner
# copy dist folder from builder stage to nginx and run
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/dist /dist

EXPOSE 8080
