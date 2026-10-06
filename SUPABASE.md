# Configuracion de Supabase

## Conectar el proyecto

1. En Supabase, abre **Project Settings > API** y copia la URL del proyecto y la clave publica (`publishable` o `anon`) en `supabase-config.js`.
2. En **SQL Editor**, ejecuta todo el contenido de `supabase-setup.sql`.
3. En **Authentication > Providers**, habilita Email para las cuentas del personal. La consulta publica por folio no requiere autenticacion ni un proveedor SMS.
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
- Cliente: introduce el folio de su pedido y puede consultar solo estatus de avance y de pago, entrega y montos de ese pedido, sin iniciar sesion.

La consulta publica acepta el folio mostrado en la nota del pedido (por ejemplo, `#1234567890`); el signo `#` es opcional. Los folios de pedidos nuevos son numericos aleatorios de 10 cifras. Los folios ya emitidos se conservan para que las notas anteriores sigan funcionando. Quien conozca un folio puede ver el resumen de ese pedido; la aplicacion no expone notas, datos personales de facturacion ni el detalle completo del pedido en la consulta publica.

Al cambiar la consulta publica, vuelve a ejecutar todo `supabase-setup.sql` en SQL Editor para actualizar las funciones disponibles.

Publica el sitio bajo HTTP o HTTPS para que el navegador pueda cargar la configuracion y completar la autenticacion. Al iniciar sesion como administrador, la pagina ofrece importar los pedidos antiguos guardados en ese navegador si aun no estan en Supabase.
