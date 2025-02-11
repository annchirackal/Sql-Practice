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
