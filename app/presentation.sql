

/*

            Setup (part 1)

*/

create table test_a
(Id int NOT NULL,
Value varchar(100) NOT NULL);

insert into test_a (Id, Value) values (1, 'a');
insert into test_a (Id, Value) values (2, 'b');
insert into test_a (Id, Value) values (3, 'c');
insert into test_a (Id, Value) values (4, 'd');

select * from test_a;


/*

            INSERT ... SELECT

*/

create table test_b
(Id int NOT NULL,
Value varchar(100) NOT NULL);

insert into test_b
(Id, Value)
select Id, Value
from test_a

select * from test_b


/*

            INSERT ... SELECT (contd)

*/

--alas, concatenation is non-standard between SQL engines.
-- SQL Server: “+”, PostgreSQL, “||”, MySQL, “CONCAT()”

insert into test_b
(Id, Value)
select Id + 10, Value + cast(Id as varchar)  
from test_a
where Id > 2

select * from test_b


/*

            SELECT INTO
            CREATE TABLE AS … SELECT

*/

--SQL Server, PostgreSQL
select * 
into test_c
from test_a

--MySQL, PostgreSQL
create table test_c as 
select *
from test

select * from test_c


/*

            UNION

*/

select Id, Value from test_a
union
select Id, Value from test_b


/*

            UNION ALL

*/

select Id, Value from test_a
union all
select Id, Value from test_b


/*

            SUBQUERIES (using IN)

*/

--this is just a reminder of what's in test_b
select * 
from test_b


select * 
from test_b
where Id in 
	(select Id from test_a)


/*

            SUBQUERIES (using NOT IN)

*/

select * 
from test_b
where Id not in 
	(select Id from test_a)


/*

            Setup (part 2)

*/

--SQL Server
select number as n
into ints
from master..spt_values 
where name is null and number >= 1 and number <=100

--PostgreSQL
select generate_series as n
into ints
from generate_series(1,100)

--MySQL
create table ints (n int NOT NULL);

insert into ints
(n)
select
  @i := @i + 1 as n
from
  (select 0 union all select 1 union all select 2 union all 
   select 3 union all select 4 union all select 5 union all 
   select 6 union all select 7 union all select 8 union all select 9) as t0,
  (select 0 union all select 1 union all select 2 union all 
   select 3 union all select 4 union all select 5 union all 
   select 6 union all select 7 union all select 8 union all select 9) as t1,
  (select @i:=0) as t_init;


select * from ints


/*

            Derived Tables

*/

select i1.n, i2.n as even, i3.n as mod3
from ints as i1
left join
	(select n
	from ints
	where n % 2 = 0
	) as i2
on i1.n = i2.n
left join
	(select n
	from ints
	where n % 3 = 0
	) as i3
on i1.n = i3.n


/*

            CASE statements

*/

--MySQL doesn’t need the cast . . .

select n,
	case
		when n % 3 = 0 and n % 5 = 0 then 'FizzBuzz'
		when n % 3 = 0 then 'Fizz'
		when n % 5 = 0 then 'Buzz'
		else cast(n as varchar)
	end as FizzBuzz
from ints


/*

            CASE statements (nested)

*/

select n,
	case
		when n % 3 = 0 then
			case
				when n % 5 = 0 then 'FizzBuzz'
				else 'Fizz'
			end
		when n % 5 = 0 then 'Buzz'
		else cast(n as varchar)
	end as FizzBuzz
from ints


/*

            CASE statements (in ORDER BY)

*/

select n
from ints
where n <= 30
order by 
	case 
		when n % 10 = 0 then 0
		else 1
	end,
	n


/*

            CASE statements (in aggregations)

*/

--uses SUM() with CASE 1/0 to get modified count.
select count(n) as count_of_all,
	sum(n) as sum_of_all,
	sum(case when n % 2 = 0 then 1 else 0 end) as count_of_evens,
	sum(case when n % 2 = 0 then n else 0 end) as sum_of_evens
from ints
where n <= 100

