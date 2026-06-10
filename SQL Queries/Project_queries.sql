-- =======================================================================================================================================
--- OLIST E-COMMERCE ANALYTICS PROJECT
--- BUSINESS KPI ANALYSIS
--- Author : Sanidhya Mandliya
-- =======================================================================================================================================

USE project_vacation;
-- ========================================================================================================================================
----CUSTOMER ANALYSIS
-- ========================================================================================================================================
-- Q1. TOTAL ORDERS
-- Objective:
-- Determine the total number of orders placed by customers
-- during the analysis period.
-- =====================================================

select count(*)
from customer_order_payment

-- Insight:
-- The dataset contains 99,440 customer orders, representing
-- the total transactions completed during the analysis period.
--
-- Result:
-- Total Orders = 99,440

-- ==========================================================================================================
-- Q2. TOTAL REVENUE
-- Objective:
-- Determine the total revenue generated from all customer
-- orders in the dataset.
-- ===========================================================================================================

select sum(payment_value) as total_revenue 
from customer_order_payment

-- Insight:
-- The business generated a total revenue of approximately
-- 16.01 million monetary units from all customer orders.
--
-- Result:
-- Total Revenue = 16,008,872.12

-- ============================================================================================================
-- Q3. TOTAL CUSTOMERS
-- Objective:
-- Determine the total number of unique customers served
-- by the business.
-- =============================================================================================================

select count(distinct customer_unique_id) as total_customers
from customer_order_payment

-- Insight:
-- The business served 96,095 unique customers during
-- the analysis period. The use of customer_unique_id
-- ensures that repeat customers are counted only once.
--
-- Result:
-- Total Customers = 96,095

-- =======================================================================================================================================
-- Q4. AVERAGE ORDER VALUE
-- Objective:
-- Calculate the average revenue generated per order and
-- understand the typical customer spending behaviour.
-- =======================================================================================================================================

select sum(payment_value)/count(distinct order_id) as AVERAGE_ORDER_VALUE 
from customer_order_payment

-- Insight:
-- On average, customers spend approximately 160.99
-- monetary units per order, indicating the typical
-- value generated from a single transaction.
--
-- Result:
-- Average Order Value = 160.99

-- ======================================================================================================================================
-- Q5. AVERAGE REVIEW SCORE
-- Objective:
-- Measure overall customer satisfaction using review
-- ratings provided by customers.
-- ======================================================================================================================================

SELECT ROUND(AVG(review_score),2) as average_review_score
from review_order_customer

-- Insight:
-- Customers provided an average review score of 4.09 out
-- of 5, indicating a generally positive shopping
-- experience and high customer satisfaction.
--
-- Result:
-- Average Review Score = 4.09

-- ============================================================================================================================================
-- CUSTOMER ANALYSIS
-- ========================================================================================================================================

-- =====================================================
-- Q6. CUSTOMERS BY STATE
-- Objective:
-- Identify customer distribution across different states
-- and determine which states contribute the highest
-- number of customers.
-- =====================================================

----CUSTOMER DISTRIBUTION
select customer_state,count(distinct customer_unique_id) as CUSTOMER_COUNT
from customer_order_payment 
group by customer_state
order by CUSTOMER_COUNT desc 

----HIGHEST CONTRIBUTION STATE
select customer_state,count(distinct customer_unique_id) as CUSTOMER_COUNT
from customer_order_payment 
group by customer_state
order by CUSTOMER_COUNT desc 
LIMIT 1

-- Insight:
-- Customer distribution varies significantly across states.
-- The state with the highest customer concentration contributes
-- the largest share of the customer base and represents the
-- most important regional market for the business.
--
-- Result:
-- State-wise customer distribution generated successfully.

-- =====================================================
-- Q7. CUSTOMERS BY CITY
-- Objective:
-- Analyze customer distribution across cities and
-- identify the cities with the highest customer base.
-- =====================================================

-----CUSTOMER DISTRIBUTION
select customer_city,count(distinct customer_unique_id) as CUSTOMER_COUNT
from customer_order_payment 
group by customer_city
order by CUSTOMER_COUNT desc 

------HIGHEST CUSTOMER BASE 
select customer_city,count(distinct customer_unique_id) as CUSTOMER_COUNT
from customer_order_payment 
group by customer_city
order by CUSTOMER_COUNT desc 
LIMIT 1


-- Insight:
-- Customer concentration is unevenly distributed across
-- cities. A few major cities contribute a significant
-- portion of the overall customer base, indicating strong
-- market penetration in urban regions.
--
-- Result:
-- City-wise customer distribution generated successfully.

-- ========================================================================================================================================
-- Q8. REPEAT CUSTOMERS
-- Objective:
-- Identify customers who have placed more than one order
-- and measure customer retention behaviour.
-- ========================================================================================================================================

select customer_unique_id
from customer_order_payment
group by customer_unique_id
having count(*)>1

-- Insight:
-- A subset of customers placed more than one order,
-- indicating repeat purchasing behaviour and customer
-- retention within the business.
--
-- Result:
-- List of repeat customers generated successfully.


-- =====================================================
-- Q9. REPEAT CUSTOMER PERCENTAGE
-- Objective:
-- Calculate the percentage of customers who have placed
-- more than one order and evaluate customer retention.
-- =====================================================

with cte as (select count(distinct customer_unique_id) as TOTAL_CUSTOMERS from customer_order_payment),
cte_1 as(select count(*) as REPEAT_CUSTOMERS
from(select customer_unique_id
from customer_order_payment
group by customer_unique_id
having count(*)>1)a)
select ROUND((REPEAT_CUSTOMERS*1.0/TOTAL_CUSTOMERS)*100,2) AS percentage_retained
FROM cte,cte_1

-- Insight:
-- Approximately 3.12% of customers placed more than
-- one order, indicating a relatively low repeat purchase
-- rate and highlighting an opportunity to improve
-- customer retention strategies.
--
-- Result:
-- Repeat Customer Percentage = 3.12%

-- =====================================================
-- Q10. TOP 10 STATES BY CUSTOMERS
-- Objective:
-- Identify the states with the largest customer base
-- and understand regional market dominance.
-- =====================================================

select customer_state,count(distinct customer_unique_id) as TOTAL_CUSTOMER
from customer_order_payment
group by customer_state
order by total_customer desc
limit 10

-- Insight:
-- Customer acquisition is highly concentrated in a few
-- states. SP leads the customer base with 40,301 unique
-- customers, followed by RJ and MG, indicating strong
-- market penetration in these regions.
--
-- Result:
-- Top 10 customer-contributing states identified successfully.

-- =====================================================
-- Q10A. TOP 5 CITIES WITH HIGHEST REPEAT CUSTOMER RATE
-- Objective:
-- Identify cities where customers are most likely to
-- place repeat orders and evaluate customer loyalty
-- at the city level.
-- =====================================================
with cte as(select customer_city,count(*) as REPEAT_CUSTOMER_CITY
from
(select customer_city,customer_unique_id
from customer_order_payment
group by customer_city,customer_unique_id
HAVING count(*)>1) a
group by customer_city
),

cte_1 as(select customer_city,count(distinct customer_unique_id) as total_city_customer
from customer_order_payment
group by customer_city)

select c.customer_city,(max(REPEAT_CUSTOMER_CITY)*1.0/max(total_city_customer))*100 as RATE_RETAINED
from cte c inner join cte_1 c1 on c.customer_city=c1.customer_city
group by c.customer_city,c1.customer_city
ORDER BY RATE_RETAINED DESC 
LIMIT 5 

-- Insight:
-- Customer loyalty varies significantly across cities.
-- While some cities exhibit very high repeat customer
-- rates, the results should be interpreted carefully
-- because cities with a very small customer base can
-- produce inflated retention percentages. A minimum
-- customer threshold should be applied before making
-- strategic business decisions.
--
-- Result:
-- Top 5 cities with the highest repeat customer rates
-- were identified successfully.

-----This question taught an important business lesson:
A mathematically correct result
≠
A business-reliable result
(EXAMPLE)
--1 Customer
↓
--Orders Twice
↓
--100% Retention
--The SQL is correct.
--The conclusion may not be.

-- ========================================================================================================================================
----ORDERS ANALYSIS
-- ========================================================================================================================================

-- =====================================================
-- Q11. ORDER STATUS DISTRIBUTION
-- Objective:
-- Analyze the distribution of orders across different
-- order statuses and evaluate operational performance.
-- =====================================================

 select order_status,count(distinct order_id) as order_distribution
 from customer_order_payment
 group by order_status
 order by order_distribution desc

-- Insight:
-- The majority of orders were successfully delivered,
-- indicating strong order fulfillment performance.
-- Only a small proportion of orders were canceled,
-- unavailable, or remained in intermediate processing
-- stages.
--
-- Result:
-- Order status distribution generated successfully.

-- =====================================================
-- Q12. ORDER STATUS PERCENTAGE
-- Objective:
-- Calculate the percentage contribution of each order
-- status and evaluate overall fulfillment efficiency.
-- =====================================================

WITH cte AS
(
    SELECT COUNT(DISTINCT order_id) AS total_orders
    FROM customer_order_payment
),

cte_1 AS
(
    SELECT order_status,
           COUNT(DISTINCT order_id) AS order_distribution
    FROM customer_order_payment
    GROUP BY order_status
)

SELECT order_status,
       (order_distribution*1.0/total_orders)*100 AS contribution
FROM cte, cte_1
ORDER BY contribution DESC;

-- Insight:
-- Approximately 97.02% of all orders were successfully
-- delivered, indicating strong operational efficiency.
-- The percentage of canceled and unavailable orders
-- remains very low, suggesting an effective order
-- fulfillment process.
--
-- Result:
-- Delivered Orders = 97.02%
-- Canceled Orders  = 0.63%
-- Unavailable Orders = 0.61%

-- =======================================================================================================================================
-- Q13. MONTHLY ORDER TREND
-- Objective:
-- Analyze how order volume changes over time and
-- identify growth or seasonal patterns in customer
-- purchasing behavior.
-- =======================================================================================================================================

select date_format(order_purchase_timestamp,"%Y-%m") as purchase_dates,count(distinct order_id) AS NO_OF_ORDERS 
from customer_order_payment
group by date_format(order_purchase_timestamp,"%Y-%m")
ORDER BY PURCHASE_DATES


-- Insight:
-- Monthly order volume fluctuates over time, revealing
-- periods of increased and decreased customer demand.
-- Trend analysis helps identify business growth patterns,
-- seasonal effects, and peak purchasing periods.
--
-- Result:
-- Monthly order trend generated successfully.

-- ========================================================================================================================================
-- Q14. MONTHLY REVENUE TREND
-- Objective:
-- Analyze revenue growth over time and identify
-- high-performing and low-performing months.
-- ========================================================================================================================================

select date_format(order_purchase_timestamp,"%Y-%m") as purchase_dates,sum(payment_value) as total_revenue
from customer_order_payment
group by date_format(order_purchase_timestamp,"%Y-%m")
ORDER BY total_revenue desc


-- Insight:
-- Monthly revenue varies across the analysis period,
-- highlighting fluctuations in customer spending and
-- business performance. Revenue trend analysis helps
-- identify growth periods, seasonal demand patterns,
-- and peak revenue-generating months.
--
-- Result:
-- Monthly revenue trend generated successfully.

-- =====================================================
-- Q15. MONTH-OVER-MONTH ORDER GROWTH
-- Objective:
-- Measure how order volume changes from one month to
-- the next and identify periods of rapid growth or decline.
-- =====================================================

with cte as(select date_format(order_purchase_timestamp,"%Y-%m") as purchase_dates,count(distinct order_id) AS NO_OF_ORDERS 
from customer_order_payment
group by date_format(order_purchase_timestamp,"%Y-%m")),
cte_1 as(select *,lag(NO_OF_ORDERS,1,0)over(order by purchase_dates) as previous_month_orders
from cte)
select *,round(coalesce(((no_of_orders-previous_month_orders)*1.0/previous_month_orders)*100,0),2) AS MONTH_OVER_MONTH_GROWTH
from cte_1 

-- Insight:
-- Month-over-month growth analysis reveals fluctuations
-- in customer demand across different periods. Positive
-- growth indicates increasing order volume, while negative
-- growth highlights periods of reduced purchasing activity.
-- Such trends help identify expansion phases, seasonal
-- effects, and demand slowdowns.
--
-- Result:
-- Month-over-month order growth calculated successfully.


-- =====================================================
-- Q16. MONTH-OVER-MONTH REVENUE GROWTH
-- Objective:
-- Measure revenue growth from one month to the next and
-- identify periods of significant business expansion
-- or decline.
-- =====================================================

with cte as(select date_format(order_purchase_timestamp,"%Y-%m") as purchase_dates,sum(payment_value) AS TOTAL_REVENUE 
from customer_order_payment
group by date_format(order_purchase_timestamp,"%Y-%m")),
cte_1 as(select *,lag(TOTAL_REVENUE,1,0)over(order by purchase_dates) as previous_month_revenue
from cte)
select *,round(coalesce(((TOTAL_REVENUE-previous_month_revenue)*1.0/previous_month_revenue)*100,0),2) AS MONTH_OVER_MONTH_GROWTH
from cte_1 

-- Insight:
-- Month-over-month revenue growth highlights periods
-- of business expansion and decline. Revenue trends
-- do not always move in line with order volume, making
-- this analysis valuable for understanding changes in
-- customer spending behaviour and overall business
-- performance.
--
-- Result:
-- Month-over-month revenue growth calculated successfully.

-- =====================================================
-- Q17. AVERAGE ORDER TREND ANALYSIS BY MONTH
-- Objective:
-- Analyze how the average order value changes over time
-- and determine whether customers are spending more or
-- less per transaction.
-- =====================================================

with cte as(select date_format(order_purchase_timestamp,"%Y-%m") as purchase_date,sum(payment_value) as total_monthly_revenue,
count(distinct order_id) as total_monthly_orders
from customer_order_payment 
group by date_format(order_purchase_timestamp,"%Y-%m")
order by purchase_date asc),
cte_1 as(select *,round(total_monthly_revenue/total_monthly_orders,2) as average_order_value
from cte),
cte_2 as(select *, lag(average_order_value,1)over(order by purchase_date) as previous_month_value
from cte_1)
select*,round(coalesce(((average_order_value-previous_month_value)*1.0/previous_month_value)*100,0),2) as month_over_month_value
from cte_2


-- Insight:
-- Average Order Value (AOV) varies across months,
-- reflecting changes in customer spending behaviour.
-- Monitoring month-over-month AOV growth helps identify
-- periods where customers spent significantly more or
-- less per transaction, providing deeper insights than
-- revenue analysis alone.
--
-- Result:
-- Monthly Average Order Value trend and growth rate
-- calculated successfully.


-- =====================================================
-- Q18. CUSTOMER SATISFACTION BY ORDER STATUS
-- Objective:
-- Analyze how customer review scores vary across
-- different order statuses and evaluate the impact of
-- operational performance on customer satisfaction.
-- =====================================================

select order_status,round(avg(review_score),2) as avg_review_score 
from review_order_customer
group by order_status

-- Insight:
-- Customer satisfaction is strongly influenced by order
-- fulfillment status. Delivered orders receive the highest
-- average review scores, while canceled, unavailable, and
-- processing orders receive significantly lower ratings.
-- This indicates a direct relationship between operational
-- performance and customer experience.
--
-- Result:
-- Average review score by order status calculated
-- successfully.
-- ========================================================================================================================================
-----CUSTOMER SEGMENTATION
-- ========================================================================================================================================
-- Q19. CUSTOMER SEGMENTATION BY SPENDING
-- Objective:
-- Segment customers into High-Value, Medium-Value, and
-- Low-Value groups based on their total spending and
-- identify the distribution of customers across segments.
-- =====================================================

with cte as(select customer_unique_id,sum(payment_value) as revenue
from customer_order_payment
group by customer_unique_id)
select *,case when revenue<100 then "LOW VALUE"
when revenue between 100 and 200 then "MEDIUM VALUE"
when revenue>200 then "HIGH VALUE" end as CUSTOMER_SEGMENT
from cte 

-- Insight:
-- Customers can be classified into spending-based
-- segments to support targeted marketing and retention
-- strategies. High-value customers contribute a larger
-- share of revenue, while low-value customers represent
-- opportunities for engagement and upselling.
--
-- Result:
-- Customer spending segments generated successfully.

-- =====================================================
-- Q20. CUSTOMER SEGMENT DISTRIBUTION
-- Objective:
-- Determine the number of customers belonging to each
-- spending segment and evaluate the overall customer mix.
-- =====================================================

with cte as(select customer_unique_id,sum(payment_value) as revenue
from customer_order_payment
group by customer_unique_id),
cte_1 as(select *,case when revenue<100 then "LOW VALUE"
when revenue between 100 and 200 then "MEDIUM VALUE"
when revenue>200 then "HIGH VALUE" end as CUSTOMER_SEGMENT
from cte)
select CUSTOMER_SEGMENT,count(*) as total_customers
from cte_1 
group by CUSTOMER_SEGMENT

-- Insight:
-- The customer base is dominated by Low-Value customers,
-- accounting for nearly half of all customers. High-Value
-- customers represent a smaller proportion of the customer
-- base but are expected to contribute significantly to
-- overall revenue. This distribution highlights the
-- importance of customer retention and value enhancement
-- strategies.
--
-- Result:
-- Customer segment distribution generated successfully.

-- =====================================================
-- Q21. REVENUE CONTRIBUTION BY CUSTOMER SEGMENT
-- Objective:
-- Determine how much revenue is generated by each
-- customer segment and identify the most valuable
-- customer group.
-- =====================================================

with cte as(select customer_unique_id,sum(payment_value) as revenue
from customer_order_payment
group by customer_unique_id),
cte_1 as(select *,case when revenue<100 then "LOW VALUE"
when revenue between 100 and 200 then "MEDIUM VALUE"
when revenue>200 then "HIGH VALUE" end as CUSTOMER_SEGMENT
from cte)
select CUSTOMER_SEGMENT,sum(revenue) as total_revenue
from cte_1 
group by CUSTOMER_SEGMENT

-- Insight:
-- High-Value customers contribute the largest share of
-- business revenue despite representing a smaller portion
-- of the customer base. Approximately 21.6% of customers
-- generate nearly 55.7% of total revenue, highlighting
-- the importance of retaining and engaging high-value
-- customers.
--
-- Result:
-- Revenue contribution by customer segment calculated
-- successfully.

-- =====================================================
-- Q22. REPEAT CUSTOMER REVENUE CONTRIBUTION
-- Objective:
-- Compare the revenue contribution of repeat customers
-- and one-time customers to evaluate the business impact
-- of customer retention.
-- =====================================================
select "customer_not_repeated" as customer_type,round(sum(revenue),2) as revenue from
(select customer_unique_id,sum(payment_value) as revenue
from customer_order_payment
group by customer_unique_id
having count(*)=1)a
union all
select "customer_repeated" as customer_type,round(sum(revenue),2) as revenue from
(select customer_unique_id,sum(payment_value) as revenue
from customer_order_payment
group by customer_unique_id
having count(*)>1)b


-- Insight:
-- Although repeat customers represent only a small
-- percentage of the customer base, they contribute a
-- disproportionately higher share of total revenue.
-- Approximately 3.12% of customers generate nearly
-- 5.9% of business revenue, indicating that retained
-- customers are more valuable than the average customer.
--
-- Result:
-- Revenue contribution of repeat and one-time customers
-- calculated successfully.

-- =====================================================
-- Q23. CUSTOMER PURCHASE FREQUENCY SEGMENTATION
-- Objective:
-- Classify customers based on the number of orders they
-- have placed and identify the distribution of customer
-- purchasing behavior.
-- =====================================================

with cte AS(select customer_unique_id,count(distinct order_id) as no_of_orders
from customer_order_payment
group by customer_unique_id),
cte_1 as(select *,case when no_of_orders=1 then "non_repeating_customer"
when no_of_orders between 2 and 5 then "less_frequent_customer"
when no_of_orders>5 then "frequent_customer" end as customer_segment
from cte)
select customer_segment,count(*) as no_of_customers
from cte_1
group by customer_segment

-- Insight:
-- Customer purchasing behavior is heavily concentrated
-- among one-time buyers. Approximately 96.9% of customers
-- place only a single order, while a very small proportion
-- return for additional purchases. The number of highly
-- frequent customers is extremely low, indicating a strong
-- opportunity to improve customer retention and loyalty
-- programs.
--
-- Result:
-- Customer purchase frequency segmentation generated
-- successfully.

-- =====================================================
-- Q24. REVENUE CONTRIBUTION BY PURCHASE FREQUENCY SEGMENT
-- Objective:
-- Determine how much revenue is generated by
-- non-repeating, less-frequent, and frequent customers
-- and evaluate the financial impact of customer loyalty.
-- =====================================================

with cte AS(select customer_unique_id,count(distinct order_id) as no_of_orders,sum(payment_value) as revenue
from customer_order_payment
group by customer_unique_id),
cte_1 as(select *,case when no_of_orders=1 then "non_repeating_customer"
when no_of_orders between 2 and 5 then "less_frequent_customer"
when no_of_orders>5 then "frequent_customer" end as customer_segment
from cte)
select customer_segment,sum(revenue) as revenue
from cte_1
group by customer_segment

-- Insight:
-- The overwhelming majority of business revenue is
-- generated by non-repeating customers. Frequent
-- customers contribute only a negligible share of total
-- revenue due to their extremely small population in the
-- dataset. This suggests that business growth is driven
-- primarily by customer acquisition rather than customer
-- retention.
--
-- Result:
-- Revenue contribution by purchase frequency segment
-- calculated successfully.

-- =====================================================
-- Q25. AVERAGE REVENUE PER CUSTOMER SEGMENT
-- Objective:
-- Compare the average revenue generated per customer
-- across different purchase-frequency segments and
-- evaluate customer value.
-- =====================================================

with cte AS(select customer_unique_id,count(distinct order_id) as no_of_orders,sum(payment_value) as revenue
from customer_order_payment
group by customer_unique_id),
cte_1 as(select *,case when no_of_orders=1 then "non_repeating_customer"
when no_of_orders between 2 and 5 then "less_frequent_customer"
when no_of_orders>5 then "frequent_customer" end as customer_segment
from cte)
select customer_segment,round(sum(revenue)*1.0/count(*),2) as average_revenue
from cte_1
group by customer_segment

-- Insight:
-- Although frequent customers contribute a relatively
-- small share of total revenue due to their limited
-- population, they generate the highest average revenue
-- per customer. Frequent customers spend approximately
-- five times more than non-repeating customers, indicating
-- substantial revenue potential through improved customer
-- retention and loyalty initiatives.
--
-- Result:
-- Average revenue per customer segment calculated
-- successfully.
-- ========================================================================================================================================
----REVIEW/REVENUE ADVANCED ANALYSIS
-- ========================================================================================================================================
-- Q26. TOP 10 CUSTOMERS BY LIFETIME VALUE
-- Objective:
-- Identify the highest-value customers based on their
-- cumulative spending and rank them according to their
-- contribution to business revenue.
-- =====================================================

select * from
(select *,rank()over(order by revenue desc) as rn from
(select customer_unique_id,sum(payment_value) as revenue
from customer_order_payment
group by customer_unique_id)A)b
where rn<=10

-- Insight:
-- Customer spending is highly concentrated among a small
-- number of high-value customers. The top-ranked customers
-- contribute significantly more revenue than the average
-- customer, highlighting the importance of identifying
-- and retaining key revenue-generating customers.
--
-- Result:
-- Top revenue-generating customers identified and ranked
-- successfully.

-- =====================================================
-- Q27. TOP CUSTOMER STATES BY AVERAGE CUSTOMER VALUE
-- Objective:
-- Identify states with the highest average revenue per
-- customer and evaluate regional customer quality.
-- =====================================================

with cte as(select * from
(select *,rank()over(order by revenue desc) as rn from
(select customer_unique_id,sum(payment_value) as revenue
from customer_order_payment
group by customer_unique_id)A)b
where rn<=10),
cte_1 as(select c.*,c1.customer_state
from cte c inner join customer_order_payment c1 on c.customer_unique_id=c1.customer_unique_id
order by rn )
select customer_unique_id,revenue,rn,customer_state
from cte_1 
group by customer_unique_id,revenue,rn,customer_state
order by rn asc

-- Insight:
-- High-value customers are distributed across multiple
-- states rather than being concentrated solely in the
-- largest customer markets. This suggests that customer
-- quality and customer volume do not necessarily follow
-- the same geographic pattern.
--
-- Result:
-- Top revenue-generating customers and their states
-- identified successfully.

-- =====================================================
-- Q28. CUSTOMER REVIEW SCORE DISTRIBUTION
-- Objective:
-- Analyze the distribution of review scores and identify
-- whether customer feedback is generally positive,
-- neutral, or negative.
-- =====================================================

with cte as(select customer_unique_id,sum(review_score) as review_score
from review_order_customer
group by customer_unique_id),
cte_1 as(select *,case when review_score<2 then "negative"
when review_score between 2 and 4 then "neutral" 
when review_score>4 then "positive" end as customer_review_distribution
from cte)
select customer_review_distribution,count(*) as no_of_reviews
from cte_1
group by customer_review_distribution

-- Insight:
-- Customer sentiment is predominantly positive, with
-- nearly 59% of customers falling into the positive
-- review category. Negative customer sentiment remains
-- relatively low, indicating generally favorable
-- customer experiences and satisfaction levels.
--
-- Result:
-- Customer sentiment distribution generated successfully.
-- ========================================================================================================================================
----PRODUCT AND SELLER ANALYSIS
-- ========================================================================================================================================
-- Q29. TOP 10 SELLERS BY REVENUE
-- Objective:
-- Identify the highest-performing sellers based on total
-- revenue generated and evaluate seller contribution to
-- marketplace performance.
-- =====================================================

select seller_id,sum(price) as revenue
from product_sales_orders
group by seller_id
order by revenue desc 
limit 10 


-- Insight:
-- Revenue generation is concentrated among a limited
-- number of sellers. The top-performing sellers
-- contribute substantially to marketplace sales and
-- represent key business partners. Monitoring seller
-- performance can help identify high-value sellers and
-- improve marketplace growth strategies.
--
-- Result:
-- Top 10 revenue-generating sellers identified
-- successfully.

-- =====================================================
-- Q30. PRODUCT CATEGORY REVENUE ANALYSIS
-- Objective:
-- Identify the highest revenue-generating product
-- categories and evaluate category performance across
-- the marketplace.
-- =====================================================

select product_category,sum(price) as revenue 
from product_sales_orders
group by product_category
order by revenue desc

-- Insight:
-- Revenue generation is concentrated among a few key
-- product categories. Health & Beauty and Watches & Gifts
-- are the highest revenue-generating categories, followed
-- by Bed Bath & Table and Sports & Leisure products.
-- These categories represent the primary drivers of
-- marketplace sales and may offer significant growth
-- opportunities through targeted marketing and inventory
-- optimization.
--
-- Result:
-- Product categories ranked successfully based on
-- total revenue generated.

-- =====================================================
-- Q31. PRODUCT CATEGORY REVENUE VS CUSTOMER SATISFACTION
-- Objective:
-- Compare product category revenue with customer review
-- scores to identify categories that generate high sales
-- while maintaining strong customer satisfaction.
-- =====================================================

select p.product_category,sum(p.price) as revenue,avg(r.review_score) as review_avg
from product_sales_orders p inner join review_order_customer r on p.order_id=r.order_id
group by p.product_category
order by revenue desc


-- Insight:
-- Health & Beauty emerges as the strongest product
-- category, combining the highest revenue generation
-- with excellent customer satisfaction. Sports & Leisure
-- also demonstrates strong customer sentiment despite
-- lower revenue levels, indicating growth potential.
-- In contrast, categories such as Bed Bath & Table,
-- Computers & Accessories, and Furniture & Decor generate
-- substantial revenue but receive comparatively lower
-- review scores, suggesting opportunities for product
-- quality and customer experience improvements.
--
-- Result:
-- Product category revenue and customer satisfaction
-- analysis completed successfully.

-- =====================================================
-- Q32. TOP PRODUCT CATEGORIES BY REVENUE PER ORDER
-- Objective:
-- Identify categories with the highest average revenue
-- per order and determine which product categories
-- drive high-value purchases.
-- =====================================================

select product_category,sum(price)/count(distinct order_id) as avg_order_value
from product_sales_orders
group by product_category
order by avg_order_value desc

-- Insight:
-- Product categories differ significantly in their
-- average order values. Computers generate the highest
-- revenue per order, indicating that customers make
-- high-value purchases despite potentially lower order
-- volumes. Home Appliances and Musical Instruments also
-- exhibit strong average order values, suggesting that
-- these categories attract premium spending behavior.
--
-- Result:
-- Product categories ranked successfully by average
-- revenue per order.

-- =====================================================
-- Q33. CATEGORY REVENUE CONCENTRATION ANALYSIS
-- Objective:
-- Determine what percentage of total marketplace revenue
-- is generated by the Top 5 product categories and
-- evaluate category dependency risk.
-- =====================================================

with cte as(select product_category,sum(price) as total_revenue_category
from product_sales_orders
group by product_category),
cte_1 as(select sum(price) as total_revenue from product_sales_orders)
select *,round((total_revenue_category*1.0/total_revenue)*100,2) as percentage_contribution
from cte,cte_1
order by percentage_contribution desc
limit 5

-- Insight:
-- The top five product categories contribute
-- approximately 40% of total marketplace revenue.
-- Revenue generation is distributed across a broad range
-- of product categories, indicating relatively low
-- dependency on any single category. This diversification
-- reduces category-specific business risk and supports
-- marketplace stability.
--
-- Result:
-- Category revenue concentration analysis completed
-- successfully.

-- =====================================================
-- Q34. SELLER REVENUE VS CUSTOMER SATISFACTION
-- Objective:
-- Compare seller revenue with customer review scores
-- to identify high-performing sellers that maintain
-- strong customer satisfaction.
-- =====================================================

select seller_id,sum(price) as total_revenue,avg(review_score) as avg_review
from product_sales_orders p inner join review_order_customer r on p.order_id=r.order_id
group by seller_id
order by total_revenue desc

-- Insight:
-- Top-performing sellers generally maintain strong
-- customer satisfaction while generating significant
-- revenue. However, certain high-revenue sellers exhibit
-- relatively low review scores, indicating potential
-- operational or product-quality concerns. Monitoring
-- both revenue and customer satisfaction provides a more
-- balanced assessment of seller performance.
--
-- Result:
-- Seller revenue and customer satisfaction analysis
-- completed successfully.

-- =====================================================
-- Q35. SELLER REVENUE CONCENTRATION ANALYSIS
-- Objective:
-- Determine what percentage of total marketplace revenue
-- is generated by the Top 10 sellers and evaluate seller
-- dependency risk.
-- =====================================================

with cte as (select seller_id,sum(price) as seller_revenue
from product_sales_orders
group by seller_id),
cte_1 as( select sum(price) as total_revenue from product_sales_orders),
cte_2 as(select *,round((seller_revenue*1.0/total_revenue)*100,2) as percentage_contribution
from cte,cte_1
order by percentage_contribution desc 
limit 10)
select sum(percentage_contribution) as total_contribution_10 from cte_2


-- Insight:
-- The top 10 sellers contribute approximately 13.15%
-- of total marketplace revenue, indicating a highly
-- diversified seller ecosystem. Revenue generation is
-- distributed across a large number of sellers, reducing
-- dependency on individual sellers and minimizing
-- concentration risk. This structure supports marketplace
-- stability and long-term resilience.
--
-- Result:
-- Top 10 sellers collectively contribute 13.15% of total
-- marketplace revenue.

---LOGISTICS ANALYTICS

-- =====================================================
-- Q36. PRODUCT CATEGORIES WITH HIGHEST TOTAL FREIGHT COST
-- Objective:
-- Identify product categories that incur the highest
-- shipping expenses and evaluate logistics-intensive
-- categories within the marketplace.
-- =====================================================

select product_category,sum(freight_value) as freight_cost
from product_sales_orders
group by product_category
order by freight_cost desc

-- Insight:
-- Bed Bath & Table generates the highest total freight
-- cost, followed by Health & Beauty and Furniture Decor.
-- Several categories incur substantial logistics expenses
-- despite not being the highest revenue generators,
-- indicating potential opportunities for shipping cost
-- optimization and logistics efficiency improvements.
--
-- Result:
-- Product categories ranked successfully by total
-- freight cost.

-- =====================================================
-- Q37. FREIGHT-TO-PRICE RATIO ANALYSIS
-- Objective:
-- Identify product categories where shipping costs
-- represent the largest proportion of product value.
-- =====================================================

select product_category,sum(price) as total_product_price,sum(freight_value) as total_freight_price,
round(sum(freight_value)/sum(price),2) as freight_to_price_ratio
from product_sales_orders
group by product_category
order by  freight_to_price_ratio desc

-- Insight:
-- Several product categories exhibit exceptionally high
-- freight-to-price ratios, indicating that shipping
-- costs account for a significant portion of product
-- value. Categories such as Christmas Supplies,
-- Furniture Mattress & Upholstery, and Diapers &
-- Hygiene incur freight costs equal to approximately
-- 37% of product revenue. These categories represent
-- potential opportunities for logistics optimization,
-- pricing adjustments, or shipping cost reduction
-- strategies.
--
-- Result:
-- Product categories ranked successfully by
-- freight-to-price ratio.

-- =====================================================
-- Q38. PRODUCT CATEGORY AVERAGE FREIGHT COST PER ORDER
-- Objective:
-- Identify categories that generate the highest average
-- shipping cost per order and evaluate logistics burden
-- at the transaction level.
-- =====================================================

select product_category,sum(freight_value) as freight_cost,count(distinct order_id) as no_of_orders,
sum(freight_value)/count(distinct order_id)  as avg_freight_cost
from product_sales_orders
group by product_category
order by avg_freight_cost desc

-- Insight:
-- Computers and furniture-related categories generate
-- the highest average freight cost per order, indicating
-- substantial logistics requirements at the transaction
-- level. These categories are likely associated with
-- larger, heavier, or more complex products that require
-- higher shipping expenditure. Logistics optimization
-- efforts within these categories may yield significant
-- cost savings.
--
-- Result:
-- Product categories ranked successfully by average
-- freight cost per order.

-- =====================================================
-- Q39. PRODUCT WEIGHT VS FREIGHT COST ANALYSIS
-- Objective:
-- Evaluate whether heavier products generate higher
-- freight costs and measure the relationship between
-- product weight and shipping expenses.
-- =====================================================

with cte as(select product_weight_g,freight_value,case when product_weight_g<1000 then "light"
when product_weight_g between 1000 and 5000 then "medium" 
when product_weight_g>5000 then "heavy" end as weight_category
from product_sales_orders)
select weight_category,avg(freight_value) as avg_freight
from cte 
group by weight_category

-- Insight:
-- Freight cost increases significantly with product
-- weight. Heavy products incur an average freight cost
-- of approximately 39.81, compared to 20.15 for medium
-- products and 15.78 for light products. Heavy products
-- cost nearly 2.5 times more to ship than light products,
-- confirming that product weight is a major driver of
-- logistics expenses across the marketplace.
--
-- Result:
-- Product weight categories analyzed successfully and
-- a positive relationship between product weight and
-- freight cost was observed.

-- =====================================================
-- Q40. ORDERS WITH HIGHEST FREIGHT BURDEN
-- Objective:
-- Identify orders where shipping costs are highest
-- relative to product value and detect logistics
-- inefficiencies at the transaction level.
-- =====================================================

SELECT order_id,ROUND(SUM(freight_value)/SUM(price),2) AS freight_cost_ratio
FROM product_sales_orders
GROUP BY order_id
ORDER BY freight_cost_ratio DESC

-- Insight:
-- Certain orders exhibit exceptionally high freight-to-
-- product price ratios, indicating that shipping costs
-- significantly exceed the value of the products being
-- purchased. This situation is typically observed for
-- low-priced products, remote delivery locations, or
-- logistics-intensive orders. Such orders may negatively
-- impact customer purchase decisions and reduce overall
-- marketplace efficiency.
--
-- Result:
-- Orders with the highest freight burden were identified
-- successfully. Several orders incur freight costs that
-- are multiple times higher than the product value,
-- highlighting potential opportunities for shipping
-- optimization and pricing strategy improvements.

===========================================================================================================================================
 --TIME SERIES & OPERATIONAL PERFORMANCE ANALYSIS
===========================================================================================================================================

-- =====================================================
-- Q41. MONTHLY REVENUE TREND ANALYSIS
--
-- Objective:
-- Analyze monthly revenue growth and identify
-- seasonal patterns in marketplace sales.
-- =====================================================

select date_format(order_purchase_timestamp,"%Y-%m") as `month`,sum(payment_value) as total_revenue
from customer_order_payment
group by date_format(order_purchase_timestamp,"%Y-%m")
order by month

-- Insight:
-- Monthly revenue analysis reveals the growth trend
-- of the marketplace over time. Revenue increased
-- significantly after the initial months, indicating
-- expanding customer adoption and marketplace activity.
-- Monitoring monthly revenue trends helps identify
-- growth phases, seasonal demand fluctuations, and
-- business performance over time.
--
-- Result:
-- Monthly marketplace revenue trend analyzed
-- successfully.

-- =====================================================
-- Q42. MONTHLY ORDER VOLUME TREND ANALYSIS
--
-- Objective:
-- Analyze monthly order volume trends to identify
-- periods of high and low customer demand and
-- evaluate marketplace growth over time.
-- =====================================================

select date_format(order_purchase_timestamp,"%Y-%m") as `month`,count(distinct order_id) as total_orders
from customer_order_payment
group by date_format(order_purchase_timestamp,"%Y-%m")
order by `month`

-- Insight:
-- Monthly order volume analysis reveals the growth and
-- demand pattern of the marketplace over time. Order
-- volume increased significantly compared to the early
-- months of operation, indicating successful customer
-- acquisition and marketplace expansion. The highest
-- order volumes were observed during the mature stages
-- of the marketplace, demonstrating strong and stable
-- customer demand.
--
-- Result:
-- Monthly order volume trend analyzed successfully,
-- highlighting periods of marketplace growth and peak
-- customer activity.

-- =====================================================
-- Q43. AVERAGE DELIVERY TIME ANALYSIS
--
-- Objective:
-- Measure the average number of days required to
-- deliver customer orders and evaluate logistics
-- efficiency across the marketplace.
-- =====================================================

select round(avg(day_diff),2) as avg_delievery_days
from
(select datediff(order_delivered_customer_date,order_purchase_timestamp) as day_diff
from customer_order_payment)a


-- Insight:
-- The marketplace requires an average of 12.50 days
-- to deliver an order from purchase to final customer
-- delivery. This indicates a reasonably efficient
-- logistics network considering the geographical
-- coverage and diversity of products sold through the
-- marketplace. Delivery time is a critical operational
-- KPI that directly influences customer satisfaction
-- and repeat purchase behavior.
--
-- Result:
-- Average order delivery time across the marketplace
-- is approximately 12.50 days.

-- =====================================================
-- Q44. DELIVERY PERFORMANCE CLASSIFICATION
--
-- Objective:
-- Classify deliveries as On-Time or Late based on
-- the estimated delivery date and evaluate overall
-- logistics performance.
-- =====================================================

with cte as(select order_id,order_delivered_customer_date,order_estimated_delivery_date
from customer_order_payment),
cte_1 as(select *, datediff(order_estimated_delivery_date,order_delivered_customer_date) as day_diff from cte),
cte_2 as (select *,case when day_diff>0 then "GOOD DELIEVERY" 
WHEN day_diff<0 then "BAD DELIEVERY" else "NO RECORDS" end as delievery_rating from cte_1)
select delievery_rating,count(*) as total_such_delievery
from cte_2 
group by delievery_rating

-- Insight:
-- Delivery performance analysis shows that the
-- marketplace maintains a highly efficient logistics
-- network. Approximately 93.13% of delivered orders
-- reached customers on or before the estimated
-- delivery date, while only 6.87% experienced delays.
-- This indicates strong operational performance and
-- reliable delivery management across the marketplace.
--
-- Result:
-- 88,649 orders (93.13%) were delivered on time or
-- earlier than expected, while 6,534 orders (6.87%)
-- were delivered after the estimated delivery date.

-- =====================================================
-- Q45. DELIVERY PERFORMANCE VS CUSTOMER SATISFACTION
--
-- Objective:
-- Analyze the impact of delivery performance on
-- customer review scores.
-- =====================================================

with cte as (select order_id,order_delivered_customer_date,order_estimated_delivery_date,
datediff(order_estimated_delivery_date,order_delivered_customer_date) as day_diff,review_score
from review_order_customer
where order_delivered_customer_date is not null),
cte_1 as(select *,case when day_diff>0 then "GOOD DELIEVERY"
WHEN day_diff<0 then "BAD DELIEVERY" else "NO RECORDS" end as delievery_category
from cte)
select delievery_category,avg(review_score) as avg_review_score
from cte_1 
group by delievery_category


-- Insight:
-- Delivery performance has a significant impact on
-- customer satisfaction. Orders delivered before the
-- estimated delivery date received an average review
-- score of 4.29, while delayed deliveries received an
-- average review score of only 2.27. This demonstrates
-- a strong positive relationship between logistics
-- efficiency and customer experience. Customers are
-- substantially more satisfied when orders arrive on
-- time or earlier than expected.
--
-- Result:
-- Good deliveries achieved an average review score of
-- 4.29, whereas delayed deliveries achieved an average
-- review score of only 2.27, confirming that delivery
-- performance is a major driver of customer
-- satisfaction.

-- =====================================================
-- Q46. ORDER APPROVAL EFFICIENCY ANALYSIS
--
-- Objective:
-- Measure the average time required to approve
-- customer orders after purchase and evaluate
-- operational processing efficiency.
-- =====================================================
SELECT SEC_TO_TIME(AVG(TIME_TO_SEC(time_diff))) AS avg_confirm_time 
FROM (SELECT TIMEDIFF(order_approved_at, order_purchase_timestamp) AS time_diff
FROM customer_order_payment) a

-- Insight:
-- Order approval analysis indicates that the marketplace
-- approves customer orders in an average of 10 hours and
-- 22 minutes after purchase. This demonstrates a highly
-- responsive order processing system, ensuring that
-- orders move quickly into the fulfillment and delivery
-- stages. Fast approval times contribute to improved
-- operational efficiency and help reduce overall order
-- delivery lead times.
--
-- Result:
-- The average time required to approve a customer order
-- is approximately 10 hours and 22 minutes.

-- =====================================================
-- Q47. WEEKDAY VS WEEKEND PURCHASE ANALYSIS
--
-- Objective:
-- Compare customer purchasing behavior between
-- weekdays and weekends to identify shopping
-- patterns and peak purchasing periods.
-- =====================================================

select "weekend" as time,COUNT(DISTINCT ORDER_ID) as total_orders
from customer_order_payment
where dayofweek(order_purchase_timestamp) in (1,7)
union all
select "weekday" as time,COUNT(DISTINCT ORDER_ID) as total_orders
from customer_order_payment
where dayofweek(order_purchase_timestamp) between 2 and 6


-- Insight:
-- Customer purchasing activity is heavily concentrated
-- during weekdays. Approximately 77.03% of all orders
-- are placed on weekdays, while only 22.97% occur on
-- weekends. This indicates that customers primarily
-- engage with the marketplace during the working week,
-- resulting in significantly higher transaction volume
-- and business activity on weekdays.
--
-- Result:
-- Weekdays account for 76,593 orders (77.03%) whereas
-- weekends account for 22,847 orders (22.97%),
-- demonstrating substantially higher customer activity
-- during weekdays.

-- =====================================================
-- Q48. MONTHLY CUSTOMER ACQUISITION TREND
--
-- Objective:
-- Analyze the growth of unique customers over time
-- and evaluate marketplace expansion.
-- =====================================================

select date_format(order_purchase_timestamp,"%Y-%m") as month,count(distinct customer_unique_id) as no_of_customers
from customer_order_payment
group by date_format(order_purchase_timestamp,"%Y-%m")
order by month

-- Insight:
-- Monthly customer acquisition analysis reveals a
-- strong growth trajectory in the marketplace. The
-- number of unique customers increased significantly
-- over time, indicating successful customer acquisition
-- strategies and increasing marketplace adoption.
-- Growth in customer acquisition closely aligns with
-- the previously observed increases in order volume
-- and revenue, confirming overall marketplace
-- expansion.
--
-- Result:
-- The marketplace experienced continuous customer
-- growth over time, demonstrating increasing adoption
-- and successful expansion of its customer base.

-- =====================================================
-- Q49. MONTH-OVER-MONTH REVENUE GROWTH RATE ANALYSIS
--
-- Objective:
-- Measure monthly revenue growth rates and identify
-- periods of accelerated growth or decline in
-- marketplace performance.
-- =====================================================

with cte as(select date_format(order_purchase_timestamp,"%Y-%m") as month,sum(payment_value) as monthly_revenue
from customer_order_payment
group by date_format(order_purchase_timestamp,"%Y-%m")),
cte_1 as(select *,lag(monthly_revenue,1,0) over(order by month) as previous_month_revenue
from cte )
select *,COALESCE(round(((monthly_revenue-previous_month_revenue)/previous_month_revenue)*100,2),0) as percentage_change
from cte_1 
ORDER BY month

-- Insight:
-- Month-over-month revenue growth analysis reveals
-- significant fluctuations during the early stages of
-- the marketplace due to low transaction volumes.
-- As the platform matured, revenue experienced strong
-- positive growth driven by increasing customer
-- acquisition and order activity. Monitoring revenue
-- growth rates helps identify expansion periods,
-- market momentum, and business performance trends.
--
-- Result:
-- The marketplace demonstrated strong revenue growth
-- over time, reflecting successful customer adoption
-- and increasing commercial activity.

-- =====================================================
-- Q50. MONTHLY DELIVERY PERFORMANCE TREND
--
-- Objective:
-- Analyze how average delivery time changes over
-- time and evaluate improvements or deterioration
-- in logistics performance.
-- =====================================================

select date_format(order_purchase_timestamp,"%Y-%m") as month,
coalesce(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),"NO DATA") as delievery_days
from customer_order_payment
group by date_format(order_purchase_timestamp,"%Y-%m")
order by month

-- Insight:
-- Monthly delivery performance analysis tracks the
-- efficiency of the marketplace logistics network over
-- time. Average delivery duration fluctuated across
-- different periods, reflecting changes in order
-- volumes, logistics capacity, and operational
-- performance. Monitoring delivery trends helps
-- identify periods of operational improvement and
-- supports efforts to maintain high customer
-- satisfaction.
--
-- Result:
-- Average delivery time was successfully tracked on a
-- monthly basis, enabling evaluation of logistics
-- performance trends across the marketplace lifecycle.


===========================================================================================================================================
ADVANCED BUSINESS ANALYSIS
===========================================================================================================================================

-- =====================================================
-- Q51. PARETO ANALYSIS OF CUSTOMERS
-- Objective:
-- Determine what percentage of total revenue is
-- generated by the Top 20% customers.
-- =====================================================

with cte as(select customer_unique_id,sum(payment_value) as total_cust_revenue 
from customer_order_payment
group by customer_unique_id),
cte_1 as (select *,rank()over(order by total_cust_revenue desc) as rnk from cte),
cte_2 as(select *,row_number()over(order by rnk asc) as rn from cte_1),
cte_3 as(select* from cte_2
where rn<(select 0.20*count(*) from cte_1)),
cte_4 AS(select *,sum(total_cust_revenue)over(order by rnk asc) as rolling_sum
from cte_3),
cte_5 as(SELECT max(rolling_sum) as revenue from cte_4),
cte_6 as (select sum(payment_value) as total_revenue from customer_order_payment)
select (revenue*1.0/total_revenue)*100 from cte_5,cte_6

-- Insight:
-- The top 20% of customers contribute approximately
-- 53.77% of total marketplace revenue, indicating a
-- moderate level of revenue concentration. While a
-- relatively small group of customers generates a
-- significant share of revenue, the marketplace is not
-- excessively dependent on a limited customer base.
-- This suggests a healthy balance between customer
-- concentration and revenue diversification.
--
-- Result:
-- Top 20% customers contribute 53.77% of total
-- marketplace revenue.

-- =====================================================
-- Q52. PARETO ANALYSIS OF SELLERS
--
-- Objective:
-- Determine what percentage of marketplace revenue
-- is generated by the Top 20% sellers and evaluate
-- seller revenue concentration risk.
-- =====================================================

with cte as(select seller_id,sum(price) as total_seller_revenue 
from product_sales_orders
group by seller_id),
cte_1 as (select *,rank()over(order by total_seller_revenue desc) as rnk from cte),
cte_2 as(select *,row_number()over(order by rnk asc) as rn from cte_1),
cte_3 as(select* from cte_2
where rn<(select 0.20*count(*) from cte_1)),
cte_4 AS(select *,sum(total_seller_revenue)over(order by rnk asc) as rolling_sum
from cte_3),
cte_5 as(SELECT max(rolling_sum) as revenue from cte_4),
cte_6 as (select sum(price) as total_revenue from product_sales_orders)
select (revenue*1.0/total_revenue)*100 from cte_5,cte_6

-- Insight:
-- The top 20% of sellers contribute approximately
-- 82.66% of total marketplace revenue, indicating a
-- high level of seller revenue concentration. While
-- the customer base remains relatively diversified,
-- marketplace revenue is heavily dependent on a small
-- proportion of sellers. This concentration creates
-- potential business risk, as the loss of key sellers
-- could significantly impact overall revenue generation.
--
-- Result:
-- Top 20% sellers contribute 82.66% of total
-- marketplace revenue.

-- =====================================================
-- Q53. CUSTOMER LIFETIME VALUE ANALYSIS
--
-- Objective:
-- Identify the most valuable customers based on their
-- cumulative spending and evaluate customer revenue
-- concentration across the marketplace.
-- =====================================================

with cte as(select customer_unique_id,sum(payment_value) as total_revenue
from customer_order_payment
group by customer_unique_id),
cte_1 as(select*,case when total_revenue<1000 then "bronze"
when total_revenue between 1000 and 5000 then "silver"
when total_revenue>5000 then "gold" end as customer_segment
from cte),
cte_2 as(select customer_segment,count(*) as total_customer,sum(total_revenue) as total_revenue_generated
from cte_1 
group by customer_segment),
cte_3 as (select sum(payment_value) as total_revenue from customer_order_payment)
select customer_segment,total_customer,total_revenue_generated,
round((total_revenue_generated*1.0/total_revenue)*100,2) as percentage_contribution
from cte_2,cte_3

-- Insight:
-- Customers were segmented into Bronze, Silver, and
-- Gold tiers based on their lifetime spending. The
-- Bronze segment represents the overwhelming majority
-- of customers and contributes approximately 87.83%
-- of total marketplace revenue. Silver customers
-- contribute 11.77% of revenue, while only a very small
-- number of Gold customers exist within the marketplace,
-- contributing 0.40% of revenue. The results indicate
-- that customer spending is heavily concentrated within
-- lower-value customer segments, suggesting that the
-- current segmentation thresholds may require further
-- refinement for more balanced customer classification.
--
-- Result:
-- Customer Lifetime Value segmentation completed
-- successfully.

-- =====================================================
-- Q54. CUSTOMER REVENUE QUARTILE ANALYSIS
--
-- Objective:
-- Segment customers into revenue quartiles and
-- evaluate customer distribution and revenue
-- contribution across each quartile.
-- =====================================================

with cte as(select customer_unique_id,sum(payment_value) as total_cust_revenue
from customer_order_payment
group by customer_unique_id),
cte_1 as(select *,row_number()over(order by total_cust_revenue) as rn
from cte),
cte_2 as(select*,case when rn<=(select 0.25*count(*) from cte) then "quartile 1"
when rn<=(select 0.50*count(*) from cte) then "quartile 2"
when rn<=(select 0.75*count(*) from cte) then "quartile 3"
else "quartile 4" end as quartile_segment from cte_1)
select quartile_segment,round(sum(total_cust_revenue),2) as total_revenue_quartile
from cte_2
group by quartile_segment
order by quartile_segment

-- Insight:
-- Customer revenue distribution is highly skewed.
-- The highest-spending quartile contributes the
-- overwhelming majority of marketplace revenue,
-- while lower-spending quartiles contribute only a
-- small fraction. This indicates significant revenue
-- concentration among a relatively small group of
-- customers and highlights the importance of retaining
-- high-value customers.
--
-- Result:
-- Customer revenue quartile analysis completed
-- successfully.

-- =====================================================
-- Q55. CUSTOMER PURCHASE FREQUENCY VS REVENUE ANALYSIS
--
-- Objective:
-- Analyze the relationship between customer purchase
-- frequency and revenue generation to determine
-- whether frequent customers contribute significantly
-- more revenue than occasional buyers.
-- =====================================================
with cte as(select customer_segment,sum(total_revenue_generated) as total_revenue_generated from
(select "one_time_customer" as customer_segment,sum(payment_value) as total_revenue_generated
from customer_order_payment
group by customer_unique_id
having count(*)=1)a
group by customer_segment
union all 
select customer_segment,sum(total_revenue_generated) as total_revenue_generated
from
(select case when total_orders<5 then "less frequent customer"
when total_orders>=5 then "more frequent_customers" end as customer_segment,total_revenue_generated
from
(select customer_unique_id,count(*) as total_orders, sum(payment_value) as total_revenue_generated
from customer_order_payment
group by customer_unique_id
having count(*)>1)a)b
group by customer_segment),
cte_1 as (select sum(payment_value) as total_revenue from customer_order_payment)
select *,(total_revenue_generated*1.0/total_revenue)*100 AS percentage_contribution
from cte,cte_1

-- Insight:
-- Revenue is overwhelmingly generated by one-time
-- customers, who contribute approximately 94.10% of
-- total marketplace revenue. Less-frequent customers
-- contribute 5.80%, while highly frequent customers
-- account for a negligible share of revenue. This
-- suggests that the marketplace relies primarily on
-- customer acquisition rather than repeat purchasing
-- behavior. The result may also indicate that the
-- frequency thresholds used for segmentation are highly
-- restrictive and should be reviewed.


--
-- Result:
-- Revenue contribution by customer frequency segment
-- analyzed successfully.

-- =====================================================
-- Q56. CATEGORY DEPENDENCY RISK ANALYSIS
--
-- Objective:
-- Determine how dependent marketplace revenue is on
-- the highest-performing product categories and assess
-- category concentration risk.(TOP 5)
-- =====================================================

with cte as(select product_category,sum(price) as total_revenue_generated
from product_sales_orders
group by product_category),
cte_1 as(select sum(price) as total_revenue from product_sales_orders),
cte_2 as(select *,round(((total_revenue_generated)*1.0/total_revenue)*100,2) as percentage_contribution
from cte,cte_1
order by percentage_contribution DESC
LIMIT 5)
select sum(percentage_contribution) as total_contribution from cte_2

-- Insight:
-- The top 5 product categories contribute 39.74% of
-- total marketplace revenue. This indicates a moderate
-- level of category concentration, where a limited set
-- of categories drives a significant share of revenue
-- while the remaining revenue is distributed across a
-- broad range of product categories. The marketplace
-- is not overly dependent on a single category,
-- reducing category concentration risk.
--
-- Result:
-- Top 5 product categories contribute 39.74% of total
-- marketplace revenue.

-- =====================================================
-- Q57. SELLER QUALITY MATRIX ANALYSIS
--
-- Objective:
-- Classify sellers based on revenue generation and
-- customer satisfaction to identify strategic,
-- emerging, risky, and underperforming sellers.
-- =====================================================

with cte as(select p.seller_id,sum(p.price) as total_revenue,avg(review_score) as avg_review
from product_sales_orders p inner join review_order_customer r on p.order_id=r.order_id
group by p.seller_id),
cte_1 as(select round(sum(price)*1.0/count(distinct seller_id),2) as avg_revenue from product_sales_orders),
cte_2 as(select avg(review_score) as avg_review_score from review_order_customer),
cte_3 as(select * from cte_1,cte_2),
cte_4 as (select * from cte,cte_3),
cte_5 as(select *,case when total_revenue>avg_revenue and avg_review>avg_review_score then "strategic seller"
when total_revenue<avg_revenue and avg_review>avg_review_score then "emerging seller"
when total_revenue>avg_revenue and avg_review<avg_review_score then "risky seller"
else "underperforming" end as seller_segment
from cte_4)
select seller_segment,count(*) as no_of_seller,sum(total_revenue) as total_revenue_category
from cte_5
group by seller_segment

-- Insight:
-- Seller performance was evaluated using both revenue
-- generation and customer satisfaction metrics. Strategic
-- sellers (high revenue and high reviews) generated the
-- highest revenue contribution of approximately 5.67M.
-- However, risky sellers (high revenue but below-average
-- reviews) generated a nearly equal revenue contribution
-- of 5.47M, highlighting a potential customer experience
-- risk for the marketplace. Emerging sellers maintain
-- strong customer satisfaction but contribute relatively
-- low revenue, representing future growth opportunities.
-- Underperforming sellers contribute the least revenue
-- while also receiving below-average customer ratings.
--
-- Result:
-- Seller quality matrix successfully identified strategic,
-- risky, emerging, and underperforming seller segments.

-- =====================================================
-- Q58. PRODUCT CATEGORY EFFICIENCY ANALYSIS
--
-- Objective:
-- Identify product categories that maximize revenue
-- while minimizing freight costs and maintaining
-- strong customer satisfaction.
-- =====================================================

with cte as(select p.product_category,p.price,p.freight_value,r.review_score
from product_sales_orders p inner join review_order_customer r on p.order_id=r.order_id),
cte_1 as (select product_category,sum(price) as total_category_revenue,sum(freight_value) as total_freight_value,
avg(review_score) as avg_category_review
from cte 
group by product_category),
cte_2 as(select sum(price)/count(distinct product_category) as avg_category_revenue,
sum(freight_value)/count(distinct product_category) as avg_freight_value from product_sales_orders),
cte_3 as(select avg(review_score) as avg_review from review_order_customer),
cte_4 as ( select * from cte_2,cte_3),
cte_5 as(select * from cte_1,cte_4),
cte_6 as (select *,case when total_category_revenue>avg_category_revenue and total_freight_value<avg_freight_value
and avg_category_review>avg_review then "star category" 
when total_category_revenue>avg_category_revenue and total_freight_value<avg_freight_value
and avg_category_review<avg_review then "premium category"
when total_category_revenue<avg_category_revenue and total_freight_value>avg_freight_value
and avg_category_review>avg_review then "inefficient category"
else "underperforming category" end as category_distribution
from cte_5)
select category_distribution,count(*) as no_of_category
from cte_6
group by category_distribution 

-- Insight:
-- Product categories were classified based on revenue,
-- freight cost, and customer satisfaction. Only 2
-- categories qualified as Star Categories, generating
-- above-average revenue while maintaining below-average
-- freight costs and above-average customer reviews.
-- The majority of categories (69 out of 72) were
-- classified as Underperforming, indicating that most
-- categories fail to simultaneously achieve strong
-- revenue performance, logistics efficiency, and
-- customer satisfaction.
--
-- Result:
-- 2 Star Categories, 1 Inefficient Category, and
-- 69 Underperforming Categories were identified.

-- =====================================================
-- Q59. MARKETPLACE REVENUE LEAKAGE ANALYSIS
--
-- Objective:
-- Identify product categories where freight costs
-- consume a significant portion of revenue and
-- evaluate potential profitability risks.
-- =====================================================

with cte as(select product_category,sum(price) as total_category_revenue,sum(freight_value) as total_freight_cost,
round((sum(freight_value)/sum(price+freight_value))*100,2) as freight_revenue_percent
from product_sales_orders
group by product_category),
cte_1 as(select *,CASE WHEN freight_revenue_percent < 15 THEN 'Highly Efficient'
WHEN freight_revenue_percent BETWEEN 15 AND 25 THEN 'Moderately Efficient'
ELSE 'Revenue Leakage Risk' END as category_distribution from cte)
select category_distribution,count(*) as total_categories
from cte_1 
group by category_distribution

-- Insight:
-- Product categories were classified according to the
-- percentage of customer spending allocated to freight
-- costs. Out of 72 categories, 32 were identified as
-- Highly Efficient, 35 as Moderately Efficient, and
-- only 5 as Revenue Leakage Risk categories. This
-- indicates that the marketplace maintains generally
-- healthy logistics efficiency, with only a small
-- subset of categories exhibiting excessive freight
-- burdens that may negatively impact profitability.
--
-- Result:
-- 32 Highly Efficient Categories
-- 35 Moderately Efficient Categories
-- 5 Revenue Leakage Risk Categories

-- =====================================================
-- Q60. MARKETPLACE EXECUTIVE PERFORMANCE SUMMARY
--
-- Objective:
-- Generate a consolidated business health report
-- containing customer, seller, product, logistics,
-- and revenue KPIs for executive decision-making.
-- =====================================================

WITH cte_customers AS(SELECT COUNT(DISTINCT customer_unique_id) AS no_of_customers
FROM customer_order_payment),
cte_orders AS(SELECT COUNT(DISTINCT order_id) AS no_of_orders
FROM customer_order_payment),
cte_categories AS(SELECT COUNT(DISTINCT product_category) AS no_of_categories
FROM product_sales_orders),
cte_sellers AS(SELECT COUNT(DISTINCT seller_id) AS no_of_sellers
FROM product_sales_orders),
cte_revenue AS(SELECT ROUND(SUM(payment_value),2) AS total_revenue
FROM customer_order_payment),
cte_freight AS(SELECT ROUND(SUM(freight_value),2) AS total_freight_cost
FROM product_sales_orders),
cte_reviews AS(SELECT ROUND(AVG(review_score),2) AS avg_review_score
FROM review_order_customer),
cte_aov AS(SELECT ROUND(SUM(payment_value)/COUNT(DISTINCT order_id),2) AS average_order_value
FROM customer_order_payment),
cte_repeat_customers AS(SELECT ROUND((COUNT(*)*100.0)/(SELECT COUNT(DISTINCT customer_unique_id)
FROM customer_order_payment),2)AS repeat_customer_percent
FROM(SELECT customer_unique_id
FROM customer_order_payment
GROUP BY customer_unique_id
HAVING COUNT(DISTINCT order_id) > 1) a)
SELECT *
FROM cte_customers,
     cte_orders,
     cte_categories,
     cte_sellers,
     cte_revenue,
     cte_freight,
     cte_reviews,
     cte_aov,
     cte_repeat_customers;
    
-- Insight:
-- The marketplace serves a large customer base with
-- strong order activity across multiple product
-- categories and sellers. Total revenue generation
-- remains substantial while maintaining a healthy
-- average customer review score above 4.0. Freight
-- costs represent a manageable portion of marketplace
-- transactions, indicating operational efficiency.
-- Average Order Value (AOV) provides insight into
-- customer spending behavior, while the repeat
-- customer percentage highlights customer retention
-- performance and long-term marketplace sustainability.
--
-- Result:
-- Executive KPI dashboard successfully summarizes
-- marketplace scale, customer behavior, revenue
-- performance, logistics efficiency, seller network
-- size, customer satisfaction, and retention metrics.

===========================================================================================================================================
------------------------------------------------SUMMARY TABLE CREATION---------------------------------------------------------------------
===========================================================================================================================================

-- =====================================================
-- CUSTOMER SUMMARY TABLE
--
-- Objective:
-- Create a customer-level analytical table
-- containing customer purchase behavior,
-- revenue contribution, satisfaction level,
-- and customer segmentation.
-- =====================================================

CREATE TABLE CUSTOMER_SUMMARY AS (
with cte as(select c.customer_unique_id,count(DISTINCT c.order_id) as NO_OF_ORDERS,sum(c.payment_value) as TOTAL_REVENUE_GENERATED,
sum(c.payment_value)/count(distinct c.order_id) as AVG_ORDER_VALUE,avg(r.review_score) as AVERAGE_REVIEW_SCORE
from customer_order_payment c inner join review_order_customer r on c.order_id=r.order_id
group by c.customer_unique_id)
select *,case when NO_OF_ORDERS>=5 THEN "FREQUENT CUSTOMER"
when NO_OF_ORDERS BETWEEN 2 AND 4 THEN "LESS FREQUENT CUSTOMER"
when NO_OF_ORDERS=1 THEN "ONE TIME CUSTOMER" END AS CUSTOMER_SEGMENT
from cte )


-- =====================================================
-- SELLER SUMMARY TABLE
--
-- Objective:
-- Create a seller-level analytical table containing
-- revenue performance, order volume, customer
-- satisfaction, and seller segmentation.
-- =====================================================
-- =====================================================
-- SELLER SUMMARY TABLE
--
-- Objective:
-- Create a seller-level analytical table containing
-- revenue performance, order volume, customer
-- satisfaction, and seller segmentation.
-- =====================================================

CREATE TABLE seller_summary AS
WITH cte AS(SELECT p.seller_id,
COUNT(DISTINCT p.order_id) AS no_of_orders,
SUM(p.price) AS total_revenue_generated,
SUM(p.price)/COUNT(DISTINCT p.order_id) AS avg_order_value,
AVG(r.review_score) AS avg_review_score
FROM product_sales_orders p INNER JOIN review_order_customer r ON p.order_id=r.order_id
GROUP BY p.seller_id),
cte_1 AS(SELECT AVG(total_revenue_generated) AS avg_seller_revenue,AVG(avg_review_score) AS avg_seller_review
FROM cte)
SELECT c.*,CASE WHEN total_revenue_generated > avg_seller_revenue AND avg_review_score > avg_seller_review THEN 'STRATEGIC SELLER'
WHEN total_revenue_generated > avg_seller_revenue AND avg_review_score < avg_seller_review THEN 'RISKY SELLER'
WHEN total_revenue_generated < avg_seller_revenue AND avg_review_score > avg_seller_review THEN 'EMERGING SELLER'
ELSE 'UNDERPERFORMING SELLER' END AS seller_segment
FROM cte c CROSS JOIN cte_1;

-- Insight:
-- The seller summary table provides a consolidated
-- view of seller performance by combining revenue,
-- order volume, and customer satisfaction metrics.
-- Sellers are segmented into Strategic, Emerging,
-- Risky, and Underperforming categories based on
-- their relative revenue generation and review
-- performance. This segmentation enables the
-- marketplace to identify top-performing sellers,
-- monitor potential risks, and develop targeted
-- seller growth strategies.
--
-- Result:
-- Seller-level performance metrics and seller
-- segmentation were successfully consolidated into
-- a single analytical summary table.

-- =====================================================
-- CATEGORY SUMMARY TABLE
--
-- Objective:
-- Create a product category-level analytical table
-- containing sales performance, logistics costs,
-- customer satisfaction, and category segmentation
-- metrics for marketplace analysis.
-- =====================================================
CREATE TABLE CATEGORY_SUMMARY AS (
with cte as(select p.product_category,count(distinct p.order_id) as NO_OF_ORDERS,sum(p.price) as TOTAL_REVENUE_GENERATED,
sum(p.freight_value) as TOTAL_FREIGHT_COST,sum(p.price)/count(distinct p.order_id) AS AVG_ORDER_VALUE,
AVG(r.review_score) as AVG_REVIEW_SCORE 
from product_sales_orders p inner join review_order_customer r on p.order_id=r.order_id
group by p.product_category),
cte_1 as( select sum(TOTAL_REVENUE_GENERATED)/COUNT(DISTINCT product_category) AVG_CATEGORY_REVENUE from cte ),
cte_2 as( select  avg(AVG_REVIEW_SCORE) AS AVG_CATEGORY_REVIEW from cte),
cte_3 as (select * from cte_1,cte_2),
cte_4 as(select * from cte,cte_3)
select *,case when TOTAL_REVENUE_GENERATED>AVG_CATEGORY_REVENUE AND AVG_REVIEW_SCORE>AVG_CATEGORY_REVIEW THEN "STAR"
when TOTAL_REVENUE_GENERATED<AVG_CATEGORY_REVENUE AND AVG_REVIEW_SCORE>AVG_CATEGORY_REVIEW THEN "PREMIUM"
when TOTAL_REVENUE_GENERATED>AVG_CATEGORY_REVENUE AND AVG_REVIEW_SCORE<AVG_CATEGORY_REVIEW THEN "RISKY"
ELSE "UNDERPERFORMING" END AS CATEGORY_SEGMENT
FROM cte_4)


-- Insight:
-- The category summary table consolidates category-
-- level sales, logistics, and customer satisfaction
-- metrics into a single analytical view. Categories
-- are segmented into Star, Premium, Risky, and
-- Underperforming groups based on their relative
-- revenue contribution and review performance.
--
-- Result:
-- Category-level performance metrics and category
-- segmentation were successfully consolidated into
-- a unified analytical summary table.

-- =====================================================
-- MONTHLY BUSINESS SUMMARY TABLE
--
-- Objective:
-- Create a month-level analytical table containing
-- customer growth, order activity, revenue trends,
-- delivery performance, and customer satisfaction.
-- =====================================================


CREATE TABLE MONTHLY_SUMMARY (
select date_format(c.order_purchase_timestamp,"%Y-%m") as month_number,count(distinct c.customer_unique_id) as no_of_customer,
count(distinct c.order_id) as no_of_orders,sum(payment_value) as total_revenue_generated,
sum(c.payment_value)/count(distinct c.order_id) as avg_order_value,
round(avg(datediff(c.order_delivered_customer_date,c.order_purchase_timestamp)),2) as avg_delievery_days,
round(avg(r.review_score),2) as avg_review_score
from customer_order_payment c left join review_order_customer r on c.order_id=r.order_id
group by date_format(c.order_purchase_timestamp,"%Y-%m")
order by month_number )

-- Insight:
-- The monthly summary table consolidates customer
-- acquisition, order activity, revenue generation,
-- delivery performance, and customer satisfaction
-- metrics into a single time-series analytical view.
-- This table enables trend analysis, growth tracking,
-- seasonality detection, and performance monitoring
-- across the marketplace lifecycle.
--
-- Result:
-- Monthly marketplace performance metrics were
-- successfully consolidated into a unified time-series
-- summary table.

-- =====================================================
-- LOGISTICS SUMMARY TABLE
--
-- Objective:
-- Create a logistics-focused analytical table
-- containing freight cost, delivery performance,
-- delivery reliability, and customer satisfaction
-- metrics across product categories to evaluate
-- operational efficiency and logistics effectiveness.
-- =====================================================
CREATE TABLE LOGISTICS_SUMMARY AS (
with cte as (select p.product_category,count(distinct p.order_id) as no_of_orders,
sum(p.freight_value) as total_freight_cost,avg(p.freight_value) as avg_freight_cost,
avg(datediff(p.order_delivered_customer_date,p.order_purchase_timestamp)) as avg_delievery_days,
avg(r.review_score) as avg_review_score
from product_sales_orders p inner join review_order_customer r on p.order_id=r.order_id
group by p.product_category),
cte_1 as(select product_category,
round((sum(case when order_delivered_customer_date<order_estimated_delivery_date then 1 else 0 end)/count(*))*100,2) as on_time_percentage,
round((sum(case when order_delivered_customer_date>order_estimated_delivery_date then 1 else 0 end)/count(*))*100,2) as late_time_percentage
from product_sales_orders
group by product_category)
select c.product_category,c.no_of_orders,c.total_freight_cost,c.avg_freight_cost,c.avg_delievery_days,
c.avg_review_score,c1.on_time_percentage,c1.late_time_percentage
from cte c inner join cte_1 c1 on c.product_category=c1.product_category)


-- Insight:
-- The logistics summary table evaluates operational
-- efficiency across product categories by combining
-- freight costs, delivery performance, delivery
-- reliability, and customer satisfaction metrics.
-- Categories with high on-time delivery percentages
-- and low freight costs demonstrate efficient supply
-- chain operations, while categories with higher
-- late-delivery percentages indicate potential
-- logistics bottlenecks that may impact customer
-- experience and profitability.
--
-- Result:
-- Product categories were successfully analyzed
-- based on freight expenditure, average delivery
-- time, customer review scores, and delivery
-- reliability metrics (on-time vs late deliveries),
-- providing a comprehensive view of marketplace
-- logistics performance.

-- =====================================================
-- MARKETPLACE KPI TABLE
--
-- Objective:
-- Create an executive-level KPI table containing
-- key marketplace performance indicators for
-- strategic decision making and dashboard reporting.
-- =====================================================
CREATE TABLE MARKET_KPI AS (
with cte as(select count(distinct customer_unique_id) as TOTAL_CUSTOMERS,
count(distinct order_id) AS TOTAL_ORDERS, 
avg(payment_value) as AVG_ORDER_VALUE
from customer_order_payment),

cte_1 as
(select count(distinct seller_id) as TOTAL_SELLERS,
count(distinct product_category) as TOTAL_CATEGORY,
sum(price) as PRODUCT_REVENUE,
sum(freight_value) as FREIGHT_COST,
sum(price+freight_value) as TOTAL_REVENUE
from product_sales_orders),

cte_2 as (select avg(review_score) as AVG_REVIEW_SCORE from review_order_customer),

cte_3 as 
(select round((repeat_customer/(select count(distinct customer_unique_id) from customer_order_payment))*100,2)
 as repeat_customer_percentage from
(select count(*) as repeat_customer from
(select customer_unique_id
from customer_order_payment
group by customer_unique_id
having count(*)>1)a)b),

cte_4 as 
(select avg(datediff(order_delivered_customer_date,order_purchase_timestamp)) as avg_delievery_days,
round((sum(case when order_delivered_customer_date<order_estimated_delivery_date then 1 else 0 end)/count(order_id))*100,2)
as ON_TIME_DELIEVERY_PERCENT,
round((sum(case when order_delivered_customer_date>order_estimated_delivery_date then 1 else 0 end)/count(order_id))*100,2)
as LATE_DELIEVERY_PERCENT
from customer_order_payment),

cte_5 as (select customer_unique_id,sum(payment_value) as total_revenue
from customer_order_payment
group by customer_unique_id),

cte_6 as ( select *,row_number()over(order by total_revenue desc) as rn
from cte_5),

cte_7 as (select sum(total_revenue) as revenue_by_top20_customer
from cte_6 
where rn<=(select 0.20*count(distinct customer_unique_id) from customer_order_payment)),

cte_8 as (select seller_id,sum(price) as total_revenue
from product_sales_orders
group by seller_id),

cte_9 as ( select *,row_number()over(order by total_revenue desc) as rn
from cte_8),

cte_10 as (select sum(total_revenue) as revenue_by_top20_seller
from cte_9 
where rn<=(select 0.20*count(distinct seller_id) from product_sales_orders))


select * from cte,cte_1,cte_2,cte_3,cte_4,cte_7,cte_10)

-- Insight:
-- The Marketplace KPI table provides a consolidated
-- executive-level view of overall marketplace
-- performance. It combines customer activity,
-- revenue generation, seller participation,
-- product portfolio size, logistics efficiency,
-- customer satisfaction, and revenue concentration
-- metrics into a single dashboard-ready dataset.
--
-- The marketplace demonstrates strong operational
-- performance with a high on-time delivery rate
-- (89.15%) and an average delivery time of
-- approximately 12.5 days. Customer satisfaction
-- remains healthy as reflected by the average
-- review score, while repeat customer metrics
-- indicate the platform's ability to retain buyers.
--
-- Pareto analysis reveals that a relatively small
-- group of customers and sellers contributes a
-- significant share of total revenue, highlighting
-- the importance of retaining high-value customers
-- and strategic sellers for sustained business
-- growth.
--
-- Result:
-- Executive KPIs including marketplace scale,
-- revenue performance, customer behavior,
-- logistics efficiency, customer satisfaction,
-- and revenue concentration were successfully
-- consolidated into a single KPI table for
-- strategic decision-making and dashboard reporting.












