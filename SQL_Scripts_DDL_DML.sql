#DDL Statements

CREATE TABLE `address` (
  `address_id` varchar(6) NOT NULL,
  `building_no` int DEFAULT NULL,
  `street_name` text,
  `floor` int DEFAULT NULL,
  `city` text,
  `zipcode` int DEFAULT NULL,
  PRIMARY KEY (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `delivery_agent` (
  `delivery_agent_id` varchar(25) NOT NULL,
  `delivery_agent_name` text,
  `dob` date DEFAULT NULL,
  `phone_no` text,
  `address_id` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`delivery_agent_id`),
  KEY `del_agent_add_ref_idx` (`address_id`),
  CONSTRAINT `del_agent_add_ref` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `discount` (
  `discount_id` varchar(25) NOT NULL DEFAULT 'not applicable',
  `discount_name` text,
  `discount_percent` int DEFAULT NULL,
  `subscription_fee` int DEFAULT NULL,
  PRIMARY KEY (`discount_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `free_account` (
  `user_account_id` varchar(8) NOT NULL,
  PRIMARY KEY (`user_account_id`),
  UNIQUE KEY `user_account_id_UNIQUE` (`user_account_id`),
  CONSTRAINT `user_account_id` FOREIGN KEY (`user_account_id`) REFERENCES `user_account` (`user_account_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `gold_account` (
  `user_account_id` varchar(8) NOT NULL,
  `start_date` date DEFAULT NULL,
  `renewal_date` date DEFAULT NULL,
  `discount_id` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`user_account_id`),
  UNIQUE KEY `user_account_id_UNIQUE` (`user_account_id`),
  KEY `discount_id_gold_idx` (`discount_id`),
  CONSTRAINT `discount_id_gold` FOREIGN KEY (`discount_id`) REFERENCES `discount` (`discount_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_account_id_gold` FOREIGN KEY (`user_account_id`) REFERENCES `user_account` (`user_account_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `menu` (
  `menu_id` varchar(25) NOT NULL,
  `restaurant_id` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`menu_id`),
  KEY `menu_rest_idx` (`restaurant_id`),
  CONSTRAINT `menu_rest` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`restaurant_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `menu_item` (
  `menu_id` varchar(25) NOT NULL,
  `item_id` varchar(25) NOT NULL,
  `item_name` text,
  `calorie_count` int DEFAULT NULL,
  `item_type` text,
  `price` double DEFAULT NULL,
  PRIMARY KEY (`menu_id`,`item_id`),
  CONSTRAINT `menu_menu_item_ref` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`menu_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `menu_item_category` (
  `menu_id` varchar(25) NOT NULL,
  `menu_item_id` varchar(25) NOT NULL,
  `item_category` varchar(25) NOT NULL,
  PRIMARY KEY (`menu_id`,`menu_item_id`,`item_category`),
  KEY `mcat_ref2_idx` (`menu_item_id`),
  KEY `m1_idx` (`menu_id`),
  CONSTRAINT `menu_for` FOREIGN KEY (`menu_id`, `menu_item_id`) REFERENCES `menu_item` (`menu_id`, `item_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `order_details` (
  `order_id` varchar(25) NOT NULL,
  `menu_id` varchar(25) NOT NULL,
  `item_id` varchar(25) NOT NULL,
  `user_account_id` varchar(8) NOT NULL,
  `quantity` int DEFAULT NULL,
  `cost` int DEFAULT NULL,
  PRIMARY KEY (`order_id`,`menu_id`,`item_id`,`user_account_id`),
  KEY `men_reff_idx` (`menu_id`),
  KEY `mi_reference_idx` (`menu_id`,`item_id`),
  KEY `user_ref_idx` (`user_account_id`),
  CONSTRAINT `men_reff` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`menu_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `mi_reference` FOREIGN KEY (`menu_id`, `item_id`) REFERENCES `menu_item` (`menu_id`, `item_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ord_ref` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_ref` FOREIGN KEY (`user_account_id`) REFERENCES `user_account` (`user_account_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `orders` (
  `order_id` varchar(25) NOT NULL,
  `order_timestamp` text,
  `delivery_agent_id` varchar(25) DEFAULT NULL,
  `restaurant_id` varchar(25) DEFAULT NULL,
  `discount_id` varchar(25) DEFAULT 'not applicable',
  PRIMARY KEY (`order_id`),
  KEY `dis_ref_idx` (`discount_id`),
  KEY `deli_reff_idx` (`delivery_agent_id`),
  KEY `resta_ref_idx` (`restaurant_id`),
  CONSTRAINT `deli_reff` FOREIGN KEY (`delivery_agent_id`) REFERENCES `delivery_agent` (`delivery_agent_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `disc_refe` FOREIGN KEY (`discount_id`) REFERENCES `discount` (`discount_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `resta_ref` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`restaurant_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `payment` (
  `payment_id` varchar(25) NOT NULL,
  `payment_method` text,
  `payment_timestamp` text,
  `order_id` varchar(25) DEFAULT NULL,
  `user_account_id` varchar(8) DEFAULT NULL,
  `amount_paid` double DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `ua_id_idx` (`user_account_id`),
  KEY `o_id_idx` (`order_id`),
  CONSTRAINT `o_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ua_id` FOREIGN KEY (`user_account_id`) REFERENCES `user_account` (`user_account_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `user_account` (
  `user_account_id` varchar(8) NOT NULL,
  `name` text,
  `dob` text,
  `email` text,
  `phone_no` text,
  `age` int DEFAULT NULL,
  `address_id` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`user_account_id`),
  UNIQUE KEY `user_account_id_UNIQUE` (`user_account_id`),
  KEY `user_acc_ref_add_idx` (`address_id`),
  CONSTRAINT `user_acc_ref_add` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `restaurant` (
  `restaurant_id` varchar(25) NOT NULL,
  `restaurant_name` text,
  `address_id` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`restaurant_id`),
  KEY `rest_add_ref_idx` (`address_id`),
  CONSTRAINT `rest_add_ref` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `user_account_food_preference` (
  `user_account_id` varchar(8) NOT NULL,
  `food_preference_type` varchar(25) NOT NULL,
  PRIMARY KEY (`user_account_id`,`food_preference_type`),
  CONSTRAINT `user_acc_id` FOREIGN KEY (`user_account_id`) REFERENCES `user_account` (`user_account_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#DML Analytical Queries
# 1.> First, let us take a look at the order count split between the free and the gold users 
WITH non_disc AS
(SELECT o.order_id, ua.user_account_id, o.discount_id
FROM orders o, order_details od, user_account ua
WHERE o.order_id = od.order_id AND od.user_account_id = ua.user_account_id AND o.discount_id = 'not applicable'),

count_non_disc AS
(SELECT COUNT(DISTINCT non_disc.order_id) count_of_non_discounted_orders FROM non_disc),

count_disc AS
(SELECT COUNT(DISTINCT od.order_id) - count_non_disc.count_of_non_discounted_orders count_of_discounted_orders FROM order_details od, count_non_disc)

SELECT count_non_disc.count_of_non_discounted_orders count_of_free_user_orders, count_disc.count_of_discounted_orders count_of_gold_user_order
FROM count_non_disc, count_disc
WHERE count_non_disc.count_of_non_discounted_orders IS NOT NULL;

/* From the output, it seems that the number of orders made by the free users are higher than the gold users. To better understand this split, 
we need to further look into the number of orders made by each group of users and the average order per customer of the two groups. */

# 2.> Now, let us find the average no of orders per gold customer and free account customer.
WITH non_disc AS
(SELECT o.order_id, ua.user_account_id, o.discount_id
FROM orders o, order_details od, user_account ua
WHERE o.order_id = od.order_id AND od.user_account_id = ua.user_account_id AND o.discount_id = 'not applicable'),

count_non_disc AS
(SELECT COUNT(DISTINCT non_disc.order_id) count_of_non_discounted_orders FROM non_disc),

count_disc AS
(SELECT COUNT(DISTINCT od.order_id) - count_non_disc.count_of_non_discounted_orders count_of_discounted_orders FROM order_details od, count_non_disc),

order_count AS
(SELECT count_non_disc.count_of_non_discounted_orders, count_disc.count_of_discounted_orders
FROM count_non_disc, count_disc
WHERE count_non_disc.count_of_non_discounted_orders IS NOT NULL)

SELECT ROUND((oc.count_of_non_discounted_orders/(SELECT COUNT(*) FROM free_account)), 2) avg_order_per_free_user, 
		ROUND((oc.count_of_discounted_orders/(SELECT COUNT(*) FROM gold_account)), 2) avg_order_per_gold_user
FROM order_count oc;

/* It is clear that the gold users order more often than the regular free user, this could be attributed to the fact that the gold user 
enjoys the discount associated with the gold account benifits. */

# 3.> Now, let us also see the most popular gold subscription, and the average order per respective gold subscription plan of that customer 
WITH gold_non_gold_order_count AS
(SELECT o.discount_id, COUNT(o.discount_id) no_of_orders
FROM orders o
GROUP BY o.discount_id), 

gold_user_dist AS 
(SELECT ga.discount_id, COUNT(DISTINCT ga.user_account_id) no_of_users
FROM gold_account ga
GROUP BY ga.discount_id)

SELECT gud.discount_id, gud.no_of_users, gc.no_of_orders, (gc.no_of_orders/gud.no_of_users) avg_order_per_user
FROM gold_user_dist gud, gold_non_gold_order_count gc
WHERE gud.discount_id = gc.discount_id;

/*Looks like the gold plus subscription plan is the most popular, there are on average 100% and 40% 
more orders in comparison to the gold pro and gold orders respectively. Also, in contrast to the subscribers for each gold package
the average order per user is highest for gold users, followed by gold plus and then gold pro. */

# 4.> What is the average order value - overall, by non gold and gold customers?
WITH tot_avg_val AS 
(SELECT 1, od.order_id, SUM(cost) total_order_value
FROM order_details od
GROUP BY od.order_id), 

gol_avg_val AS 
(SELECT 1, ga.user_account_id, tot_avg_val.total_order_value
FROM tot_avg_val, order_details od2, user_account ua, gold_account ga
WHERE tot_avg_val.order_id = od2.order_id AND ua.user_account_id = od2.user_account_id AND ga.user_account_id = ua.user_account_id),

free_avg_val AS
(SELECT 1, fa.user_account_id, tot_avg_val.total_order_value
FROM tot_avg_val, order_details od2, user_account ua, free_account fa
WHERE tot_avg_val.order_id = od2.order_id AND ua.user_account_id = od2.user_account_id AND fa.user_account_id = ua.user_account_id),

t1 AS
(SELECT AVG(tot_avg_val.total_order_value) total_order_value FROM tot_avg_val),

t2 AS
(SELECT AVG(gol_avg_val.total_order_value) gold_total_order_value FROM gol_avg_val),

t3 AS
(SELECT AVG(free_avg_val.total_order_value) free_total_order_value FROM free_avg_val)

SELECT ROUND(t1.total_order_value, 2) cumulative_avg_order_value, ROUND(t2.gold_total_order_value, 2) gold_avg_order_value, 
		ROUND(t3.free_total_order_value, 2) free_avg_order_value
FROM t1, t2, t3
WHERE t1.total_order_value IS NOT NULL;

/* We can see that the average order value of gold members is larger in comparison to the free account users. 
 It would be interesting to see if the story remains even after we take into account the gold discount offered to the gold members. */
 
# 5.> Now let's see average order value of the gold members after taking into account the discount offered on the orders. 

SELECT ROUND(AVG(t1.amt_paid_gold), 2) gold_total_order_value_after_discount
FROM (SELECT p.order_id, SUM(p.amount_paid) amt_paid_gold
FROM payment p, user_account ua, gold_account ga
WHERE p.user_account_id = ua.user_account_id AND ua.user_account_id = ga.user_account_id
GROUP BY p.order_id) t1;

/* The average order value is around 8% lesser than the total average order value for gold users, when we take into account the discounts provided.
In conclusion, the average order value is greater for gold users than free members, considering the additional sbuscription fee, it is definitely 
benifitial for the company if a particular user moves from the free group to the gold group. Also, the gold plus is the most popular gold subscription, 
probably attributable to the anchoring effect of the gold plus subscription. We could optimise the pricing of the gold subscriptions even more, optimise the 
discount rates by looking into predicting future order/subscription patterns or even perform A/B testing for the optimal pricing of the subscription
plsn/discount rates. The above analysis completely focuses on the customer and their past behaviour/pattern. */

# Now, let's explore the dataset based on geography, restuarant, menu item etc.

# 6.> Let's look at the most popular location, restuarant, and the menu items.
# First, the top 5 locations
SELECT a.city, COUNT(DISTINCT od.order_id) no_of_orders
FROM address a, user_account ua, order_details od
WHERE od.user_account_id = ua.user_account_id AND ua.address_id = a.address_id
GROUP BY a.city
ORDER BY no_of_orders DESC
LIMIT 5;
/* Considering, the output of the above the top 5 cities are Albuquerque, Indianapolis, Louisville, Fresno, Jacksonville;
we should move towards assigning a higher percentage of delivery agents in the above cities to optimise the delivery timings. 
Also, we could push more restaurants in the above areas to tie up with the FoodPro app, 
considering the high number of orders in the app in the above cities. */

#Next, the top 5 restuarants
WITH t1 AS
(SELECT r.restaurant_name, COUNT(o.order_id) no_of_orders
FROM restaurant r
JOIN orders o
ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name
ORDER BY no_of_orders DESC)

SELECT * FROM t1;

/*From the above list we could approach the restaurants to make optimizations in cooking time to deliver the online orders through FoodPro.
We could also consider starting a collaboration with the restaurant, to automatically sign up with FoodPro whenever they open up a new branch; considering 
the popularity of the restaurant, the new branches are also expected to do well.
This would further help in reducing the wait time of the delivery agents who would deliver the order from the above restaurants to the customer */

#Now, lets look at the most popular menu items
SELECT mi.item_name, SUM(od.quantity) no_of_units_ordered
FROM order_details od, menu_item mi
WHERE od.menu_id = mi.menu_id AND od.item_id = mi.item_id
GROUP BY mi.item_name
ORDER BY no_of_units_ordered DESC;

/*Spaghetti with meatballs, French fries, Paneer Pesto, Veg Pizza, Diet Coke are the top 5 items that ordered by the users; the restaurants can be 
guided to increase the inventory needed to fulfill the above orders. Also, interesting to note that 3 out of the top 5 most ordered items are fast food.
Therefore, we can guide the restaurant to revamp the menu items to include more fast food, as they are the most selling and they ideally have 
higher margins and shorter cooking time. */

# 7.> Now, lets see the most popular food_preference that was ordered. 
SELECT mic.item_category, COUNT(*) no_of_items_ordered
FROM menu_item mi, menu_item_category mic, order_details od
WHERE mi.menu_id = mic.menu_id AND mi.item_id = mic.menu_item_id 
		AND od.menu_id = mi.menu_id AND od.item_id = mi.item_id
GROUP BY mic.item_category
ORDER BY no_of_items_ordered DESC;

/* Looks like the people preferred to order veg items by more than 100% than the second most ordered food category - non-veg. This could guide
the restaurants in looking into adding more vegetarian options on their menu. It is also interesting to note that keto being a category which would
be ordered by a niche group of people, sits high up along with non-veg and egg items. This could be an opporunity to come up with more specific
diet focused meal plans (vegan/keto/lean) - because these orders are usually ordered by the same group of people in a periodic manner - this would
help us in streamlining the delivery process as well, as we would be prepared with a clear schedule about the delivery. */

# 8.>Now, lets check the revenue generated (by orders) split based on the day of the week
# First, we generate a cte table to clean the order date column and get the day of the order
WITH doy AS
(SELECT DISTINCT DAYOFWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(o.order_timestamp, 2), "-", SUBSTR(o.order_timestamp, 4, 7)), "%d-%m-%Y") AS DATE)) day_of_week_no, 
		CASE DAYOFWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(o.order_timestamp, 2), "-", SUBSTR(o.order_timestamp, 4, 7)), "%d-%m-%Y") AS DATE)) 
			 WHEN 1 THEN 'Sunday'
			 WHEN 2 THEN 'Monday'
             WHEN 3 THEN 'Tuesday'
             WHEN 4 THEN 'Wednesday'
             WHEN 5 THEN 'Thursday'
             WHEN 6 THEN 'Friday'
             WHEN 7 THEN 'Saturday'
             END day_name
		FROM orders o
        ORDER BY day_of_week_no)

SELECT doy.day_name, DAYOFWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(o.order_timestamp, 2), "-", 
					SUBSTR(o.order_timestamp, 4, 7)), "%d-%m-%Y") AS DATE)) order_day_of_week, 
					SUM(od.cost) total_order_value
FROM order_details od
JOIN orders o
ON o.order_id = od.order_id
JOIN doy 
ON doy.day_of_week_no = DAYOFWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(o.order_timestamp, 2), "-", SUBSTR(o.order_timestamp, 4, 7)), "%d-%m-%Y") AS DATE))
GROUP BY order_day_of_week
ORDER BY total_order_value DESC;

/*Expectedly, the most revenue was generated from orders that were made on Sundays and the least from mid-week - Wednesday. Interestingly, 
the second least revenue was generated from Saturdays, this could be attributed to the fact that most people would eat out on Saturdays 
as oppposed to ordering in. Consideing the above observations, the restaurants and the delivery agents can be guided to accomodate (increase in inventory,
open extra time) for the increased orders on Sundays/Wednesdays. */

# 9.> Now, lets create a mini weekwise balance sheet and look at the revenue numbers
WITH t1 
AS(SELECT DISTINCT YEARWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(o.order_timestamp, 2), "-", SUBSTR(o.order_timestamp, 4, 7)), "%d-%m-%Y") AS DATE)) week_number, 
		ROUND(SUM(od.cost) OVER (PARTITION BY YEARWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(o.order_timestamp, 2), "-", 
        SUBSTR(o.order_timestamp, 4, 7)), "%d-%m-%Y") AS DATE))), 2) total_order_value
        
FROM order_details od, orders o
WHERE o.order_id = od.order_id), 

t2 AS
(SELECT YEARWEEK(ga.start_date) week_number, SUM(d.subscription_fee) subscription_fee_collected
FROM gold_account ga, discount d
WHERE ga.discount_id = d.discount_id
GROUP BY 1
ORDER BY 1),

t3 AS
(SELECT DISTINCT YEARWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(p.payment_timestamp, 2), "-", SUBSTR(p.payment_timestamp, 4, 7)), "%d-%m-%Y") AS DATE)) week_number, 
		ROUND(SUM(p.amount_paid) OVER (PARTITION BY YEARWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(p.payment_timestamp, 2), "-", 
        SUBSTR(p.payment_timestamp, 4, 7)), "%d-%m-%Y") AS DATE))), 2) total_order_value_after_discounts
FROM payment p),

t4 AS
(SELECT t1.week_number, t1.total_order_value, t3.total_order_value_after_discounts, t2.subscription_fee_collected
FROM t1
LEFT JOIN t2
ON t1.week_number = t2.week_number
LEFT JOIN t3
ON t2.week_number = t3.week_number),

t5 AS
(SELECT CONCAT("Year-", LEFT(t4.week_number, 4), ", ", "Week-", RIGHT(t4.week_number, 2)) AS week_number, 
		t4.total_order_value, t4.total_order_value_after_discounts, 
		ROUND((t4.total_order_value - t4.total_order_value_after_discounts), 2) total_discount_value,
        t4.subscription_fee_collected
FROM t4)

SELECT * FROM t5;

/* The order value is the highest for the combined consecutive week 46/47, this could be attributed to the thanksgiving week festivities. With people
travelling from different places, and staying home, more orders can be expected around the holidays. We can further think about providing some extra
discount during the holiday season to boost sales of both the orders as well as the subscriptions plans. */

/* Let's calculate the profit made on a weekly basis considering a flat profit margin of 14% (after deducting the operational cost, rest payments etc 
on the order value */

WITH t1 
AS(SELECT DISTINCT YEARWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(o.order_timestamp, 2), "-", SUBSTR(o.order_timestamp, 4, 7)), "%d-%m-%Y") AS DATE)) week_number, 
		ROUND(SUM(od.cost) OVER (PARTITION BY YEARWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(o.order_timestamp, 2), "-", 
        SUBSTR(o.order_timestamp, 4, 7)), "%d-%m-%Y") AS DATE))), 2) total_order_value
        
FROM order_details od, orders o
WHERE o.order_id = od.order_id), 

t2 AS
(SELECT YEARWEEK(ga.start_date) week_number, SUM(d.subscription_fee) subscription_fee_collected
FROM gold_account ga, discount d
WHERE ga.discount_id = d.discount_id
GROUP BY 1
ORDER BY 1),

t3 AS
(SELECT DISTINCT YEARWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(p.payment_timestamp, 2), "-", SUBSTR(p.payment_timestamp, 4, 7)), "%d-%m-%Y") AS DATE)) week_number, 
		ROUND(SUM(p.amount_paid) OVER (PARTITION BY YEARWEEK(CAST(STR_TO_DATE(CONCAT(LEFT(p.payment_timestamp, 2), "-", 
        SUBSTR(p.payment_timestamp, 4, 7)), "%d-%m-%Y") AS DATE))), 2) total_order_value_after_discounts
FROM payment p),

t4 AS
(SELECT t1.week_number, t1.total_order_value, t3.total_order_value_after_discounts, t2.subscription_fee_collected
FROM t1
LEFT JOIN t2
ON t1.week_number = t2.week_number
LEFT JOIN t3
ON t2.week_number = t3.week_number),

t5 AS
(SELECT CONCAT("Year-", LEFT(t4.week_number, 4), ", ", "Week-", RIGHT(t4.week_number, 2)) AS week_number, 
		t4.total_order_value, t4.total_order_value_after_discounts, 
		ROUND((t4.total_order_value - t4.total_order_value_after_discounts), 2) total_discount_value,
        t4.subscription_fee_collected
FROM t4)

SELECT t5.week_number, t5.total_order_value, t5.total_order_value_after_discounts, t5.total_discount_value, t5.subscription_fee_collected,
		ROUND((t5.total_order_value * 0.14) + t5.subscription_fee_collected - t5.total_discount_value, 2) final_profit_value, 
        CONCAT(ROUND(((ROUND((t5.total_order_value * 0.14) + t5.subscription_fee_collected - t5.total_discount_value, 2)) * 100)/
        (total_order_value), 2), "%") profit_divided_by_tot_ord_value
FROM t5;

/* Now, looking at the final profit values at a profit margin of 14%, we can clearly see that the final_profit per week is the highest for week 43, 
and a look at the profit percentages as a proportion of the total_order_value, we ca see that the profit % is highest for week 41, which can be attributed 
to the less number of gold subscriptions and the lesser discounts because fewer people were using the gold subscription discounts. */


