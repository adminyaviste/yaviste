alter table public.pedidos_comunes
  add column if not exists cantidad integer,
  add column if not exists precio_unitario numeric(12, 2);

update public.pedidos_comunes
set cantidad = coalesce(cantidad, 1),
    precio_unitario = coalesce(precio_unitario, monto)
where cantidad is null or precio_unitario is null;

alter table public.pedidos_comunes
  alter column cantidad set default 1,
  alter column cantidad set not null,
  alter column precio_unitario set not null;

alter table public.pedidos_comunes
  drop constraint if exists pedidos_comunes_cantidad_check,
  drop constraint if exists pedidos_comunes_precio_unitario_check,
  drop constraint if exists pedidos_comunes_total_check;

alter table public.pedidos_comunes
  add constraint pedidos_comunes_cantidad_check check (cantidad > 0),
  add constraint pedidos_comunes_precio_unitario_check check (precio_unitario > 0),
  add constraint pedidos_comunes_total_check check (monto = cantidad * precio_unitario);

grant insert (cantidad, precio_unitario, monto, producto, atendido_por)
  on public.pedidos_comunes to authenticated;
