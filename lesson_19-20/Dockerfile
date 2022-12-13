FROM  node:16
WORKDIR  /home/yegharr/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD  ["node","server.js"]