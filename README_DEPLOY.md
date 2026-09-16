# 🚀 Academia Vértice — Guía de despliegue en Easypanel (vertice.fluentia.marketing)

Esta carpeta contiene la página **lista para desplegar**. El `index.html` es el
**bundle autocontenido** de Claude Design: todas las imágenes, fuentes, CSS y
JS van embebidos en el propio HTML (base64). Solo depende de la CDN pública
`unpkg.com` para cargar React.

**Ventaja:** al ser un fichero autocontenido **no hay ninguna ruta relativa o
absoluta local que se pueda romper** al publicarse en un subdominio o
subdirectorio. No hace falta configurar Base URL.

---

## 📦 Contenido de la carpeta

| Archivo | Función |
|---|---|
| `index.html` | La web completa (bundle de ~4 MB) |
| `Dockerfile` | Sirve la web con nginx (lo detecta Easypanel automáticamente) |
| `nginx.conf` | Configuración nginx: fallback, gzip, caché |

---

## ✅ Paso 1 — Sube estos archivos a GitHub

1. Ve a tu repositorio (`vertice-web` o el que hayas creado).
2. Asegúrate de que la rama es `main` o `master` (la que uses).
3. Sube **obligatoriamente estos 3 archivos en la raíz del repo**:
   - `index.html`
   - `Dockerfile`
   - `nginx.conf`
   - (opcional) este `README_DEPLOY.md`
4. **Nota importante:** si ya subiste solo `index.html`, añade ahora el
   `Dockerfile` y `nginx.conf`.

> ⚠️ El nombre del fichero debe ser **exactamente** `index.html` (minúsculas).

---

## 🔑 Paso 2 — Verifica el token clásico de GitHub

Easypanel usa tu token para clonar el repositorio y recibir el *webhook* de
despliegue automático.

El token clásico debe tener **marcado `repo`** (acceso completo a repositorios):

- Crea el token aquí: GitHub → Settings → Developer settings → Personal
  access tokens → Tokens (classic) → **Generate new token (classic)**
- Scopes obligatorios:
  - ☑️ **`repo`** (full control of private repositories) → necesario SIEMPRE
  - ☑️ **`workflow`** → solo si el repo usara GitHub Actions (este no, pero no molesta)
  - Expiration: 90 días (o `No expiration` si prefieres)
- Copia el token (empieza por `ghp_`) antes de cerrar la página.

**Cómo conectar en Easypanel:**
1. En Easypanel ve a **Projects → Proyecto → Sources** (fuentes).
2. Añade `GitHub`.
3. Pega el token.
4. Cuando aparezca la lista de tus repositorios, **la conexión es correcta**.
   Si sale error 401/403, el token no tiene el scope `repo` o está mal copiado.

> 💡 *Alternativa recomendada por Easypanel:* **GitHub App** en vez de token
> clásico. Es más segura, pero el token clásico funciona igual para este caso.

---

## 🖥️ Paso 3 — Configura la app `vertice-web` en Easypanel

1. Entra en tu proyecto (por ejemplo `wordpress`) y abre la app **`vertice-web`**.
2. Ve a la pestaña **Source** / **Código fuente**:
   - Selecciona **GitHub** → elige tu repositorio.
   - Rama: `main` (o la tuya).
   - Build type / Tipo de build: **Dockerfile** (Easypanel lo detecta solo).
   - *Base directory:* déjalo vacío (los archivos están en la raíz del repo).
3. Guarda. Easypanel construirá la imagen nginx automáticamente y publicará:
   - Puerto del contenedor: **`80`** (definido en el Dockerfile).
4. Pulsa **Deploy** (Deploy / Build & Deploy).

---

## 🌐 Paso 4 — Configura el dominio (verificación)

Abre en el panel:
`/projects/wordpress/app/vertice-web/domains`

Debes ver algo así:

| Dominio | Estado |
|---|---|
| `vertice.fluentia.marketing` | ✅ Aceptado / Certificado emitido |

**Checklist de verificación**

- [ ] El dominio que aparece es **exactamente** `vertice.fluentia.marketing`
      (sin `http://`, sin `/` al final, sin mayúsculas).
- [ ] Si al añadirlo Easypanel pide confirmar que el DNS apunta a tu IP,
      hazlo desde el gestor DNS de `fluentia.marketing`:
      - Registro **A**: `vertice` → **IP de tu servidor** (la misma que usas
        para entrar a `http://IP:3000`).
      - (o registro **CNAME**: `vertice` → `fluentia.marketing` si quieres seguirlo).
- [ ] **HTTPS activado** (Easypanel emite el certificado Let's Encrypt
      automáticamente una vez el DNS resuelve y el servicio está desplegado).
- [ ] La primera vez, espera 1–3 minutos tras activar HTTPS para que se emita.
- [ ] Si el certificado falla, revisa en el panel **Logs / Activity** el mensaje
      exacto (casi siempre es "el DNS aún no resuelve").

> 🧭 **Sobre el "Base URL /mi-subdirectorio/":** `vertice.fluentia.marketing` es
> un **subdominio**, no un subdirectorio. En un subdominio la raíz del sitio web
> es la propia raíz del dominio, así que **no necesitas prefijo de subdirectorio
> ni Base URL**. Y como el `index.html` es autocontenido, este punto queda
> cubierto automáticamente.

---

## 🧪 Paso 5 — Verificación final

1. Abre en tu navegador: `https://vertice.fluentia.marketing`
2. Comprueba:
   - [ ] Carga la página (sin errores en consola F12).
   - [ ] Se ven las imágenes (hero, profesores, testimonios, blog…).
   - [ ] El menú ancla funciona (`#oposiciones`, `#metodologia`, `#contacto`…).
   - [ ] Los botones externos (WhatsApp `wa.me`) abren en pestaña nueva.
   - [ ] En móvil se ve bien (responsive).
3. **Depuración rápida si algo falla:**
   - F12 → pestaña **Network**: si ves `unpkg.com` en rojo = problema de red/CDN
     (no de tu página). Espera y recarga.
   - F12 → pestaña **Console**: copia el mensaje rojo si aparece alguno.

---

## 🔁 Actualizaciones futuras

Cada vez que quieras actualizar la página:
1. Exporta de nuevo el HTML desde Claude Design y **reemplaza** `index.html`.
2. Haz `git add . && git commit && git push`.
3. Easypanel desplegará automáticamente vía webhook (si está activo), o pulsa
   **Deploy** manualmente.

---

## 🛠️ Probar localmente (antes de subir)

Desde esta carpeta:

```bash
docker build -t vertice-web .
docker run -p 8080:80 vertice-web
# abre http://localhost:8080
```

O sin Docker, con Python:

```bash
python -m http.server 8080
# abre http://localhost:8080
```