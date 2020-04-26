#Stage 0 --> Compile Main.elm to index.html
FROM alpine:3.11.2 AS builder
RUN wget -O - 'https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz' \
    | gunzip -c >/usr/local/bin/elm
RUN chmod +x /usr/local/bin/elm
RUN apk add --update nodejs npm
RUN npm install uglify-js --global
WORKDIR /app
COPY . .
RUN elm make src/Main.elm 
#--optimize --output=elm.js


#Stage 1 --> based on Nginx, to have only the compiled app, ready for production with Nginx 
FROM nginx:latest 
COPY  --from=builder /app/index.html /app/index.html 
COPY  --from=builder /app/index.html /usr/share/nginx/html
COPY  --from=builder /app/site2.conf etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]