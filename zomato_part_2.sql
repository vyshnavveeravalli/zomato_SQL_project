create database zomato;
use zomato;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'2017-09-22'),
(3,'2017-07-15');

create table users(userid integer, signup_date date);
insert into users(userid, signup_date)
values (1, '2015-05-15'),
(2,'2012-08-19'),
(3,'2016-08-03');

create table sales(userid integer, ordered_date date, productid integer);
insert into sales(userid, ordered_date,productid)
values (1,'2017-05-25',2),
(2,'2017-05-15',1),
(1,'2017-04-02',1),
(3,'2017-06-01',3),
(2,'2018-07-09',2),
(3,'2018-05-26',3),
(3,'2019-08-11',1),
(2,'2019-01-26',3),
(1,'2019-02-22',1),
(2,'2019-05-21',2),
(3,'2020-04-19',2),
(1,'2020-12-03',1);

create table product(productid integer, product_name text, price integer);
insert into product(productid,product_name,price)
value (1,'p1',360),
(2,'p2',150),
(3,'p3',280);

alter table product
add section text;

alter table product
drop column section;

select * from goldusers_signup;
select * from users;
select * from sales;
select * from product;


6. which item was purchased first by the customer after they became a member ?

select * from 
(select c.*, rank() over(partition by userid order by ordered_date) rnk from
(select sales.userid, sales.ordered_date, sales.productid, goldusers_signup.gold_signup_date from sales inner join goldusers_signup 
on sales.userid=goldusers_signup.userid and ordered_date>gold_signup_date) c)d where rnk=1;


7. which item was purchased just before the customer became a gold member ?

select * from 
(select c.*, rank() over(partition by userid order by ordered_date) rnk from
(select sales.userid, sales.ordered_date, sales.productid, goldusers_signup.gold_signup_date from sales inner join goldusers_signup 
on sales.userid=goldusers_signup.userid and ordered_date<=gold_signup_date) c)d where rnk=1;


8. what is the total orders and amount spent for each member before they became a member?

select userid, count(ordered_date) as order_purchased, sum(price) as total from 
(select c.*,d.price from 	
(select sales.userid, sales.ordered_date, sales.productid, goldusers_signup.gold_signup_date from sales inner join goldusers_signup 
on sales.userid=goldusers_signup.userid and ordered_date<=gold_signup_date) c inner join product d on c.productid=d.productid) e
group by userid


9.  if buying each product generates points for eg 5rs = 2 zomato points and each product has different purchasing points
for eg for p1 5rs = 1 zomato point, for p2 10 rs = 5 zomato points and for p3 5rs = 1 zomato point
now calculate the points collected by each customer  and for which product the most points are given till now ?

select userid, sum(total_points) as points_earned, 3*sum(total_points) as money_earned from
(select e.*, amt/points as total_points from 
(select d.* , case when productid=1 then 5 when productid=2 then 2 when productid=3 then 5 else 0 end as points from
(select c.userid, c.productid, sum(price) as amt from
(select sales.*, product.price from sales inner join product on sales.productid=product.productid) c
group by userid, productid) d) e) f
group by userid;


10. in the first one year after the customer joinns the gold member program (including their joining date) 
irrespective of what customer has purchased they earn 5 zomato points  for every  10 rs 
spent who earned more than 1 or 3 and what was their  points earnings in their first year ?

select c.*,product.price, product.price*0.5 as total_points_earned from
(select sales.userid, sales.ordered_date, sales.productid, goldusers_signup.gold_signup_date from sales inner join goldusers_signup 
on sales.userid=goldusers_signup.userid and ordered_date>=gold_signup_date and ordered_date<=DATE_ADD('2017-07-15', INTERVAL 1 YEAR)) c 
inner join product on c.productid=product.productid


11. rnk all the transactions of the customer.

select *, rank() over(partition by userid order by ordered_date) as rnk from sales


12. rank all the transactions for each member whenever they are a zomato gold member for every non gold member transaction mark as na

select e.*, case when rnk=0 then 'na' else rnk end as rnkk from
(select c.*, case when gold_signup_date is null then 0 else rank() over(partition by userid order by gold_signup_date desc) end as rnk from
(select sales.userid, sales.ordered_date, sales.productid, goldusers_signup.gold_signup_date from sales left join goldusers_signup 
on sales.userid=goldusers_signup.userid and ordered_date>=gold_signup_date) c) e;
