create database p1
use p1

create table worker(
worker_id int identity(1,1) primary key,
first_name varchar(10),
last_name varchar(100),
salary int,
dept_name varchar(100),
joining_date date
)
alter TABLE worker
alter column first_name varchar(100);

exec sp_rename 'workers','worker';
exec sp_rename 'worker.dept_name','d_name','column';

select * from worker;

truncate table worker;
drop table worker;


INSERT INTO worker (
  first_name,
  last_name,
  salary,
  dept_name,
  joining_date
) VALUES
('Rana', 'Hamid', 100000, 'HR', '2014-02-20'),
('Sanjoy', 'Saha', 80000, 'Admin', '2014-06-11'),
('Mahmudul', 'Hasan', 300000, 'HR', '2014-02-20'),
('Asad', 'Zaman', 500000, 'Admin', '2014-06-11'),
('Sajib', 'Mia', 500000, 'Admin', '2014-06-11'),
('Alamgir', 'Kabir', 200000, 'Account', '2014-06-11'),
('Foridul', 'Islam', 75000, 'Account', '2014-01-20'),
('Keshob', 'Ray', 90000, 'Admin', '2014-04-11');

select w.* from worker w inner join 
(select *,ROW_NUMBER() over (order by worker_id asc) as row from worker) r
on w.worker_id=r.worker_id
where r.row%2!=0;



--1. Write an SQL query to print first three characters of  FIRST_NAME from Worker table. 

select SUBSTRING(first_name,1,3) as first_name from worker


--2. Write an SQL query to print details of the Workers who have joined from Feb 2014 to 
--March 2014. 

select * from worker where joining_date between '2014-02-01' and '2014-03-31';


--3. Write an SQL query to print details of the Workers who have served for at least 6 months. 

select DATEDIFF(MONTH,joining_date,GETDATE()) as month from worker

select * from worker where datediff(month,joining_date,GETDATE())>=6

--4. Write an SQL query to update all worker salary whose title is manager. 

update worker 
set salary=salary+100 where dept_name='admin'

select * from worker

--5. Write an SQL query to update all worker bonus 10% whose joining_date before ‘2014
--04-11 09:00:00’ otherwise bonus update 5% and also check department name is ‘Admin’. 


update worker 
set salary = case 
when joining_date < '2014-04-11'
then (salary*0.1)+salary
else (salary*0.05)+salary
end
where dept_name='admin'

--6. Write an SQL query to delete all workers who have not taken any bonus. 
create table bonus(
worker_ref_id int not null,
bonus_date date,
bonus_amount int,
foreign key (worker_ref_id) references worker(worker_id)
);

INSERT INTO BONUS (WORKER_REF_ID, BONUS_DATE, BONUS_AMOUNT)
VALUES
(1, '2019-02-20', 5000),
(2, '2019-06-11', 3000),
(3, '2019-02-20', 4000),
(4, '2019-02-20', 4500),
(5, '2019-06-11', 3500),
(6, '2019-06-12', NULL);

delete from worker where worker_id not in(select worker_ref_id from bonus);

--7. Write an SQL query to print details for Workers with the first name “Rana” and “Sajib” 
--from Worker table. 

select *,first_name+' '+ last_name as full_name from worker where first_name in('Rana','Sajib');

--8. Write an SQL query to print details of workers excluding first names, “Rana” and “Sajib” 
--from Worker table. 

select *,first_name+' '+ last_name as full_name from worker where first_name not in('Rana','Sajib');


--9. Write an SQL query to print details of the Workers whose FIRST_NAME contains ‘a’. 

select * from worker where first_name like '%a%';

--10. Write an SQL query to print details of the Workers whose FIRST_NAME starts with ‘k’. 

select * from worker where first_name like 'k%';

--11. Write an SQL query to print details of the Workers whose FIRST_NAME ends with ‘r’ 
--and contains seven alphabets. 

select * from worker where first_name like '______r';

--12. Write an SQL query to find the position of the alphabet (‘n’) in the FIRST_NAME 
--column ‘Sanjoy’ from Worker table. 

select *, CHARINDEX('n',first_name) as indexs from worker where first_name='sanjoy';

--13. Find the average salary of employees for each department.  

select dept_name, avg(salary) as avg_salary from worker group by dept_name;

--14. List all the employees who have maximum or minimum salary in each department 

select dept_name, max(salary) as max_salary,min(salary) as min_salary from worker group by dept_name;

select w.* from worker w inner join (select dept_name, max(salary) as max_salary,min(salary) as min_salary from worker group by dept_name) t
on w.dept_name=t.dept_name where w.salary=t.max_salary or w.salary=t.min_salary order by dept_name desc; 


--15. Write an SQL query to find the position of the alphabet (‘r’) in the FIRST_NAME 
--column ‘Rana’ from Worker table.

select *,CHARINDEX('r',first_name) as indexs from worker where
first_name='Rana';

--16. Write an SQL query to print the FIRST_NAME from Worker table after removing white 
--spaces from the right side. 

select first_name,rtrim(first_name) as rmws from worker


--17. Write an SQL query that fetches the unique values of FIRST_NAME from Worker table 
--and prints its length. 

select distinct first_name,len(first_name) as lengths from worker

--18. Write an SQL query to print the FIRST_NAME from Worker table after replacing ‘a’ 
--with ‘A’.
select first_name,REPLACE(first_name,'a','A') replaces from worker



--37 page

create table title(
worker_ref_id int not null,
worker_title varchar(100),
affected_from date,
foreign key (worker_ref_id) references worker(worker_id)
)
INSERT INTO TITLE (WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM)
VALUES
(1, 'Manager', '2019-02-20'),
(2, 'Executive', '2019-06-11'),
(5, 'Manager', '2019-06-11'),
(4, 'Asst. Manager', '2019-06-11'),
(6, 'Lead', '2019-06-11'),
(3, 'Lead', '2019-06-11');
--1. List all the employees except ‘Manager’ & ‘Asst. Manager’. 
select * from title;

select * from title where worker_title not in('manager','asst. manager');

--2. List the workers in the ascending order of Designations of those joined after April 2014. 

select w.*,t.* from worker w 
 inner join 
title t 
on w.worker_id = t.worker_ref_id
where w.joining_date > '2014-04-30' order by worker_title asc


select w.*,t.* from worker w 
 inner join 
title t 
on w.worker_id = t.worker_ref_id
where w.joining_date > '2014-04-30' order by  case worker_title
when 'manager' then 1
when 'Asst. Manager' then 2
when 'Lead' then 3
else 4
end
--3. Write an sQL query to fetch the number of employees working in the department 
--‘Admin’. 

select dept_name,count(*) as emply_number from worker group by dept_name having dept_name='admin'

--4. Write an SQL query to fetch worker names with salaries >= 50000 and <= 100000. 

select * from worker where salary between 50000 and 100000

--5. Write an SQL query to fetch the no. of workers for each department in the descending 
--order. 

select dept_name,count(dept_name) as num from worker group by dept_name order by num desc

--6. Write an SQL query to print details of the Workers who are also Managers. 

select w.*,t.worker_title from worker w
inner join (select * from title) t
on w.worker_id=t.worker_ref_id where t.worker_title in('manager')

--7. Write an SQL query to show only odd rows from a table. 

select * from worker w inner join 
(select r.worker_id,ROW_NUMBER() over (order by worker_id asc) as row_index from  worker r) t 
on w.worker_id=t.worker_id
where t.row_index%2!=0;

--8. Write an SQL query to show only even rows from a table. 

select * from worker w inner join 
(select r.worker_id,ROW_NUMBER() over (order by worker_id asc) as row_index from  worker r) t 
on w.worker_id=t.worker_id
where t.row_index%2=0;

--9. Write an SQL query to clone a new table from another table. 

insert into title(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM)
select worker_id,dept_name,joining_date from worker

--10. Write an SQL query to show the current date and time. 

select GETDATE()

--11. Write an SQL query to show the top n (say 10) records of a table with Name and 
--Designation. 

select distinct top(10) w.worker_id, w.first_name,t.WORKER_TITLE from worker w
inner join title t 
on w.worker_id=t.worker_ref_id

--12. Write an SQL query to determine the nth (say n=5) highest salary from a table. 

select *,ROW_NUMBER() over (order by salary desc) as indexs from worker 



select w.*,t.indexs from worker w 
inner join
(select *,ROW_NUMBER() over (order by salary desc) as indexs from worker ) t
on 
w.worker_id=t.worker_id 
where t.indexs=5


select * from worker order by salary desc 
offset 4  rows fetch next 1 row only;

--13. Write an SQL query to fetch the list of employees with the same salary.
select distinct salary from worker

select salary,count(salary) as c from worker group by salary

select w.* from worker w inner join
(select salary,count(salary) as c from worker group by salary) s
on w.salary=s.salary where c>1



--14. Write an SQL query to show the second highest salary from a table. 

select * from worker order by salary desc
offset 1 rows fetch next 1 row only

select x.* from worker inner join 
(select w.*,ROW_NUMBER() over (order by salary desc) rowss from worker w) x
on worker.worker_id=x.worker_id
where x.rowss=2

--15. Write an SQL query to fetch the first 50% records from a table. 

select count(*)/2 from worker

select top (select count(*)/2 from worker) * from worker



--16. Write an SQL query to fetch the departments that have less than five people in it. 

select dept_name,count(*) from worker group by dept_name having count(*)<5

--17. Write an SQL query to show all departments along with the number of people in there. 

select dept_name,count(*) as num_people from worker group by dept_name

--18. Write an SQL query to show the last record from table. 

select count(*) from worker

select * from worker order by worker.worker_id
offset (select count(*)-1 from worker) rows fetch next 1 row only

--19. Write an SQL query to fetch the first row of a table. 


select * from worker order by worker.worker_id
offset 0 rows fetch next 1 row only

--20. Write an SQL query to fetch the last five records from table. 

select top (5) w.* from worker w order by w.worker_id desc

--21. Write an SQL query to print the name of employees having the highest salary in each 
--department. 

select dept_name, max(salary) as max_salary from worker group by dept_name

select * from worker join (select dept_name, max(salary) as max_salary from worker group by dept_name) t
on worker.dept_name=t.dept_name where worker.salary=t.max_salary


--22. Write an SQL query to fetch three max salaries from table.

select top 3 * from worker order by salary desc

