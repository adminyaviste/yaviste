# Configuracion de Supabase

## Conectar el proyecto

1. En Supabase, abre **Project Settings > API** y copia la URL del proyecto y la clave publica (`publishable` o `anon`) en `supabase-config.js`.
2. En **SQL Editor**, ejecuta todo el contenido de `supabase-setup.sql`.
3. En **Authentication > Providers**, habilita Email para las cuentas del personal. La consulta de clientes no requiere autenticacion ni un proveedor SMS.
4. Crea las cuentas de administrador y empleados en **Authentication > Users** con correo y contrasena.
5. Asigna cada cuenta en SQL Editor, sustituyendo el correo:

```sql
insert into public.staff_roles (user_id, role)
select id, 'admin' from auth.users where email = 'admin@ejemplo.com'
on conflict (user_id) do update set role = excluded.role;

insert into public.staff_roles (user_id, role)
select id, 'empleado' from auth.users where email = 'empleado@ejemplo.com'
on conflict (user_id) do update set role = excluded.role;
```

Solo agrega cuentas confiables. La aplicacion nunca necesita la clave `service_role` ni una clave secreta; no las pongas en archivos del sitio.

## Permisos aplicados

- Administrador: puede consultar, crear, editar y eliminar pedidos.
- Empleado: puede crear pedidos nuevos y consultar pedidos; en pedidos existentes puede cambiar el estatus de avance y el de pago mientras siga pendiente. Una vez pagado, solo el administrador puede cambiar el estatus de pago.
- Cliente: introduce su numero de WhatsApp y puede consultar solo folio, estatus de avance y de pago, entrega y montos asociados con ese numero, sin codigo de verificacion. Cualquiera que conozca el numero puede ver ese resumen.

El numero introducido debe coincidir con el WhatsApp guardado en el pedido. La aplicacion no expone notas, datos personales de facturacion ni el detalle completo del pedido en la consulta publica.

Publica el sitio bajo HTTP o HTTPS para que el navegador pueda cargar la configuracion y completar la autenticacion. Al iniciar sesion como administrador, la pagina ofrece importar los pedidos antiguos guardados en ese navegador si aun no estan en Supabase.
