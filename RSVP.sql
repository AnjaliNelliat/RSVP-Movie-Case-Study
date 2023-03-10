USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) 
FROM MOVIE;
-- Total no. of rows = 7997

select count(*) 
FROM GENRE;
-- Total no. of rows = 14662

select count(*) 
FROM RATINGS;
-- Total no. of rows = 7997

select count(*) 
FROM director_mapping;
-- Total no. of rows = 3867

select count(*) 
FROM role_mapping;
-- Total no. of rows = 15615

select count(*) 
FROM names;
-- Total no. of rows = 25735


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT Sum(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null,
       Sum(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null,
       Sum(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null,
       Sum(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS dp_null,
       Sum(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null,
       Sum(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null,
       Sum(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS wgi_null,
       Sum(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null,
       Sum(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS prodco_null
FROM   movie; 
-- From the result we could see that Country, worlwide_gross_income, languages & production_company have null values. 
-- In this worlwide_gross_income has highest null values(3724).


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


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total number of movies released each year.

SELECT year, COUNT(title) as number_of_movies
FROM movie
GROUP BY year;

-- Total 3052 movies released in 2017,
-- Total 2944 movies released in 2018 and 
-- Total 2001 movies released in 2019. 
-- Hence it can be infered that highest number of movies were produced in 2017.

-- Trend based on month

SELECT MONTH(date_published) AS month_num, COUNT(title) as number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;

-- In the month of March around 824 movies were produced, which is the highest. 
-- Around 800 movies were produced in the month of January, September and October. 


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT year, count(DISTINCT id) AS movies_2019
FROM movie
WHERE (country like '%USA%' OR country like '%India%') AND year =2019;

--  We used like operator because in the dataset many countries are given for a particular ID. Hence to get correct data we used 'like' operator.
-- From the result we can see that 1059 movies were produced either in USA or India in 2019.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre AS list_genres
FROM genre;

SELECT COUNT(DISTINCT genre) AS total_genres
FROM genre;

-- There are total 13 genres in the dataset.
/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, count(DISTINCT id) as total_movies
FROM movie m
INNER JOIN genre g
ON  m.id = g.movie_id
GROUP BY genre
ORDER BY total_movies DESC;

-- Drama genre had produced 4285 movies overall.
-- Comedy & Thriller are the other 2 genres which produced most movies overall. 


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


WITH one_genre AS(                                   -- A CTE is created to find the genre count for each movie_id.
SELECT movie_id, COUNT(genre) as genre_count
FROM genre
GROUP BY movie_id
)
SELECT COUNT(movie_id) AS total_one_genre           -- Here we are selecting only those genres whose count is 1 from the common table one_genre. 
FROM one_genre 
WHERE genre_count=1;

-- There are 3289 movies with only one genre.


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

SELECT genre, ROUND(avg(duration),2) as avg_duration
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;

-- Movies of genre 'Action' have highest average duration of 112.88 min.
-- Other top genres 'Drama' and 'Thriller' have average duration 106.77 min and 101.58 min respectively.

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

SELECT genre, COUNT(DISTINCT movie_id) AS movie_count,
DENSE_RANK() OVER(ORDER BY COUNT(movie_id) DESC) as genre_rank
FROM genre
GROUP BY genre;

-- 4285 movies were produced in 'Drama' genre, 2412 movies in 'Comedy' and 1484 movies in 'Thriller'
-- Thus,'Thriller' genre is at rank 3.
-- 'Family' and 'Others' are the genre in which least number of movies were produced. 


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

SELECT min(avg_rating) as min_avg_rating, 
       max(avg_rating) as max_avg_rating, 
       min(total_votes) as min_total_votes, 
       max(total_votes) as max_total_votes,
       min(median_rating) as min_median_rating,
       max(median_rating) as max_median_rating
FROM ratings;

-- Minimum average rating is 1 and maximum is 10. Same in the case of median ratings as well. 
-- Minimum total votes is 100 and maximum is 725138. 

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


SELECT title, avg_rating,
DENSE_RANK() OVER(ORDER BY avg_rating DESC) as movie_rank   -- Many movies will have same rating, so we have used DENSE_RANK() to get accurate ranking. 
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
limit 10;

-- Kirket & Love in Kilnerry are the top ranked movies with average rating 10.
-- Yes, Fan is there in top 10 movies with an average rating of 9.6. It is in rank 4. 

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

SELECT median_rating, COUNT(movie_id) as movie_count
FROM ratings
GROUP BY median_rating 
ORDER BY movie_count DESC;

-- Total 2257 movies produced have median rating 7, which tops the list.
-- Around 94 movies got the least rating with 1. 

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

SELECT production_company, COUNT(id) AS movie_count,
DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE avg_rating > 8 AND production_company IS NOT NULL
GROUP BY production_company;

-- Dream Warrior Pictures and National Theatre Live have produced 3 movies with an average rating greater than 8.

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

SELECT g.genre, count(m.id) AS movie_count
FROM movie m 
INNER JOIN genre g 
ON m.id = g.movie_id 
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE country LIKE '%USA%' AND year = 2017 AND MONTH(date_published)=3 AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;

-- Drama genre has highest number of movies released in March 2017 with more than 1000 votes. 
-- Which is followed by Comedy & Action with number of movies released in March 2017 as 9 and 8 respectively. 

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

SELECT m.title, r.avg_rating, g.genre
FROM movie m 
INNER JOIN ratings r 
ON m.id = r.movie_id
INNER JOIN genre g 
ON m.id = g.movie_id
WHERE avg_rating > 8 AND title like 'THE%'
GROUP BY title
ORDER BY avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(m.id) AS movie_count, r.median_rating 
FROM movie m 
INNER JOIN ratings r
ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01' AND r.median_rating =8
GROUP BY median_rating;

-- 361 movies released between 1 April 2018 and 1 April 2019 got a median rating of 8. 

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT languages, Sum(total_votes) AS total_votes
FROM movie m
INNER JOIN ratings r
ON  m.id = r.movie_id
WHERE  languages LIKE '%German%'
UNION                                                     -- We have used UNION operator because first we found of total for German & then for Italian. Then combined both the results. 
SELECT languages, SUM(total_votes) AS total_votes
FROM movie m
INNER JOIN ratings r
ON  m.id = r.movie_id
WHERE  languages LIKE '%Italian%'
ORDER  BY total_votes DESC; 

-- Yes, German language have 4421525 total votes and Italian have 2559540 votes.

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

SELECT Sum(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
       Sum(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
       Sum(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
       Sum(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names; 

-- Name column have no null values and known_for_movies have highest null values. 

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

WITH top_genres AS(
	SELECT genre, COUNT(ID) AS movies_count,
    RANK() OVER(ORDER BY COUNT(ID) DESC) AS genre_rank
	FROM movie  m
	INNER JOIN  genre g
    ON g.movie_id = m.id
    INNER JOIN ratings r
    ON r.movie_id = m.id
    WHERE avg_rating > 8
    GROUP BY genre limit 3 )
SELECT name AS director_name , Count(d.movie_id) AS movie_count
FROM director_mapping d
INNER JOIN genre g
using (movie_id)
INNER JOIN names n
ON n.id = d.name_id
INNER JOIN top_genres
using (genre)
INNER JOIN ratings
using (movie_id)
WHERE avg_rating > 8
GROUP BY name
ORDER BY movie_count DESC 
limit 3 ;

-- James Mangold with total 4 movies got is the top director and all the movies got average rating greater than 8.  
-- This is followed by Anthony Russo and Soubin Shahir with 3 movies each which also got average rating greater than 8. 
-- These 3 directors are good in the top 3 genres. 

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

SELECT name AS actor_name, COUNT(movie_id) AS movie_count
FROM role_mapping ro
INNER JOIN movie m
ON ro.movie_id = m.id
INNER JOIN ratings r
USING (movie_id)
INNER JOIN names n
ON n.id = ro.name_id
WHERE median_rating >=8 AND category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC
limit 2;

-- Mammootty & Mohanlal have a median rating >= 8. 

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

SELECT production_company, total_votes AS vote_count,
DENSE_RANK() OVER(ORDER BY total_votes DESC) AS prod_comp_rank
FROM movie m
LEFT JOIN ratings r
ON m.id = r.movie_id
WHERE production_company IS NOT NULL                             -- In the previous case we have seen that production_company have many null values, so we tried to get the count wih only non-null values. 
GROUP BY production_company 
LIMIT 3;

-- Marvel Studios gets the top rank with 551245 total votes. 

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

WITH top_actor AS(
	SELECT name AS actor_name, sum(total_votes) AS total_votes, COUNT(r.movie_id) AS movie_count,
	Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating                -- Considering weighted average with total votes in order to avoid clash with same ratings. 
    FROM movie m 
    LEFT JOIN ratings r 
    ON m.id = r.movie_id
    INNER JOIN role_mapping ro
    ON m.id = ro.movie_id
    INNER JOIN names AS n
    ON ro.name_id = n.id
    WHERE category = 'actor' AND country like '%India%'
    GROUP BY name 
    HAVING movie_count >= 5
    )
SELECT *,
RANK() OVER( ORDER BY actor_avg_rating DESC) AS actor_rank
FROM top_actor;

-- Vijay Sethupathi is the top actor with 8.42 average rating on total 5 movies, followed by Fahadh Faasil with average rating 7.99 for the movies released in India. 

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

WITH top_actress AS(
	SELECT name AS actress_name, total_votes, COUNT(r.movie_id) AS movie_count,
	Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating
    FROM movie m 
    LEFT JOIN ratings r 
    ON m.id = r.movie_id
    INNER JOIN role_mapping rm 
    ON m.id = rm.movie_id
    INNER JOIN names AS n
    ON rm.name_id = n.id
    WHERE category = 'actress' AND country like '%India%' AND languages like '%Hindi%'
    GROUP BY name 
    HAVING movie_count >= 3
    )
SELECT *,
RANK() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM top_actress
LIMIT 5;

-- Taapsee Pannu bags the top actress in Hindi movie with average rating 7.74 which is released in India. 
-- Second in the list is Kriti Sanon with 7.05 average rating. 

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH movies_thriller AS(
		SELECT title, avg_rating
        FROM movie m 
        LEFT JOIN ratings r 
        ON m.id = r.movie_id
        INNER JOIN genre g 
        USING (movie_id)
        WHERE genre = 'Thriller'
        ORDER BY avg_rating DESC
)
SELECT *,
	CASE 
     WHEN avg_rating > 8 THEN 'Superhit Movies'
     WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit Movies'
     WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
     ELSE 'Flop Movies'
     END AS movie_category
FROM movies_thriller;

-- Safe, Digbhayam, Dokyala Shot, etc are some of the Superhit Movies. 
-- Roofied, Bordo Bereliler Afrin, Krampus etc are among the Flop movies with very low rating.

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

SELECT genre, AVG(duration) AS avg_duration, 
	   SUM(AVG(duration)) OVER(ORDER BY genre rows between unbounded preceding and current row) AS running_total_duration,
       AVG(AVG(duration)) OVER(ORDER BY genre rows between unbounded preceding and current row) AS moving_avg_duration      -- Since no specific moving average has been mentioned, we have taken unbounded preceding average. 
FROM movie m 
JOIN genre g 
on m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;
       

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

WITH top_genres_per_year AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY year ORDER BY movie_count DESC) AS genre_rank
FROM
(
SELECT genre, year, COUNT(DISTINCT movie_id) AS movie_count
FROM genre g
INNER JOIN movie m
ON g.movie_id=m.id
GROUP BY genre,year
) movie_cnt
)

, top_movies_per_year_per_top3_genres AS
(
SELECT g.genre, m.year, m.title AS movie_name, m.worlwide_gross_income,
DENSE_RANK() OVER (PARTITION BY g.genre, year ORDER BY CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS  movie_rank
FROM movie m
JOIN genre g
ON m.id=g.movie_id
JOIN
top_genres_per_year tgpy
ON (g.genre=tgpy.genre AND m.year=tgpy.year AND tgpy.genre_rank<=3)
)
SELECT *
FROM top_movies_per_year_per_top3_genres
WHERE movie_rank<=5;


-- Top 3 Genres based on most number of movies

-- In the previous analysis we got that top 3 genres are Drama, Comedy & Thriller. 
-- The highest grossing income movies are also from these 3 top genres. 
-- The output is grouped in such a way that each genre, each year which are the top 5 gross income movies.
-- One movie is classified under more than 1 genre as we have seen before, so that is also reflected in the output. 
-- For example, Joker is classified as Drama & Thriller. So under Drama genre Joker is ranked 3rd but under Thiller genre it is ranked 1st. 



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

SELECT production_company, COUNT(movie_id) AS movie_count,
DENSE_RANK() OVER(ORDER BY COUNT(movie_id)DESC) AS prod_comp_rank
FROM   movie  m
LEFT JOIN ratings r
ON r.movie_id = m.id
WHERE  median_rating >= 8 AND production_company IS NOT NULL AND Position(',' IN languages) > 0
GROUP  BY production_company
ORDER  BY movie_count DESC
limit 2;

-- Star Cinema & Twentieth Century Fox are the top 2 production houses.

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

WITH superhit_drama_movies AS
(
select id, total_votes, avg_rating
FROM movie m
JOIN ratings r
ON (m.id=r.movie_id AND r.avg_rating>8)
JOIN genre g
ON (m.id=g.movie_id AND g.genre='drama')
),
actress_superhit_movies AS(
SELECT rm.name_id as actress_id, COUNT(sdm.id) as movie_count, AVG(avg_rating) as actress_avg_rating, SUM(total_votes) as total_votes
FROM superhit_drama_movies sdm
JOIN role_mapping rm
ON (sdm.id=rm.movie_id AND rm.category='actress')
group by rm.name_id
)
,final_rank_list AS
(SELECT n.name as actress_name, total_votes, movie_count, actress_avg_rating,
DENSE_RANK() OVER(ORDER BY movie_count desc) AS actress_rank
FROM actress_superhit_movies asm
JOIN names n
ON (asm.actress_id=n.id))

select *
FROM final_rank_list
where actress_rank<=3;

-- If we consider only number of super hit movies for ranking actress, top 3 rank will cover around 120+ actresses since number of super hit movies are equal for them. 
-- We should consider average rating and total votes to filter out more and come up with a finer list of top 3 actresses.
-- As in the question, it is mentioned to find top 3 actresses based on number of Super Hit movies, we have ranked the actress based on that. 
-- Thus we got Parvathy Thiruvothu, Susan Brown & Amanda Lawrence as top 3 actress with total Superhit movie count as 2. 

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
-- Type you code below:

WITH next_date_published AS
(
	SELECT dm.name_id, name, dm.movie_id, duration, avg_rating, total_votes, date_published,
	Lead(date_published) OVER(partition BY dm.name_id ORDER BY date_published,movie_id ) AS next_date_published
	FROM director_mapping AS dm
	INNER JOIN names n
	ON n.id = dm.name_id
	INNER JOIN movie m
	ON m.id = dm.movie_id
	INNER JOIN ratings r
	ON r.movie_id = m.id )
    , top_director AS
(
	SELECT *,
	Datediff(next_date_published, date_published) AS date_difference
	FROM   next_date_published
)
SELECT name_id AS director_id, name AS director_name, Count(movie_id) AS number_of_movies, 
		Round(Avg(date_difference)) AS avg_inter_movie_days,
		Round(Avg(avg_rating),2) AS avg_rating, 
        Sum(total_votes) AS total_votes,
		Min(avg_rating) AS min_rating,
		Max(avg_rating) AS max_rating,
		Sum(duration) AS total_duration
 FROM top_director
 GROUP BY director_id
 ORDER BY Count(movie_id) DESC
 limit 9;

-- Andrew Jones & A.L.Vijay has directed 5 movies with average inter movie days of less that 200 days. 
-- But when the average inter movie days is less than 200 days, the average rating is less than 4.0
-- From the analysis it can be infered that when the average inter movie days is more than 200 days, the average rating is above 5.0
-- This means when the time gao between 2 movies directed by a director is more, the qulaity of movie improves and gets better rating. 