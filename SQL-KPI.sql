use OList;

/* -------------------------------- KPI - 1 -------------------------------- */
/*	Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics */
 
SELECT
    SUM(CASE WHEN DATENAME(WEEKDAY, ORD.order_purchase_timestamp) NOT IN ('Saturday','Sunday') 
		THEN PY.payment_value ELSE 0 END) AS "Weekday",
    SUM(CASE WHEN DATENAME(WEEKDAY, ORD.order_purchase_timestamp) IN ('Saturday','Sunday') 
		THEN PY.payment_value ELSE 0 END) AS "Weekend"
FROM
    olist_order_payments AS PY
JOIN
	olist_orders AS ORD ON PY.order_id = ORD.order_id;

/* -------------------------------- KPI - 2 -------------------------------- */
/* Number of Orders with review score 5 and payment type as credit card. */

SELECT
	COUNT(ORD_R.order_id) AS 'Review Greater than 5 for Credit Card'
FROM
	olist_order_reviews as ORD_R
JOIN
	olist_order_payments as PY
	on ORD_R.order_id = PY.order_id
WHERE
	PY.payment_type = 'credit_card' and ORD_R.review_score = 5;


/* -------------------------------- KPI - 3 -------------------------------- */
/* Average number of days taken for order_delivered_customer_date for pet_shop */

SELECT
	AVG(DATEDIFF(DAY, ORD.order_purchase_timestamp,ORD.order_delivered_customer_date)) AS "Average Shipping Days"
FROM
	olist_orders as ORD
JOIN
	olist_order_items as ORDIT ON ORDIT.order_id = ORD.order_id
JOIN
	olist_products as PRD ON PRD.product_id = ORDIT.product_id
WHERE 
	product_category_name = 'pet_shop';


/* -------------------------------- KPI - 4 -------------------------------- */
/* Average price and payment values from customers of sao paulo city */

SELECT 
	AVG(OI.price) as "Average Price",
	AVG(PY.payment_value) as "Average Payment"
FROM
	olist_order_payments as PY
JOIN
	olist_order_items as OI on OI.order_id = PY.order_id
JOIN
	olist_orders AS ORD ON ORD.order_id = PY.order_id 
JOIN
	olist_customers as CST on CST.customer_id = ORD.customer_id
WHERE
	lower(customer_city) = 'sao paulo';


/* -------------------------------- KPI - 5 -------------------------------- */
/* Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores. */

SELECT 
	REV.review_score,
	AVG(DATEDIFF(DAY,ORD.order_purchase_timestamp,ORD.order_delivered_customer_date)) as "Average Shipping Days"
FROM 
	olist_orders AS ORD
JOIN
	olist_order_reviews AS REV ON REV.order_id = ORD.order_id
GROUP BY 
	REV.review_score
ORDER BY
	REV.review_score DESC;


/* -------------------------------- Additional KPI'S  -------------------------------- */
/*1. Total Orders and sales expenses according to City*/

select 
	CST.customer_city as "City",
	COUNT(Pay.order_id) as "No. of Orders",
	Sum(Pay.payment_value) as "Total Revenue"
from
	olist_order_payments as Pay
join
	olist_orders as ORD on Pay.order_id = ORD.order_id
JOIN
	olist_customers as CST on CST.customer_id = ORD.customer_id
group by
	CST.customer_city
order by 
	COUNT(Pay.order_id) desc;


/*2. Average Review Scores for Delivered Orders*/

SELECT
	COUNT(ORD.order_id) as "No. of Delivered Orders", 
	AVG(Rev.review_score) as "Average Review Scores"
FROM 
	olist_orders as ORD
JOIN
	olist_order_reviews as Rev on ORD.order_id = Rev.order_id
WHERE 
	lower(ORD.order_status) = 'delivered';

/*3. Total Orders Received According to Year */
SELECT 
    YEAR(order_purchase_timestamp) AS "Year",
    COUNT(order_id) AS "Total Orders"
FROM 
    olist_orders
GROUP BY
    YEAR(order_purchase_timestamp)
ORDER BY 
    YEAR(order_purchase_timestamp) DESC;

/*4. Total No. of Customers Connected*/
SELECT 
	COUNT(customer_id) AS "No. of Custoemrs" 
FROM 
	olist_customers;

/*5. Total No. of Products */
SELECT 
	COUNT(product_id) AS "No. of Products" 
FROM 
	olist_products;

/*6. Total No. of Selers Connected*/
SELECT 
	COUNT(seller_id) AS "No. of Sellers" 
FROM 
	olist_sellers ;


/*7. Products Available Under Each Category */
SELECT
	product_category_name AS "Product Category",
	COUNT(product_id) AS "No. of Products Available"
FROM
	olist_products
GROUP BY
	product_category_name
ORDER BY
	COUNT(product_id) DESC;


/*8. Average days required to deliver to customer according to customer State*/
SELECT
	CST.customer_state,
	AVG(DATEDIFF(DAY,ORD.order_delivered_carrier_date,order_delivered_customer_date)) AS "Average Days Required for Delivery"  
FROM
	olist_orders AS ORD
JOIN
	olist_customers as CST ON CST.customer_id = ORD.customer_id
GROUP BY
	CST.customer_state;


/*9. Number of Sellers , Customers According to States */

SELECT 
	 CST.customer_state as "State",
	 COUNT(distinct cst.customer_id) AS "No. of Customers",
	 COUNT(distinct Sellers.seller_id) AS "No. of Sellers"
FROM
	olist_customers AS CST
JOIN
	olist_orders AS ORD ON ORD.customer_id = CST.customer_id
JOIN
	olist_order_items AS ORDI on ORDI.order_id = ORD.order_id
JOIN
	olist_sellers AS Sellers ON Sellers.seller_id = ORDI.seller_id
GROUP BY
	 CST.customer_state;

