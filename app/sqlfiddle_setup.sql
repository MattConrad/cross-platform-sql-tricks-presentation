/*

  This is a script for setting up all the tables used in the presentation.
  
  You can run this on sqlfiddle.com against the MS SQL Server 2008 db engine and all your tables will be ready to go.
  
  Unfortunately, there doesn't appear to be a way to set up the tables in successive steps the way the presentation does. It's all at once or nothing.

*/

create table test_a
(Id int NOT NULL,
Value varchar(100) NOT NULL);

insert into test_a (Id, Value) values (1, 'a');
insert into test_a (Id, Value) values (2, 'b');
insert into test_a (Id, Value) values (3, 'c');
insert into test_a (Id, Value) values (4, 'd');

create table test_b
(Id int NOT NULL,
Value varchar(100) NOT NULL);

insert into test_b
(Id, Value)
select Id, Value
from test_a;

insert into test_b
(Id, Value)
select Id + 10, Value + cast(Id as varchar)  
from test_a
where Id > 2;

select * 
into test_c
from test_a;

select number as n
into ints
from master..spt_values 
where name is null and number >= 1 and number <=100

