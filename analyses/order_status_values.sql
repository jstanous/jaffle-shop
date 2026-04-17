select status
  from {{ source('jaffle_shop', 'orders') }}
 group by 1
 order by 1