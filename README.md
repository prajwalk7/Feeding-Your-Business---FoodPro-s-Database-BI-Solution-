# FoodPro---Online-Food-Delivery-Database-Management-System-and-Analytics
1. Problem Statement

The objective of the study was to build a robust data management system for an online food ordering/delivery application called FoodPro. The system is to handle both transactional data (payment and order information) and Reference Data (User Account data, Address Information etc), and should be the single source of information about anything related to order customer, restaurant, and the delivery agents. 

We were able to not only implement the system but also utilise the power of analytics to predict optimization activities to the restaurants and the application alike. We first created an EER model, which was later translated into a UML class diagram. The relation modelling was done considering the cardinalities and the relationships mentioned in the EER diagram, and later the relations were later normalised to 3.5 Normal Form. The relational model was materialised in the form of a database inside MySQL. A NoSQL component (in the form of MongoDB) was also implemented to utilise the power of document method of storage of information and the power of NoSQL pipelines. The storage system was later connected to a Python environment which enabled advanced analytical capabilities which enables using predictive analytics to derive actionable insights. 

The whole development was done iteratively rather than in a waterfall flow, the EER/UML diagram was revisited to accommodate for the information which was made visible at the later stages of development of the system. This enabled us to explore a multitude of solutions prior agreeing on a particular pathway and increased our learning greatly in the process. (Please see the report or the PPT to get into greater detail)

2. Conceptual Data Model/UML Diagram

![image](https://user-images.githubusercontent.com/35379830/215352262-89563070-dad0-4100-9f94-32d0ac9e7536.png)
![image](https://user-images.githubusercontent.com/35379830/215352274-caf6321b-6ec1-438e-a965-490027378dc8.png)

3. Mapping Conceptual Data Aodel to Relational Model:

Relation – 1: 
address (address_id, building_no, street_name, floor, city, zipcode) (each user_account, 
delivery_agent, and a restaurant can have a single unique address and not multiple addresses)
The address relation contains the address information of the people involved in the FoodPro app –
users, restaurants, and the delivery agents.
address_id is the primary_key
Relation – 2:
user_account (user_account_id, dob, email, phone_no, name, age, address_id)
The user_account relation contains the information of the user who would be creating an account 
with the FoodPro application and use the user account details to make an order.
user_account_id is the primary key 
address_id is the foreign key referencing the primary key of the relation address – NOT NULL
Relation – 3:
user_account_food_preference (food_preference_type, user_account_id) (ER diagram’s multi 
values attribute’s relation)
The user_account_food_preference relation holds the information about the user accounts and their 
associated food preferences (veg, non-veg, egg, vegan, keto, lactose free, diabetes friendly, atleast 
one preference to be selected)
Food_preference_type, user_account_id – both together form the primary key
user_account_id is the foreign key referring to the primary key of the relation user_account - NOT 
NULL
Relation – 4:
free_account (user_account_id)
Specialisation of relation Account. 
user_account_id is the primary key; also, it is the foreign key referencing the user_account parent 
class – NOT NULL
Relation – 5:
gold_account (user_account_id, start_date, renewal_date, discount_id)
Specialisation of the relation user_account. Gold account refers to a subscription based membership 
where the gold users are given discounts on the order from time to time. Renewal_date is 100 days 
from the start_date. Each subscription is valid for 100 days.
discount_id is the foreign key referencing the primary key of the relation discount – discount_id is 
NOT NULL
user_account_id is the primary key; also, it is the foreign key referencing the user_account parent 
class – NOT NULL
Relation – 6:
discount (discount_id, discount_percent, subscription_fee, discount_name)
The discount relation contains the information about the different discounts offered to the gold user 
based on the subscription package they opted for.
discount_id is the primary key
Relation – 7:
payment (payment_id, payment_method, payment_timestamp, amount_paid, order_id, 
user_account_id)
The payment relation contains information about the payment made by the accounts for the orders 
they placed.
payment_id is the primary key
user_account_id is the foreign key referring to the primary key of the relation user_account – NOT 
NULL
order_id is the foreign key referring to the relation order – NOT NULL
Relation – 8:
order_details (order_id, menu_id , item_id, quantity, user_account_id, cost) (This if for the order 
details aggregation)
The order details relation contains the information of the individual order details places by any user 
account (the details of the order, items ordered, the time).
order_id, item_id, menu_id together form the primary key
user_account_id is the foreign key referring to the primary key of the relation user_account
item_id is the foreign key referring to the primary key of the relation menu item 
menu_id is the foreign key referring to the primary key of the relation menu (as menu item is a 
weak entity)
Relation – 9:
orders (order_id, order_timestamp, delivery_agent_id, restaurant_id, discount_id)
The order relation contains the information of the individual order.
order_id is the primary key
restaurant_id is the foreign key referring to the primary key of the relation restaurant – NOT NULL
delivery_agent_id is the foreign key referring to the primary key of the relation delivery agent –
NOT NULL
discount_id is the foreign key referring to the primary key of the relation discount – can be NULL 
(not applicable)
Relation – 10:
menu (menu_id, restaurant_id) 
The menu relation contains the information of the menu which is associated with a particular 
restaurant.
menu_id is the primary key
restaurant_id is the foreign key referring to the primary key of the relation restaurant – NOT NULL 
Relation – 11:
menu_item (menu_id, item_id, item_name, calorie_count, item_type, price)
The menu_item relation contains the information of items in a particular menu. It is a weak entity 
(according to the ER diagram), so it borrows the primary key from the menu relation.
menu_id, item_id together form the primary key
menu_id is the foreign key referring to the primary key of the relation menu – NOT NULL
Relation – 12:
menu_item_category (menu_id, item_id, item_category)
The menu_item_category relation contains the information of category (veg, non-veg, egg, keto, 
diabetes friendly) of the different menu items.
menu_id, item_id, item_category together form the primary key
menu_id is the foreign key referring to the primary key of the relation menu – NOT NULL
menu_item_id is the foreign key referring to the primary key of the relation menu_item – NOT 
NULL
Relation – 13:
restaurant (restaurant_id, restaurant_name, address_id) (all restaurants are cloud kitchens which 
accept orders throughout the day)
The restaurant relation contains the information of the restaurants which are registered with the 
FoodPro app from where the customers place the order.
restaurant_id is the primary key 
address_id is the foreign key referring to the primary key of the relation Address – NOT NULL
Relation – 14:
delivery_agent (delivery_agent_id, delivery_agent_name, dob, phone_no, address_id)
The delivery_agent relation contains the information of the delivery agents who are registered with 
the FoodPro app, who would be delivering the orders placed by the user accounts.
delivery_agent_id is the primary key 
address_id is the foreign key referring to the primary key of the relation address – NOT NULL

4. Creating the database in MySQL and running analytical queries

After normalising to 3.5NF, I ran multiple advanced SQL queries to analyse the sales of the delivery platform and ideation about future strategies. Here's an example query (mini week-wise balance sheet and look at the revenue numbers)
![image](https://user-images.githubusercontent.com/35379830/215352363-c813afc7-edcc-4925-accb-3ebd45bbaae6.png)

5. NoSQL - MongoDB Queries

Post SQL queries, I connected the database to MongoDB to implement NoSQL features as well. Here's an example aggregation query (calculates the count of the payment methods used, and the aggregate value of the amount paid, for order values of over 250!)

![image](https://user-images.githubusercontent.com/35379830/215352429-96b3193a-9034-4895-a8f0-5fa5cc75617c.png)
![image](https://user-images.githubusercontent.com/35379830/215352434-a8df4025-9377-41a8-81ad-11822e7482b9.png)
![image](https://user-images.githubusercontent.com/35379830/215352437-c3d2fb37-3fda-4e40-997e-d755013b83ad.png)

6. Connecting to Python - Advanced visual analytics

Post NoSQL analysis, the databsase was connected to Python environment to run more advanced visual analytics (few examples shown below):
![image](https://user-images.githubusercontent.com/35379830/215352468-8562c9ed-ad9b-4086-a79a-2bf6277971b3.png)
The gold subscription plan users show lesser variations in their order ranges:
![image](https://user-images.githubusercontent.com/35379830/215352480-4654a40c-cac5-4e8a-9e2b-9b57798c2a86.png)

The top 5 items that ordered by the users:
![image](https://user-images.githubusercontent.com/35379830/215352502-df150b7c-7e06-4d00-8a36-eaa4feb672b7.png)

Here, I visualize the change in revenue/profit by looking at the income growth/decline in a waterfall graph:
![image](https://user-images.githubusercontent.com/35379830/215352558-e8b92c7f-3ef0-4405-b9c4-b944df643a4d.png)
![image](https://user-images.githubusercontent.com/35379830/215352570-99357283-e2f6-4476-ab03-6ec5765ccef4.png)



7. Summary and Recommendation

I was able to successfully implement a database system which was robust for both kinds of 
transactions – transactional and referential in nature. The MySQL database and the MongoDB tie up 
together nicely as the former provides a neatly structured/normalised database to store the 
structured data in, while the latter provides us with the flexibility to store unstructured data. Future 
scalability can be done both vertically and horizontally on MongoDB. The queries we wrote could 
be used to draw important information regarding the company’s performance/direction thus far and
can be utilized to appropriately adjust the strategy to further improve service on both the 
restaurants/delivery agents and the customers alike. The structured data inside the MySQL database 
makes it easy to produce repeatable results/information – like a mini balance sheet, as the company 
grows, and see the order patterns in restaurants by different customer groups. The Python 
connections enables advanced analytical capabilities and provides us with intuitive visualizations.
The advantage of our current design would be the significant rework required to accommodate the 
upgrade in cardinality (from 1-1/1-M to M-N); this would include the addition of new 
relations/referential keys in the MySQL database. Also, because the application has been launched 
there would be constant changes in the company’s strategy about the gold plans itself (above the 
changes in discount %), eventually gold members could be offered faster deliveries and could offer
from restaurants from additional radius compared to a free customer – such futuristic changes are 
not yet captured in the database and would have to be reworked when the changes are introduced. 
Another improvement we could think of implementing is an automated weekly balance 
sheet/performance sheet generation code; where on a periodic basis, the report would be generated 
and shared across the respective stakeholders/decision makers. Also, we could think of utilising the 
additional visualization capabilities provided by powerful BI tools like Power BI/Tableau to be able 
to capture more nuanced interactions of our data that would be missed otherwise.
