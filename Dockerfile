# ---------------------------------------------------------------------------
# Academia Vértice — Sitio estático para Easypanel
# Servidor: nginx sirviendo el bundle autocontenido index.html
# Despliegue: Easypanel detecta este Dockerfile automáticamente al conectar
#             el repositorio de GitHub con la app "vertice-web".
# ---------------------------------------------------------------------------

# Imagen ligera de nginx
FROM nginx:1.27-alpine

# Etiquetas informativas (opcionales)
LABEL maintainer="Academia Vértice <info@academiavertice.es>"
LABEL description="Página estática Academia Vértice — bundle autocontenido Claude Design"

# Copia toda la web a la raíz de nginx
COPY . /usr/share/nginx/html

# Configuración personalizada: fallback a index.html, compresión y caché
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Limpieza (el bundle autocontenido no necesita archivos de build)
RUN rm -f /usr/share/nginx/html/Dockerfile /usr/share/nginx/html/nginx.conf /usr/share/nginx/html/README_DEPLOY.md

EXPOSE 80