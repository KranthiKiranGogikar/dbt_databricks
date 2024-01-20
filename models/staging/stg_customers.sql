with jaffle_shop_customers as (
	select * from {{ source('lineagedemo','jaffle_shop_customers') }}
),
customers as (

    select
        id as customer_id,
        first_name,
        last_name

    from jaffle_shop_customers

),
final1 as (
    select * from customers
)
select * from final1

{% if target.name != 'prod' %}
where customer_id < 100
{% endif %}