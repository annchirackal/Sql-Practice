/*
- start @6.56 am 
- end @ 7.15 am
- new : select with out using join
*/
select  c.company_code,c.founder,
(select count(*) from Lead_Manager where company_code=c.company_code  ) ,
(select count(*) from Senior_Manager where company_code=c.company_code  ),
(select count(*) from Manager where company_code=c.company_code  ),
(select count(*) from Employee  where company_code=c.company_code  )


from  Company as c order by c.company_code;

/*
Enter your query here.
start @6:54 am
end @ 7:05 am
*/

select CONCAT(Name,"(",left(Occupation,1),")")
from OCCUPATIONS order by name asc;

select 
concat("There are a total of ",count(Occupation)," ",lower(Occupation),'s.')
from OCCUPATIONs
group by Occupation
order by count(Occupation)


/*
Enter your query here.
Start @6:35 am
end @ 6:50 am
*/

SELECT round(m.LAT_N ,4)
FROM (
    SELECT s1.LAT_N, 
           ROW_NUMBER() OVER (ORDER BY s1.LAT_N) AS row_n, 
           COUNT(*) OVER () AS total_rows
    FROM STATION s1
) m
WHERE m.row_n = CEIL(m.total_rows / 2);

/*
Enter your query here.
group_concat and recursive   - 
*/
WITH RECURSIVE Numbers(n) AS (
    SELECT 2
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 1000  -- Change 1000 to your upper limit
)
SELECT GROUP_CONCAT(n SEPARATOR '&') 
FROM Numbers
WHERE NOT EXISTS (
    SELECT 1 
    FROM Numbers AS divs 
    WHERE divs.n < Numbers.n AND divs.n > 1 
    AND Numbers.n % divs.n = 0
);

select 
round(SQRT( POWER( ( MAX(LAT_N) - MIN(LAT_N) ), 2 ) + POWER( ( MAX(LONG_W) - MIN(LONG_W) ),2 )
) ,4)
FROM STATION;

/*
Enter your query here.
start at 7 :00 AM 
end at 7:30 AM
*/


SELECT 
    CASE WHEN gd.Grade >= 8
        THEN st.Name
    END AS Names,
    gd.Grade,
    st.Marks
FROM Students as st
LEFT JOIN Grades gd
 ON  st.Marks BETWEEN gd.Min_Mark AND gd.Max_Mark
 ORDER BY gd.Grade DESC,
 (CASE WHEN gd.Grade >= 8 THEN st.Name END) ASC,
 (CASE WHEN gd.Grade < 8 THEN st.Marks END) ASC;

select s.user_id,
        round(avg(if(c.action="confirmed",1,0)),2) as confirmation_rate
from Signups as s 
left join Confirmations as c on s.user_id= c.user_id
 group by user_id;

with date_diff as(
  SELECT 
        Task_ID, 
        Start_Date, 
        End_Date, 
        DATEADD(day,-ROW_NUMBER() OVER (ORDER BY Start_Date)+1,Start_date) AS Project_Group
    FROM Projects)
    
,result as(
select min(Start_Date) start_date,
max(End_Date) end_date,
Project_Group,
datediff(day,min(Start_Date),max(End_Date)) as date_diff
from date_diff
group by Project_Group)

select start_date,end_date
from result 
order by date_diff asc ,start_date asc


------------------------
SELECT DISTINCT p.candidate_id FROM candidates p
inner join candidates t on t.candidate_id = p.candidate_id
inner join candidates s on s.candidate_id = p.candidate_id
where s.skill ='PostgreSQL' and t.skill = 'Tableau' and p.skill ='Python';

with trades_count as (
select
u.city,
count(t.order_id) as total_orders,
rank() over( order by count(t.order_id) desc) as rank_val
from trades t
inner JOIN users u on u.user_id = t.user_id
where status ='Completed'
group by u.city

)

SELECT city,
       total_orders
from trades_count
WHERE rank_val <=3 order by total_orders desc;


-- create a cte for company slary
-- agregate depaerment slary and compare with cte

with company_average as
(
SELECT  to_char(payment_date,'MM-YYYY') as paydate,
       avg(amount) as avg_salary
from  salary 
group by to_char(payment_date,'MM-YYYY')
)

SELECT 
  department_id,
  to_char(payment_date,'MM-YYYY') as payment_date,
case WHEN avg(amount) > avg_salary then 'higher'
     when avg(amount) <avg_salary then 'lower'
     when avg(amount) = avg_salary then 'same'
  end as  comparison
from employee e
inner join salary d 
  on e.employee_id = d.employee_id
inner join company_average ca
   on paydate = to_char(payment_date,'MM-YYYY') 
group by department_id, to_char(payment_date,'MM-YYYY'),avg_salary;

with user_count as (
SELECT 
user_id,
count(tweet_id) as tweet_bucket
from tweets where to_char(tweet_date,'YYYY') ='2022'
group by user_id)

SELECT
tweet_bucket,
count(user_id) as users_num
from user_count
group by tweet_bucket
order by count(user_id) desc


SELECT 
  age_bucket,
  ROUND(SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END) * 100.0 
        / NULLIF(SUM(time_spent), 0), 2) AS open_perc,
  ROUND(SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END) * 100.0 
        / NULLIF(SUM(time_spent), 0), 2) AS send_perc
FROM 
  age_breakdown a
JOIN 
  activities act ON act.user_id = a.user_id
  where activity_type in ('open','send')
GROUP BY 
  age_bucket;

SELECT ROUND(sum(item_count * order_occurrences)::numeric / sum(order_occurrences), 1)
FROM items_per_order;


with ranked_products as(
SELECT 
      category,
      product,
      sum(spend) as total_spend,
      rank() over ( partition by category order by sum(spend) desc) as product_rank
      from product_spend
      where to_char(transaction_date,'YYYY') = '2022'
      group by category , 
                product
      
  )
select 
      category,
      product,
      total_spend

from ranked_products where product_rank <=2;

SELECT sum(case when call_category is null or call_category ='n/a' then 1 end)::float/count(*)*100

FROM callers;

SELECT page_id
FROM pages
where page_id not in ( select DISTINCT page_id from page_likes)
;

with ordered_data as(
SELECT measurement_value,measurement_time,
row_number() over(PARTITION by date(measurement_time) order by measurement_time asc )
from measurements
)


SELECT
date(measurement_time)  measurement_day,
sum (case when row_number:: int % 2  = 1 then measurement_value else 0 end ) as odd_sum,

sum (case when row_number :: int % 2  = 0 then measurement_value else 0 end) as even_sum
from ordered_data
group by date(measurement_time) 
order by date(measurement_time);

SELECT user_id,tweet_date,
round(avg(tweet_count) over(partition by user_id  order by tweet_date
rows BETWEEN 2 PRECEDING and current row
),2) as rolling_average
from tweets;

SELECT 
  deals.employee_id,
  CASE 
    WHEN SUM(deals.deal_size) <= employee.quota 
      THEN employee.base + (employee.commission * SUM(deals.deal_size)) -- #1
    ELSE employee.base + (employee.commission * employee.quota) + 
      ((SUM(deals.deal_size) - employee.quota) * employee.commission * employee.accelerator) -- #2
  END AS total_compensation
FROM deals
INNER JOIN employee_contract AS employee
  ON deals.employee_id = employee.employee_id
GROUP BY deals.employee_id, employee.quota, employee.base, employee.commission, employee.accelerator
ORDER BY total_compensation DESC, deals.employee_id;

with ranked_transaction as(
SELECT 
USER_id ,
spend,
transaction_date,
rank() over(PARTITION by user_id order by transaction_date asc) as rank_users


FROM transactions)

SELECT USER_id ,
spend,
transaction_date
from ranked_transaction where rank_users =3;

WITH company_avg AS ( -- CTE from Step 1
  SELECT 
    payment_date,
    AVG(amount) AS co_avg_salary
  FROM salary
  WHERE payment_date = '03/31/2024 00:00:00'
  GROUP BY payment_date
)
, dept_avg AS ( -- CTE from Step 2
  SELECT
    e.department_id,
    s.payment_date,
    AVG(s.amount) AS dept_avg_salary
  FROM salary AS s
  INNER JOIN employee AS e
    ON s.employee_id = e.employee_id
  WHERE s.payment_date = '03/31/2024 00:00:00'
  GROUP BY e.department_id, s.payment_date
)

SELECT
  d.department_id,
  TO_CHAR(d.payment_date, 'MM-YYYY') AS payment_date,
  CASE  
    WHEN d.dept_avg_salary > c.co_avg_salary THEN 'higher'
    WHEN d.dept_avg_salary < c.co_avg_salary THEN 'lower'
    ELSE 'same'
  END AS comparison
FROM dept_avg AS d
INNER JOIN company_avg AS c
  ON d.payment_date = c.payment_date;

SELECT part,assembly_step FROM parts_assembly where finish_date is null;
--- get all user_id from emails -- join with text to get only confirmed emails 
---- where siup_action = comfirmed 

with joined_data as (
select user_id ,
text_id,
signup_action
from emails e
left join texts T 

on t.email_id = e.email_id

)

select 
 ROUND(
    (SUM(CASE WHEN signup_action = 'Confirmed' THEN 1 ELSE 0 END)::float 
     / COUNT(DISTINCT user_id)::float)::numeric, 
    2)
from joined_data;

SELECT max(salary) from employee where salary <(select max(salary) from employee );


  
