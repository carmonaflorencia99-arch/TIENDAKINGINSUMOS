# King Insumos — Tienda online

Next.js 15 + Supabase + Mercado Pago Checkout Pro, publicado en Netlify. Mobile-first, compra sin cuenta.

## Puesta en marcha

### 1. Supabase
1. Crear un proyecto en supabase.com (región São Paulo, la más cercana a Mendoza).
2. **SQL Editor** → pegar y ejecutar `supabase/migrations/0001_init.sql`.
3. Ejecutar `supabase/seed.sql` (categorías, marcas y reglas de pago) y después `supabase/seed-productos.sql` (catálogo completo: 321 productos y 468 variantes; las fotos están en `public/products`).
4. **Project Settings → API**: copiar URL, `anon key` y `service_role key`.
5. Cargar alias, CBU y titular: **Table Editor → settings** (después se va a hacer desde el panel).

### 2. Local
```bash
npm install
cp .env.example .env.local   # completar con las claves
npm run dev                  # http://localhost:3000
npm test                     # pruebas de precios y reglas de checkout
```

### 3. Mercado Pago (cuando se defina el precio online)
1. Con la cuenta de King: mercadopago.com.ar/developers → **Tus integraciones → Crear aplicación** (Checkout Pro).
2. Copiar el **Access Token** de prueba en `MP_ACCESS_TOKEN`.
3. **Webhooks** → URL `https://TU-DOMINIO/api/mp/webhook`, evento **Pagos**. Copiar la clave secreta en `MP_WEBHOOK_SECRET`.
4. Activar el medio: tabla `payment_rules`, fila `mercadopago` → `active = true` y el `discount_pct` que se decida.
5. Probar con usuarios y tarjetas de prueba; después cambiar a credenciales de producción.

### 4. Netlify
1. app.netlify.com → **Add new site → Import an existing project → GitHub** → elegir este repo. Netlify detecta Next.js solo.
2. Antes de desplegar, en **Environment variables**, cargar las de `.env.example` (sin Mercado Pago si todavía no está).
3. **Deploy**. Cuando termine, copiar la dirección (hoy `https://kinginsumostienda.netlify.app`), ponerla en `NEXT_PUBLIC_SITE_URL` y volver a desplegar.
4. La tarea diaria (`netlify/functions/mantenimiento-diario.mjs`) vence señas y cancela pedidos impagos de más de 48 h.

### 5. Dominio propio (Hostinger u otro)
En Netlify: **Domain management → Add a domain**. Netlify muestra los registros DNS a cargar en Hostinger (o los servidores de nombres, si preferís que Netlify maneje el DNS). Después actualizar `NEXT_PUBLIC_SITE_URL` y, si ya está configurado, la URL del webhook de Mercado Pago.

## Cómo está armado

| Qué | Dónde |
|---|---|
| Esquema, seguridad (RLS), funciones de stock, señas y precios masivos | `supabase/migrations/0001_init.sql` |
| Reglas de descuento, seña y combinaciones válidas (con tests) | `src/lib/pricing.ts` |
| Crear pedido + preferencia de MP (precios recalculados en el servidor) | `src/app/api/checkout/route.ts` |
| Confirmación de pago, descuento de stock | `src/app/api/mp/webhook/route.ts` |
| Quick-Add Matrix de pestañas y selector de variantes | `src/components/buy-box.tsx` |
| Mensaje de WhatsApp con el pedido | `src/lib/whatsapp.ts` |

### Reglas de negocio implementadas
- Efectivo en el local: 10% OFF en todo, solo con retiro.
- Transferencia: 10% OFF excepto Extensiones de Pestañas (y sus subcategorías). Retiro o moto.
- Moto: solo pago completo por transferencia.
- Seña 50%: solo con retiro; vence a los 10 días hábiles (lunes a viernes, sin feriados — se cargan en `settings.holidays`). El saldo se recalcula con precios vigentes.
- El stock se descuenta al confirmarse el pago o la seña; se libera si la seña vence.

## Panel de administración (`/admin`)

Un solo acceso para quien esté a cargo de la tienda.

- **Inicio:** comprobantes pendientes, señas por vencer, pedidos para preparar, motos por coordinar, ventas del día y stock bajo.
- **Pedidos:** marcar pagado, registrar seña, completar seña con los precios del día, cambiar estado (preparando, listo para retirar, coordinando moto, entregado), cancelar (devuelve el stock), notas internas y WhatsApp a la clienta.
- **Productos:** buscar, editar datos, variantes, precios, stock, fotos (se achican solas antes de subir) y ficha técnica de adhesivos; crear productos nuevos.
- **Categorías:** portada de cada categoría y subcategoría (se ve en el inicio y arriba de la categoría). Sin portada propia, usa la foto de un producto destacado.
- **Precios:** subir o bajar por % por marca, categoría o todo el catálogo.
- **Configuración:** alias/CBU, barra de anuncios, WhatsApp, horarios, seña, feriados, descuentos, medios de pago e Instagram.

Activarlo en Supabase (SQL Editor):
1. `supabase/migrations/0002_panel.sql`
2. Authentication → Users → **Add user** (email y contraseña del panel, "Auto Confirm User").
3. `supabase/acceso-panel.sql` con ese email.

## Instagram en la tienda

Muestra los últimos 8 posts de la cuenta en el inicio (se actualizan cada hora). Usa la *Instagram API con inicio de sesión de Instagram*.

1. Supabase → SQL Editor: `supabase/migrations/0003_instagram.sql`.
2. La cuenta de Instagram tiene que ser **profesional** (Empresa o Creador).
3. developers.facebook.com → crear app (tipo Empresa) → agregar el producto **Instagram** → *Configuración de la API con inicio de sesión de Instagram* → **Generar token** de la cuenta.
4. Panel → Configuración → Instagram → pegar el token → Conectar.

El token dura 60 días; la tarea diaria lo renueva sola cada semana. Si Instagram falla o no hay token, la sección no aparece.

## Catálogo

- `scripts/catalogo/datos.py`: el catálogo transcripto del PDF de King, producto por producto (precios de lista).
- `scripts/catalogo/catalogo.csv`: planilla para revisar con King. La columna **revisar** marca los precios que no se leían claro; **stock** es un valor de ejemplo (10) hasta cargar el real.
- Para regenerar fotos y SQL después de corregir `datos.py`:
  ```bash
  pip install pymupdf pillow
  python3 scripts/catalogo/generar.py "ruta/al/LISTA INSUMOS.pdf"
  ```
- Fotos propias de King: `scripts/fotos-propias/`, referenciadas en `datos.py` como `"propia:archivo.jpg"`.

## Próximas etapas
2. Cargar el stock real y fotos propias en alta.
3. Academia (cursos, fechas, cupos, inscripción con seña).
4. Fotos, logo en SVG, botón de arrepentimiento y páginas legales.
