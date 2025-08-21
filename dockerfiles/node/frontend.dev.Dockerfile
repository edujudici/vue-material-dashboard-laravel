FROM node:lts-alpine

WORKDIR /app

COPY ./vue-dashboard/package*.json ./

RUN npm install

COPY ./vue-dashboard .

EXPOSE 8080

CMD ["npm", "run", "dev"]
