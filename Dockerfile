# Usa la imagen oficial de PHP como base
FROM php:7.4-apache

# Copia el archivo PHP a la carpeta pública del servidor Apache
COPY index.php /var/www/html/

# Expone el puerto 80 para acceder a la aplicación
EXPOSE 80
