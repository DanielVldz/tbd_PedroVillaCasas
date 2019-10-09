create DATABASE pizzeria;
go

-- use Northwind
-- GO

use pizzeria
go

create table person(
    name nvarchar(30),
    age int,
    gender nvarchar(15)
)
go

create table serves(
    pizzeria nvarchar(30),
    pizza nvarchar(30),
    price int
)
go

create table eats
(
    name nvarchar(30),
    pizza nvarchar(30)
)
go


create table frequents(
    name nvarchar(30),
    pizzeria nvarchar(30)
)
go

select * from sys.tables

-- drop table eats, frequents, serves, person

-- drop DATABASE pizzeria

INSERT INTO eats(name,pizza)VALUES('Amy','pepperoni');
INSERT INTO eats(name,pizza)VALUES('Amy','mushroom');
INSERT INTO eats(name,pizza)VALUES('Ben','pepperoni');
INSERT INTO eats(name,pizza)VALUES('Ben','cheese');
INSERT INTO eats(name,pizza)VALUES('Cal','supreme');
INSERT INTO eats(name,pizza)VALUES('Dan','pepperoni');
INSERT INTO eats(name,pizza)VALUES('Dan','cheese');
INSERT INTO eats(name,pizza)VALUES('Dan','sausage');
INSERT INTO eats(name,pizza)VALUES('Dan','supreme');
INSERT INTO eats(name,pizza)VALUES('Dan','mushroom');
INSERT INTO eats(name,pizza)VALUES('Eli','supreme');
INSERT INTO eats(name,pizza)VALUES('Eli','cheese');
INSERT INTO eats(name,pizza)VALUES('Fay','mushroom');
INSERT INTO eats(name,pizza)VALUES('Gus','mushroom');
INSERT INTO eats(name,pizza)VALUES('Gus','supreme');
INSERT INTO eats(name,pizza)VALUES('Gus','cheese');
INSERT INTO eats(name,pizza)VALUES('Hil','supreme');
INSERT INTO eats(name,pizza)VALUES('Hil','cheese');
INSERT INTO eats(name,pizza)VALUES('Ian','supreme');
INSERT INTO eats(name,pizza)VALUES('Ian','pepperoni');
INSERT INTO frequents(name,pizzeria)VALUES('Amy','Pizza Hut');
INSERT INTO frequents(name,pizzeria)VALUES('Ben','Pizza Hut');
INSERT INTO frequents(name,pizzeria)VALUES('Ben','Chicago Pizza');
INSERT INTO frequents(name,pizzeria)VALUES('Cal','Straw Hat');
INSERT INTO frequents(name,pizzeria)VALUES('Cal','New York Pizza');
INSERT INTO frequents(name,pizzeria)VALUES('Dan','Straw Hat');
INSERT INTO frequents(name,pizzeria)VALUES('Dan','New York Pizza');
INSERT INTO frequents(name,pizzeria)VALUES('Eli','Straw Hat');
INSERT INTO frequents(name,pizzeria)VALUES('Eli','Chicago Pizza');
INSERT INTO frequents(name,pizzeria)VALUES('Fay','Dominos');
INSERT INTO frequents(name,pizzeria)VALUES('Fay','Little Caesars');
INSERT INTO frequents(name,pizzeria)VALUES('Gus','Chicago Pizza');
INSERT INTO frequents(name,pizzeria)VALUES('Gus','Pizza Hut');
INSERT INTO frequents(name,pizzeria)VALUES('Hil','Dominos');
INSERT INTO frequents(name,pizzeria)VALUES('Hil','Straw Hat');
INSERT INTO frequents(name,pizzeria)VALUES('Hil','Pizza Hut');
INSERT INTO frequents(name,pizzeria)VALUES('Ian','New York Pizza');
INSERT INTO frequents(name,pizzeria)VALUES('Ian','Straw Hat');
INSERT INTO frequents(name,pizzeria)VALUES('Ian','Dominos');
INSERT INTO person(name,age,gender)VALUES('Amy',16,'female');
INSERT INTO person(name,age,gender)VALUES('Ben',21,'male');
INSERT INTO person(name,age,gender)VALUES('Cal',33,'male');
INSERT INTO person(name,age,gender)VALUES('Dan',13,'male');
INSERT INTO person(name,age,gender)VALUES('Eli',45,'male');
INSERT INTO person(name,age,gender)VALUES('Fay',21,'female');
INSERT INTO person(name,age,gender)VALUES('Gus',24,'male');
INSERT INTO person(name,age,gender)VALUES('Hil',30,'female');
INSERT INTO person(name,age,gender)VALUES('Ian',18,'male');
INSERT INTO serves(pizzeria,pizza,price)VALUES('Pizza Hut','pepperoni',12);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Pizza Hut','sausage',12);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Pizza Hut','cheese',9);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Pizza Hut','supreme',12);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Little Caesars','pepperoni',10);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Little Caesars','sausage',10);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Little Caesars','cheese',7);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Little Caesars','mushroom',9);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Dominos','cheese',10);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Dominos','mushroom',11);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Straw Hat','pepperoni',8);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Straw Hat','cheese',9);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Straw Hat','sausage',10);
INSERT INTO serves(pizzeria,pizza,price)VALUES('New York Pizza','pepperoni',8);
INSERT INTO serves(pizzeria,pizza,price)VALUES('New York Pizza','cheese',7);
INSERT INTO serves(pizzeria,pizza,price)VALUES('New York Pizza','supreme',9);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Chicago Pizza','cheese',8);
INSERT INTO serves(pizzeria,pizza,price)VALUES('Chicago Pizza','supreme',9);