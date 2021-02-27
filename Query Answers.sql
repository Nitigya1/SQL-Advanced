USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:
-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) Total_rows from director_mapping;
select count(*) Total_rows from movie;
select count(*) Total_rows from genre;
select count(*) Total_rows from role_mapping;
select count(*) Total_rows from names;
select count(*) Total_rows from ratings;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
 
select 
    sum(case when id is null then 1 else 0 end) as id_nulls, 
    sum(case when title is null then 1 else 0 end) as title_nulls, 
    sum(case when year is null then 1 else 0 end) as year_nulls,
    sum(case when date_published is null then 1 else 0 end) as date_published_nulls,
    sum(case when duration is null then 1 else 0 end) as duration_nulls, 
    sum(case when COUNTRY is null then 1 else 0 end) as country_nulls, 
    sum(case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income_nulls, 
    sum(case when languages is null then 1 else 0 end) as languages_nulls, 
    sum(case when production_company is null then 1 else 0 end) as production_company_nulls
from movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+
*/

/*Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- No. of movies released each year
select Year, 
	   count(id) number_of_movies 
from   movie 
group by year;

-- No. of movies released each month  
select Month(date_published) month_num, 
       count(id) number_of_movies 
from   movie 
group by Month(date_published) 
order by Month(date_published);

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select count(id) 
from movie 
where year = 2019 
and country = 'India' 
or country = 'USA' ;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct(genre) from genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre 
from genre 
group by genre 
order by count(movie_id) desc 
limit 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

with movie_count as
(select movie_id from genre group by movie_id having count(movie_id) = 1)
select count(*) from movie_count ;


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre, avg(duration) avg_duration
from genre 
inner join movie 
on id = movie_id 
group by genre;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with genre_ranking as
-- fetching the rank of Thriller genre movies
(select genre, count(movie_id) movie_count, rank() over( order by count(movie_id) desc) genre_rank 
from genre 
group by genre)
select * from genre_ranking where genre = 'Thriller';

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select min(avg_rating) min_avg_rating,
	   max(avg_rating) max_avg_rating, 
       min(total_votes) min_total_votes, 
       max(total_votes) max_total_votes, 
       min(median_rating) min_median_rating, 
       max(median_rating) max_median_rating 
from   ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select title, avg_rating, rank() over( order by avg_rating desc) movie_rank 
from ratings r
inner join movie m
on m.id = r.movie_id
limit 10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating, 
	   count(movie_id) movie_count 
from 	ratings 
group by median_rating 
order by median_rating;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company, 
	   count(movie_id) movie_count, 
       dense_rank() over (order by count(movie_id) desc) prod_company_rank
from   ratings r 
inner join movie m
on r.movie_id = m.id
where avg_rating > 8
and production_company is not null
group by production_company 
limit 1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre, count(g.movie_id) movie_count 
from 	genre g 
inner join ratings r 
on r.movie_id = g.movie_id 
inner join movie m
on m.id = r.movie_id
where year = 2017 
and month(date_published) = 3 
and total_votes > 1000
and country like 'USA'
group by genre
order by movie_count desc;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select title , avg_rating , genre 
from movie m 
inner join ratings r
on r.movie_id = m.id
inner join genre g
on g.movie_id = r.movie_id 
where title like 'The%'
and avg_rating > 8
order by avg_rating desc;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

Select count(m.title) as num_of_movies
from movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
where date_published between '2018-04-01' and '2019-04-01' and r.median_rating = 8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select sum(total_votes) total_votes, languages
from   ratings r 
inner join movie m 
on m.id = r.movie_id 
group by Country
having country = 'Germany' 
or Country = 'Italy'; 

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select 
    sum(case when name is null then 1 else 0 end) as name_nulls, 
    sum(case when height is null then 1 else 0 end) as height_nulls, 
    sum(case when date_of_birth is null then 1 else 0 end) as date_oF_birth_nulls,
    sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_nulls
from names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genre AS
( -- fetching the top 3 genres based on movie_count
SELECT genre FROM
(SELECT genre,
		COUNT(r.movie_id) AS number_of_movie,
		RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM movie AS m
INNER JOIN genre AS g
ON m.id = g.movie_id
inner join ratings r
on r.movie_id = m.id
where avg_rating > 8
GROUP BY genre) AS top_three
WHERE genre_rank <= 3),
director_list as 
( -- fetching directors list with movie_count
select n.name as director_name, count(id) as movie_count, g.genre
from names as n 
inner join director_mapping as dm 
on n.id = dm.name_id 
inner join genre as g 
on g.movie_id = dm.movie_id 
inner join ratings as r 
on g.movie_id = r.movie_id 
where avg_rating > 8 
group by director_name, genre
order by movie_count desc)
select dl.director_name,
	   dl.movie_count 
from director_list as dl
inner join top_3_genre as tg
on tg.genre = dl.genre
group by tg.genre 
order by dl.movie_count desc;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select name,count(rm.movie_id)movie_count
from names n 
inner join role_mapping rm 
on rm.name_id = n.id 
inner join ratings r
on r.movie_id = rm.movie_id
where category = 'Actor'
and median_rating >= 8
group by name 
order by count(rm.movie_id) desc
limit 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company , total_votes vote_count, rank()over(order by total_votes desc) prod_comp_rank
from movie m 
inner join ratings r
on r.movie_id = m.id
group by production_company
order by vote_count desc
limit 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


select name actor_name, 
	   sum(total_votes) total_votes,
	   count(rm.movie_id) movie_count, 
	   round(sum(avg_rating*total_votes)/sum(total_votes), 2) actor_avg_rating,
	   rank() over (order by round(sum(avg_rating*total_votes)/sum(total_votes), 2) desc , SUM(total_votes) desc) actor_rank
from  names n
inner join role_mapping rm 
on n.id = rm.name_id
inner join movie m
on m.id = rm.movie_id
inner join ratings r 
on m.id = r.movie_id
where country like 'India' 
and rm.category like 'Actor'
group by n.id, n.name
having movie_count >= 5;
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name actress_name, 
	   sum(total_votes) total_votes,
	   count(rm.movie_id) movie_count, 
	   round(sum(avg_rating*total_votes)/sum(total_votes), 2) actress_avg_rating,
	   rank() over (order by round(sum(avg_rating*total_votes)/sum(total_votes), 2) desc , SUM(total_votes) desc) actress_rank
from  names n
inner join role_mapping rm 
on n.id = rm.name_id
inner join movie m
on m.id = rm.movie_id
inner join ratings r 
on m.id = r.movie_id
where country like 'India' 
and languages like 'Hindi'
and rm.category like 'Actress'
group by n.id, n.name
having movie_count >= 3;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

with avg_rating_movies as
(
select title, avg_rating 
from movie m 
inner join genre g 
on g.movie_id = m.id 
inner join ratings r 
on r.movie_id = g.movie_id 
where genre = 'Thriller'
order by avg_rating desc
) 
select *,
		CASE
			when avg_rating > 8 then 'Superhit movies'
			when avg_rating > 7 then 'Hit movies'
			when avg_rating > 5 then 'One-time-watch-movies'
		else 'Flop movies'
end as Movie_Hit_group 
from avg_rating_movies ; 


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

with avg_duration as 
( 
select genre , round(avg(duration),2) as avg_duration 
from genre g
inner join movie m 
on m.id = g.movie_id 
group by genre
order by avg_duration desc)
select * ,
		sum(avg_duration) over w1 as running_total_duration,
        avg(avg_duration) over w2 as moving_avg_duration
from avg_duration
window w1 as (order by avg_duration desc rows unbounded preceding),
w2 as (order by avg_duration desc rows 3 preceding); 

-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genre AS
( -- fetching the top 3 genres based on movie_count
SELECT genre FROM
(SELECT genre,
		COUNT(movie_id) AS number_of_movie,
		RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM movie AS m
INNER JOIN genre AS g
ON m.id = g.movie_id
GROUP BY genre) AS top_three
WHERE genre_rank <= 3) , 
top_5_movies as
(  -- top 5 movies based on the gross income
SELECT * FROM
(SELECT g.genre,
		m.year,
		m.title  movie_name,
		worlwide_gross_income,
		DENSE_RANK() OVER(PARTITION BY genre ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM movie AS m  
INNER JOIN genre AS g
ON m.id = g.movie_id
ORDER BY genre) AS top_five
WHERE movie_rank<= 5
)                           
SELECT tm.genre,
	   tm.year,
       tm. movie_name,
       worlwide_gross_income,
       movie_rank FROM
top_5_movies AS tm
INNER JOIN top_3_genre AS tg
ON tm.genre = tg.genre
order by tm.year desc ;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company, count(r.movie_id), rank() over(order by count(movie_id) desc ) prod_comp_rank
from movie m
inner join ratings r 
on r.movie_id = m.id 
where r.median_rating >= 8
and position(',' in m.languages) > 0
and production_company is not null
group by m.production_company
order by count(movie_id) desc
limit 2 ;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name actress_name, 
	   sum(total_votes) total_votes,
	   count(rm.movie_id) movie_count, 
	   round(sum(avg_rating*total_votes)/sum(total_votes), 2) actor_avg_rating,
	   rank() over (order by count(rm.movie_id) desc) actress_rank
from  names n
inner join role_mapping rm 
on n.id = rm.name_id
inner join movie m
on m.id = rm.movie_id
inner join ratings r 
on m.id = r.movie_id
inner join genre g
on g.movie_id = m.id 
where avg_rating > 8  
and genre like 'Drama'
and rm.category like 'Actress'
group by n.name
limit 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type your code below:

with director_list as 
(
select name_id  director_id,
	   name director_name , 
       count(dm.movie_id) number_of_movies,
       avg(avg_rating) avg_rating,
       sum(total_votes) total_votes,
       min(avg_rating) min_rating,
       max(avg_rating) max_rating,
       sum(duration) total_duration
from movie m
inner join director_mapping dm
on m.id = dm.movie_id
inner join names n
on n.id = dm.name_id
inner join ratings r
on r.movie_id = m.id 
group by name
order by count(movie_id) desc
limit 9),
date_difference as 
(
select name, director_id, 
	   DATEDIFF(date_published,nxt_publish_date) inter_movie_days
from (select n.id as director_id,name,date_published,lead(date_published,1) over( partition by name order by date_published desc) as nxt_publish_date
			FROM  names  n 
            INNER JOIN director_mapping  dm 
			ON n.id = dm.name_id 
			INNER JOIN movie m 
			ON dm.movie_id = m.id
			ORDER BY DATEDIFF(date_published,nxt_publish_date)desc ) as inter_movie_days
)
select dl.director_id,
	   dl.director_name,
       dl.number_of_movies,
       round(avg(dd.inter_movie_days)) avg_inter_movie_days,
       dl.avg_rating,
       dl.total_votes,
       dl.min_rating,
       dl.max_rating,
       dl.total_duration
from date_difference AS dd
inner join director_list as dl 
ON dd.director_id = dl.director_id
group by dl.director_name
ORDER BY dl.number_of_movies DESC;


