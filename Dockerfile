FROM node:22.12.0

WORKDIR /app

#COPY ["package*.json", ".env.example", ".npmrc", "./"]

#RUN npm install --save --legacy-peer-deps rimraf

COPY ./project/ /app/

ENV NODE_ENV=development

EXPOSE 3000

CMD ["npm", "run", "dev"]
