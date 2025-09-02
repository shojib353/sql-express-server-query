create database labdb002
use labdb002

CREATE TABLE WORKER (
    WORKER_ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    SALARY INT,
    DEPT_NAME VARCHAR(50),
    JOINING_DATE DATETIME
);

INSERT INTO WORKER (WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, DEPT_NAME, JOINING_DATE) VALUES
(1, 'Rana', 'Hamid', 100000, 'HR', '2014-02-20'),
(2, 'Sanjoy', 'Saha', 80000, 'Admin', '2014-06-11'),
(3, 'Mahmudul', 'Hasan', 300000, 'HR', '2014-02-20'),
(4, 'Asad', 'Zaman', 500000, 'Admin', '2014-06-11'),
(5, 'Sajib', 'Mia', 500000, 'Admin', '2014-06-11'),
(6, 'Alamgir', 'Kabir', 200000, 'Account', '2014-06-11'),
(7, 'Foridul', 'Islam', 75000, 'Account', '2014-01-20'),
(8, 'Keshob', 'Ray', 90000, 'Admin', '2014-04-11');

select * from WORKER
.
select salary from worker;
select top(3) salary,WORKER_ID, FIRST_NAME, LAST_NAME from worker order by salary desc;

ALTER TABLE WORKER
ALTER COLUMN DEPT_NAME VARCHAR(100);

EXEC sp_rename 'WORKER.DEPT_NAME', 'DEPARTMENT_NAME', 'COLUMN';

EXEC sp_rename 'bbb', 'worker';


ALTER TABLE WORKER
ADD EMAIL VARCHAR(100);

UPDATE WORKER
SET EMAIL = 'shojib@gmail.com'
WHERE EMAIL IS NULL;

delete worker where WORKER_ID=1;
drop table worker
TRUNCATE TABLE worker;



--32 page prac
-- Write an SQL query to print first three characters of  FIRST_NAME from Worker table. SQL>SELECT SUBSTRING('nurcse09@gmail.com',1,8)
SELECT SUBSTRING(FIRST_NAME, 1, 3) AS FirstThreeChars FROM WORKER;

select SUBSTRING(FIRST_NAME,1,9) as first9Char from worker;

--Write an SQL query to print details of the Workers who have joined from Feb 2014 to March 2014. 
SELECT * FROM WORKER WHERE JOINING_DATE BETWEEN '2014-02-01' AND '2014-03-31';

select * from worker where joining_date between '2014-02-01' and '2014-03-31'

--Write an SQL query to print details of the Workers who have served for at least 6 months. 
select * from worker where datediff(year,joining_date,GETDATE())>=11
--DATEDIFF(datepart, startdate, enddate) :Returns the count of the specified datepart 
--boundaries crossed between the specified startdate and enddate.  
--SQL>Select DATEDIFF(MONTH, '11/30/2005', '01/31/2006') -- returns 2  
--SQL>Select DATEDIFF(DAY, '11/30/2005', '01/31/2006') -- returns 62 
--SQL>SELECT DATEDIFF(year, '2017/08/25', '2011/08/25') – returns -6
SELECT * FROM WORKER WHERE DATEDIFF(MONTH, JOINING_DATE, GETDATE()) >= 6;

--Write an SQL query to update all worker salary whose title is manager. 

UPDATE WORKER
SET SALARY=SALARY+1000
WHERE DEPT_NAME = 'Admin'

--Write an SQL query to update all worker bonus 10% whose joining_date before ‘2014-
--04-11 09:00:00’ otherwise bonus update 5% and also check department name is ‘Admin’.
update worker 
set salary = case
when joining_date<2014-04-11
then salary+salary*0.1
else salary+salary*0.05
end
where DEPT_NAME = 'Admin'
UPDATE WORKER
SET SALARY = CASE 
WHEN JOINING_DATE<'2014-04-11'
THEN SALARY+(SALARY*0.1)
else SALARY+(SALARY*0.05)
END where DEPT_NAME = 'Admin'










--Write an SQL query to print details for Workers with the first name “Rana” and “Sajib” from Worker table. 

select * from worker where first_name in( 'rana' , 'sajib');




SELECT * FROM WORKER WHERE FIRST_NAME in('Rana' , 'sajib','asad')


--Write an SQL query to print details of workers excluding first names, “Rana” and “Sajib”  from Worker table. 

select * from worker where first_name not in ('rana')
SELECT * FROM WORKER WHERE FIRST_NAME not in('Rana' , 'sajib','asad')

--Write an SQL query to print details of the Workers whose FIRST_NAME contains ‘a’. 
select * from worker where first_name like '%a%'
SELECT * FROM WORKER WHERE FIRST_NAME Like 'a%'
-- Write an SQL query to print details of the Workers whose FIRST_NAME starts with ‘k’. 
SELECT * FROM WORKER WHERE FIRST_NAME Like 'k%'
--Write an SQL query to print details of the Workers whose FIRST_NAME ends with ‘r’ and contains seven alphabets. 
SELECT * FROM WORKER WHERE FIRST_NAME Like '______r'
--. Write an SQL query to find the position of the alphabet (‘n’) in the FIRST_NAME column ‘Sanjoy’ from Worker table.
select charindex('n',first_name) as indexs,first_name from worker where first_name='sanjoy'
SELECT CHARINDEX('n',FIRST_NAME) FROM WORKER WHERE FIRST_NAME='Sanjoy'

 --Find the average salary of employees for each department.
 select avg(salary) as avgsalary ,dept_name from worker group by(dept_name)



 SELECT avg(SALARY) as salary ,DEPT_NAME from worker group by DEPT_NAME;

 -- List all the employees who have maximum or minimum salary in each department 
select max(salary) as maxsalary,min(salary) as minsalary,dept_name from worker group by(dept_name)

select w.first_name,w.last_name,w.dept_name,w.salary from worker w inner join 
(select max(salary) as maxsalary,min(salary) as minsalary,dept_name from worker group by(dept_name)) s
on w.dept_name=s.dept_name where w.salary=s.maxsalary or w.salary=minsalary



SELECT w.WORKER_ID,
       w.FIRST_NAME,
       w.LAST_NAME,
       w.DEPT_NAME,
       w.SALARY
FROM WORKER w
JOIN (
    SELECT DEPT_NAME,
           MAX(SALARY) AS max_salary,
           MIN(SALARY) AS min_salary
    FROM WORKER
    GROUP BY DEPT_NAME
) d
ON w.DEPT_NAME = d.DEPT_NAME
AND (w.SALARY = d.max_salary OR w.SALARY = d.min_salary)


 SELECT DEPT_NAME,
           MAX(SALARY) AS max_salary,
           MIN(SALARY) AS min_salary
    FROM WORKER
    GROUP BY DEPT_NAME

--join function
CREATE TABLE BONUS (
    WORKER_REF_ID INT,
    BONUS_AMOUNT INT
);

INSERT INTO BONUS VALUES
(1, 5000),
(2, 3000),
(3, 8000),
(6, 2000);

select w.WORKER_ID,
       w.FIRST_NAME,
       w.LAST_NAME,
       w.DEPT_NAME,
       w.SALARY,
       b.WORKER_REF_ID,
       b.BONUS_AMOUNT 
from  ( SELECT w.WORKER_ID,
       w.FIRST_NAME,
       w.LAST_NAME,
       w.DEPT_NAME,
       w.SALARY
FROM WORKER w left
JOIN (
    SELECT DEPT_NAME,
           MAX(SALARY) AS max_salary,
           MIN(SALARY) AS min_salary
    FROM WORKER
    GROUP BY DEPT_NAME
) d
ON w.DEPT_NAME = d.DEPT_NAME
AND (w.SALARY = d.max_salary OR w.SALARY = d.min_salary)
) w INNER JOIN BONUS b ON w.WORKER_ID = b.WORKER_REF_ID;


-- find 8th max salay
SELECT MAX(SALARY) AS MAX_SALARY
FROM WORKER;

SELECT count(SALARY) AS MAX_SALARY
FROM WORKER;


SELECT w.WORKER_ID,
       w.FIRST_NAME,
       w.LAST_NAME,
       w.DEPT_NAME,
       s.MAX_SALARY
FROM WORKER w join (SELECT MAX(SALARY) AS MAX_SALARY
FROM WORKER) s on w.salary=s.MAX_SALARY;



SELECT top(4) w.WORKER_ID,
       w.FIRST_NAME,
       w.LAST_NAME,
       w.DEPT_NAME,
       w.salary
FROM WORKER w order by w.salary desc


 SELECT

  w.WORKER_ID,
       w.FIRST_NAME,
       w.LAST_NAME,
       w.DEPT_NAME,
       w.salary

 from (SELECT top(4) w.WORKER_ID,
       w.FIRST_NAME,
       w.LAST_NAME,
       w.DEPT_NAME,
       w.salary
FROM WORKER w order by w.salary desc) w order by w.salary asc



SELECT WORKER_ID, FIRST_NAME, LAST_NAME, DEPT_NAME, SALARY
FROM WORKER
ORDER BY SALARY DESC
OFFSET 3 ROWS FETCH NEXT 1 ROW ONLY;  -- 4th highest salary
--Write an SQL query to find the position of the alphabet (‘r’) in the FIRST_NAME 
--column ‘Rana’ from Worker table. 

 SELECT WORKER_ID,
       FIRST_NAME,
       CHARINDEX('r', FIRST_NAME) AS Position
FROM WORKER
WHERE FIRST_NAME = 'Rana';

 --Write an SQL query to print the FIRST_NAME from Worker table after removing white 
--spaces from the right side. 

SELECT WORKER_ID,
       RTRIM(FIRST_NAME) AS FIRST_NAME_CLEANED
FROM WORKER;

--Write an SQL query that fetches the unique values of FIRST_NAME from Worker table 
--and prints its length. 

SELECT DISTINCT FIRST_NAME,
       LEN(FIRST_NAME) AS NAME_LENGTH
FROM WORKER;




--Write an SQL query to print the FIRST_NAME from Worker table after replacing ‘a’ 
--with ‘A

select worker_id ,first_name, replace(first_name,'a','A') as replaceNamechar from worker


SELECT WORKER_ID,
       REPLACE(FIRST_NAME, 'a', 'A') AS UPDATED_FIRST_NAME
FROM WORKER;

select dept_name,case when dept_name ='admin' then 'owner' else dept_name end as dept_name from worker

--37 page start here
CREATE TABLE BONUS (
    WORKER_REF_ID INT NOT NULL,
    BONUS_DATE DATE,
    BONUS_AMOUNT INT,
    FOREIGN KEY (WORKER_REF_ID) REFERENCES WORKER(WORKER_ID)
);

INSERT INTO BONUS (WORKER_REF_ID, BONUS_DATE, BONUS_AMOUNT)
VALUES
(1, '2019-02-20', 5000),
(2, '2019-06-11', 3000),
(3, '2019-02-20', 4000),
(4, '2019-02-20', 4500),
(5, '2019-06-11', 3500),
(6, '2019-06-12', NULL);

select * from bonus
CREATE TABLE TITLE (
    WORKER_REF_ID INT NOT NULL,
    WORKER_TITLE VARCHAR(50),
    AFFECTED_FROM DATE,
    FOREIGN KEY (WORKER_REF_ID) REFERENCES WORKER(WORKER_ID)
);

INSERT INTO TITLE (WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM)
VALUES
(1, 'Manager', '2019-02-20'),
(2, 'Executive', '2019-06-11'),
(8, 'Executive', '2019-06-11'),
(5, 'Manager', '2019-06-11'),
(4, 'Asst. Manager', '2019-06-11'),
(7, 'Executive', '2019-06-11'),
(6, 'Lead', '2019-06-11'),
(3, 'Lead', '2019-06-11');

--List all the employees except ‘Manager’ & ‘Asst. Manager’.

select WORKER_ID, FIRST_NAME, LAST_NAME, DEPT_NAME, SALARY,tl.WORKER_TITLE 
from worker 
inner join TITLE tl on WORKER_ID=tl.WORKER_REF_ID WHERE tl.WORKER_TITLE not in( 'Asst. Manager','Manager' );

select * from worker
--List the workers in the ascending order of Designations of those joined after April 2014.
select * from worker where joining_date > '2014-04-30'

select w.*,t.* from TITLE t inner join (select * from worker where joining_date > '2014-04-30') w
on w.worker_id=t.WORKER_REF_ID order by WORKER_TITLE asc



select w.*,t.* from TITLE t inner join (select * from worker where joining_date > '2014-04-30') w
on w.worker_id=t.WORKER_REF_ID order by  CASE WORKER_TITLE
        WHEN 'Owner' THEN 1
        WHEN 'Manager' THEN 2
        WHEN 'Ass. Manager' THEN 3
        WHEN 'Member' THEN 4
        ELSE 5
    END;








select WORKER_ID, FIRST_NAME, LAST_NAME, DEPT_NAME, SALARY,JOINING_DATE,tl.WORKER_TITLE, tl.AFFECTED_FROM
from worker inner join TITLE tl on WORKER_ID=tl.WORKER_REF_ID where JOINING_DATE > '2014-04-30'  order by JOINING_DATE asc



--Write an SQL query to fetch the number of employees working in the department
--‘Admin’.
select dept_name,count(*) as totalE from worker group by dept_name having dept_name = 'admin' 




select DEPT_NAME,COUNT(*) as employ_dept from worker group by DEPT_NAME having DEPT_NAME='Admin'

--4. Write an SQL query to fetch worker names with salaries >= 50000 and <= 100000. 
select * from worker where salary between 50000 and 100000

--Write an SQL query to fetch the no. of workers for each department in the descending order. 
select DEPT_NAME,COUNT(*) as employ_dept from worker group by DEPT_NAME order by employ_dept desc

--Write an SQL query to print details of the Workers who are also Managers.
select w.*,x.* from worker w inner join (select t.* from TITLE t where t.WORKER_TITLE='manager') x on 
 w.WORKER_ID=x.WORKER_REF_ID

--Write an SQL query to show only odd rows from a table. 
select w.*,ROW_NUMBER() over (order by w.WORKER_ID asc) as rownumer from worker w

select x.* from (select w.*,ROW_NUMBER() over (order by w.WORKER_ID asc) as rownumber from worker w) x
where x.rownumber%2=1;

--Write an SQL query to show only even rows from a table. 

select x.* from (select w.*,ROW_NUMBER() over (order by w.WORKER_ID asc) as rownumber from worker w) x
where x.rownumber%2=0;

--Write an SQL query to clone a new table from another table.
CREATE TABLE clone_title (
    WORKER_REF_ID INT NOT NULL,
    WORKER_TITLE VARCHAR(50),
    AFFECTED_FROM DATE,
    FOREIGN KEY (WORKER_REF_ID) REFERENCES WORKER(WORKER_ID)
);

insert into clone_title(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM)
SELECT *
FROM TITLE;

 --Write an SQL query to show the current date and time. 
 SELECT GETDATE() AS current_datetime;

 --Write an SQL query to show the top n (say 10) records of a table with Name and Designation. 
select top(5) w.first_name,t.WORKER_TITLE from worker w inner join TITLE t on w.WORKER_ID=t.WORKER_REF_ID
 -- Write an SQL query to determine the nth (say n=5) highest salary from a table. 
select w.* from worker w order by salary desc 
OFFSET 4 ROWS FETCH NEXT 1 ROW ONLY;
-- Write an SQL query to fetch the list of employees with the same salary



 --Write an SQL query to show the second highest salary from a table.
 select w.* from worker w order by salary desc 
OFFSET 1 ROWS FETCH NEXT 1 ROW ONLY;

--Write an SQL query to fetch the first 50% records from a table
select count(*)/2 from worker

select w.* from worker w order by worker_id asc
OFFSET 0 ROWS FETCH NEXT (select count(*)/2 from worker) ROW ONLY; 
 --Write an SQL query to fetch the departments that have less than five people in it.
 select count(*) as emp ,w.dept_name from worker w group by w.dept_name having count(*)<4

 --Write an SQL query to show all departments along with the number of people in there. 
 select dept_name,count(*) as num_emp from worker group by dept_name

 --Write an SQL query to show the last record from table.
select w.*,ROW_NUMBER() over (order by w.WORKER_ID asc) as rownum from worker w order by w.worker_id desc
OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY; 

--Write an SQL query to fetch the first row of a table. 
select top (1) w.* from worker w order by w.worker_id asc
--Write an SQL query to fetch the last five records from table.  
select top (5) w.* from worker w order by w.worker_id desc

 --Write an SQL query to print the name of employees having the highest salary in each department. 

select max(salary) as maxsalary ,dept_name from worker group by dept_name

select w.first_name,s.maxsalary,w.dept_name from worker w inner join (select max(salary) as maxsalary ,dept_name from worker group by dept_name) s
on w.dept_name=s.dept_name where s.maxsalary=w.salary

--Write an SQL query to fetch three max salaries from table.
