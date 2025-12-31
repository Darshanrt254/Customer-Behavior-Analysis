create database mydatabase;

show databases;

select *
from customers1;

select gender , sum(purchase_amount) as 'revenue'
from customers1 c
group by gender
;

-- -Q2. Which customers used a discount but still spent more than the average purchase amount?-- 
select customer_id , purchase_amount
from customers1 c
where (purchase_amount >= (select AVG(purchase_amount) from customers1)) and (discount_applied='Yes');



-- Q3. Which are the top 5 products with the highest average review rating?

select  item_purchased, round(avg(review_rating),2) as 'avg rating'
from customers1
group by item_purchased
order by avg(review_rating) desc
limit 50;


-- Q4. Compare the average Purchase Amounts between Standard and Express Shipping.

select shipping_type, round(avg(purchase_amount),2) as 'total shipping revenue'
from customers1
where shipping_type='standard' or shipping_type='express'
group by shipping_type
;


-- Q5. Do subscribed customers spend more? Compare average spend and total revenue
-- between subscribers and non-subscribers.

select subscription_status,count(customer_id) as 'Total customers' ,round(avg(purchase_amount),2) as 'Avg spend', sum(purchase_amount) as "Total spend" 
from customers1
group by subscription_status
;

-- Q6. Which 5 products have the highest percentage of purchases with discounts applied?
select item_purchased, count(*) as 'no purchase' ,100*sum(case when discount_applied='yes' then 1 else 0 end )/ count(*) as 'discount_rate'
from customers1
group by item_purchased
order by discount_rate
desc ;


-- Q7. Segment customers into New, Returning, and Loyal based on their total
-- number of previous purchases, and show the count of each segment.
WITH customer_segments AS (
    SELECT
        customer_id,
        CASE
            WHEN previous_purchases = 1 THEN 'New'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customers1
)
SELECT
    customer_segment,
    COUNT(*) AS total_customers
FROM customer_segments
GROUP BY customer_segment;



-- Q8. What are the top 3 most purchased products within each category?

with categories as (
select item_purchased, category, count(customer_id) as "no_of_purchases"
from customers1
group by category,item_purchased
)


select category , item_purchased, no_of_purchases
from categories
where category = "clothing"
order by "total_purchased_amount"
desc;



-- Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
select subscription_status, sum( (case when previous_purchases>5 then 1 else 0 end)) as 'No_of_Repeat_buyers'
from customers1
group by subscription_status
;

-- or 

select subscription_status,count(customer_id)as 'no of customers'
from customers1
where previous_purchases>5
group by subscription_status
;


-- Q10. What is the revenue contribution of each age group?

select age_group,sum(purchase_amount)as 'total_revenue'
from customers1
group by age_group