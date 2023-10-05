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
