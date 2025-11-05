# Usa una imagen base ligera de Nginx
FROM nginx:alpine

# Copia el contenido actual (index.html, img/, etc.) al directorio público de Nginx
COPY . /usr/share/nginx/html

# Expón el puerto 80
EXPOSE 80

# Inicia Nginx
CMD ["nginx", "-g", "daemon off;"]