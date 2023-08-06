CREATE Table applestore_description_combined AS

SELECT* from appleStore_description1
union all
SELECT* from appleStore_description2
union all
SELECT* from appleStore_description3
union all
SELECT* from appleStore_description4


**Exploratory Data Ananlysis**

--No. of unique apps

SElect Count(distinct id) as UniqueAppIDs
From AppleStore

SElect Count(distinct id) as UniqueAppIDs
From applestore_description_combined

--Check for missing values

SElect count(*) as MissingValues
from  AppleStore
where track_name is null or user_rating is null or prime_genre is NULL

SElect count(*) as MissingValues
from  applestore_description_combined
where app_desc is null

--Apps per genre 
select prime_genre, count(*) as NumApps
from AppleStore
group by prime_genre
Order by NumApps desc

--Overview of App Rating
select min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
From AppleStore

--Distribution of App Prices
select 
	(price/2)*2 as PriceBinStart,
    (price/2)*2 +2 as PriceBinEnd,
    count(*) as NumApps
From AppleStore
group by PriceBinStart
order by PriceBinStart


**Data Analysis** 

--Do paid apps have higher rating than free apps?
select CASE
		when price>0 then 'Paid'
        else 'Free'
	end as App_Type,
    avg(user_rating) as Avg_Rating
from  AppleStore
group by App_Type

--Do apps that support more languages have higher ratings
select CASE
		when lang_num<10 then '<10 Languages'
        when lang_num between 10 and 30 then '10-30 Languages'
        else '>30 Languages'
	end as language_bucket,
    avg(user_rating) as Avg_Rating
from AppleStore
group by language_bucket
order by Avg_Rating desc

--Checking genres with low ratings
select prime_genre,
		avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating ASC
limit 10

--Does App description length and User Rating have any correlation?
SELECT CASE
		when length(b.app_desc)<500 then 'Short'
        when length(b.app_desc) between 500 and 1000 then 'Medium'
        else 'Long'
	end as description_length_bucket,
    avg(a.user_rating) as Average_Rating
FROM
	AppleStore as a
JOIN
	applestore_description_combined as b
ON
	a.id=b.id
group by description_length_bucket
order by Average_Rating desc

--Check top rated apps fro each genre
select 
	prime_genre,
    track_name,
    user_rating
FROM (
      select 
      prime_genre,
      track_name,
      user_rating,
      RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
      FROM
      AppleStore
     ) AS a 
WHERE
a.rank=1


--**Recommendations**
-- 1) Paid apps have better Ratings
-- 2) Apps supporting 10-30 Languages have better ratings(best to cater to a target audience)
-- 3) Finance and Book apps have low ratings 
-- 4) A new app should aim for >3.5 rating 
-- 5) Games and Entertainment industry have very high competition

