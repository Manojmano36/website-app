# 1️⃣ Base image (small, secure, production standard)
FROM nginx:1.25-alpine

# 2️⃣ Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# 3️⃣ Copy our application
COPY app/ /usr/share/nginx/html/

# 4️⃣ Expose HTTP port
EXPOSE 80

# 5️⃣ Run nginx in foreground (required for containers)
CMD ["nginx", "-g", "daemon off;"]
