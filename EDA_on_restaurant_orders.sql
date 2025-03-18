select * from menu_items;
select * from order_details;

-- Objective 1  : Explore the items table
-- a) How many items in the menu

select count(*) from menu_items;  -- 32

-- b) what are the least and most expensive item in the menu

select item_name ,price 
from menu_items 
where price in ((select min(price) from menu_items) ,(select max(price) from menu_items));
-- Edamame(least expensive - 5.00) ,Shrimp Scampi(most expensive - 19.95)

-- c) how many italian dishes in the menu ? what are the most and least expensive italian dishes in the menu

with italian_items as (
	select item_name ,price 
	from menu_items 
	where category = "italian"
)
select * from italian_items 
where price in ((select min(price) from italian_items) ,(select max(price) from italian_items));
-- Spaghetti -14.50 ,   Fettuccine Alfredo -14.50 ,   Shrimp Scampi -19.95

-- d)how many dishes in each category and what is the avg dish price in each category

select category , count(*) as dish_cnt, round(avg(price) ,4) as avg_price
from menu_items 
group by category ;


-- Objectove 2 : Explore the orders table 

-- a)what is the date range of the table
select min(order_date) ,max(order_date) from order_details;  -- Jan 1,2023 to Mar 31,2023

-- b)how many orders were made and how many items were ordered 
select count(distinct order_id) as order_cnt from order_details;

select count(*) from order_details;

-- c) which order has most number of items 
select order_id ,count(item_id) 
from order_details 
group by order_id 
order by count(*) desc ;

-- d)how many orders had more than 12 items 
select count(*) from (
	select order_id ,count(item_id) as cnt
	from order_details 
	group by order_id 
	having cnt>12
) sub ; -- 20


-- Objective 3 : Analyze customer behavior 
 
 select count(*) from order_details o left join menu_items m on m.menu_item_id = o.item_id;
 
-- a)what are the least and most ordered items ? what category were they in ?
with cte as(
select item_id ,item_name ,category ,count(*) as cnt 
from joined_table 
group by item_id 
order by cnt desc
)
select * from cte 
where cnt in ((select min(cnt) from cte ),(select max(cnt) from cte)) ;

-- b)what were the top 5 orders that spent most money
select order_id ,sum(price) as total_bill 
from joined_table 
group by order_id 
order by total_bill desc limit 5;

-- c)view the details of the highest spend order .what insights can you gather from the results
select order_id ,item_id , item_name ,category , price from joined_table where order_id = 440
order by category ,price desc;

select category , count(item_id) as cnt , sum(price) as bill_amt from joined_table where order_id = 440
group by category order by cnt desc, bill_amt desc;

-- d) consider top 5 spending orders and gather insights from the results
select order_id,category , count(item_id) as cnt , sum(price) as bill_amt from joined_table 
where order_id in ('440','2075' ,'1957','330','2675')
group by order_id, category order by order_id, cnt desc, bill_amt desc;

-- "insights we can get is the top spenders willing to choose italian items from the menu"