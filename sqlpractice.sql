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
