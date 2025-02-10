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
