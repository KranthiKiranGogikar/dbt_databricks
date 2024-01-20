with orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (
    select * from {{ ref('stg_payment') }}
)

select
        a.customer_id,
        a.order_id,
        a.order_date,
        a.status as order_status,
        payments.status,
		payments.created,
        sum(payments.amount) as totalamount
        from orders a 
        left join payments using (order_id) 
        group by 1,2,3,4,5,6