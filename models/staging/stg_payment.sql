with stripe_payments as (
	select * from {{ source('lineagedemo','jaffle_shop_payments') }}
),
final as (
select
    id as payment_id,
  orderid as order_id,
  status ,
  amount ,
  created 
from stripe_payments)

select * from final
