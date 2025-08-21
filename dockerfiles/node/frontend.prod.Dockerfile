FROM node:lts-alpine AS build

WORKDIR /app
COPY ./vue-dashboard/package*.json ./
RUN npm install
COPY ./vue-dashboard .
RUN npm run build

# --- NGINX stage ---
FROM nginx:stable-alpine AS production

COPY ./dockerfiles/nginx/conf.d/frontend.dev.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
