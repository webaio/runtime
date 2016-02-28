FROM node:slim

RUN npm install http-server -g
RUN mkdir -p /html/dist
ADD html/index.html /html/index.html

WORKDIR /tracker

CMD npm install && npm run-script build && cp /tracker/dist/weba.min.js /html/dist/weba.min.js && http-server /html
