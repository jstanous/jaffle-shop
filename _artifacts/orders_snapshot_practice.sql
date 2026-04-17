select
    *
  from 
    jaffle_shop.raw.orders
 where
    id = 23;

update
    jaffle_shop.raw.orders
   set
    status = 'returned'
 where
    id = 23;

select
    *
  from
    dbt_dev.orders_snapshot_jstanous.orders_snapshot
 where id = 23;


select
    *
  from 
    jaffle_shop.raw.orders
 where id between 100 and 104;


 (100, 100, '2025-02-15', 'shipped', current_timestamp),
(101, 84, '2025-02-15', 'shipped', current_timestamp),
(102, 42, '2025-02-15', 'shipped', current_timestamp),
(103, 101, '2025-02-15', 'shipped', current_timestamp),
(104, 66, '2025-02-15', 'shipped', current_timestamp);