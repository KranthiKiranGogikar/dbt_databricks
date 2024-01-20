with jaffle_shop_orders as (
	select * from {{ source('lineagedemo','jaffle_shop_orders') }}
),

final as(
select
    id as order_id,
    user_id as customer_id,
    order_date,
    status

from jaffle_shop_orders)

select * from final