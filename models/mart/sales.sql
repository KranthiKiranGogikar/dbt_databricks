with customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (
    select * from {{ ref('stg_payment') }}
),

customer_orders as (

    select
        customer_id,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

order_payments as (select
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
        ),
	 
final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        order_payments.order_id,
        order_payments.order_date,
        order_payments.order_status,
		order_payments.status as payment_status,
        order_payments.created,
		order_payments.totalamount,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders
    from customers
    left join customer_orders using (customer_id)
    left join order_payments using (customer_id) 
    
)

select * from final