# King Insumos — Tienda online

Next.js 15 + Supabase + Mercado Pago Checkout Pro. Mobile-first, compra sin cuenta.

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

### 4. Vercel
Importar el repo, cargar las variables de `.env.example` y desplegar. El cron diario (`vercel.json`) vence señas y cancela pedidos impagos de más de 48 h.

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
1. Panel `/admin` para Sofía (pedidos, productos, stock, precios masivos, configuración).
2. Cargar el stock real y fotos propias en alta.
3. Academia (cursos, fechas, cupos, inscripción con seña).
4. Fotos, logo en SVG, botón de arrepentimiento y páginas legales.
