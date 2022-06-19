-- Overall dataset
SELECT
*
FROM
PortfolioProject..USvideos$



-- Looking at what category produces the most content in 2017 & 2018 
SELECT
category_id,
COUNT(category_id) AS amount_of_videos_in_category
FROM
PortfolioProject..USvideos$
GROUP BY
category_id
ORDER BY 2 DESC
-- Top 3 categories are Entertainment, Music and Howto & Style types of videos



-- Looking at which channel produced the highest amount of views on which date and video produced
SELECT
DISTINCT channel_title, title, views,
ROW_NUMBER() OVER(PARTITION BY channel_title ORDER BY views DESC) row_numb
FROM
PortfolioProject..USvideos$
ORDER BY 3 DESC
-- Most viewed channel is ChildishGambino and the most viewed video is 'This is America'



--USING CTE to remove repeated rows of the same video title 
-- To take note: The WITH() statement requires the same number of values as the SELECT in the AS() function
WITH highest_views (channel_title, title, views, row_numb)
AS
(
SELECT channel_title, title, views, 
ROW_NUMBER() OVER(PARTITION BY channel_title ORDER BY views DESC) row_numb
FROM
PortfolioProject..USvideos$
)
SELECT 
*
FROM
highest_views
WHERE
row_numb = 1
ORDER BY
views DESC

-- Creating View to store data for later visualizations
CREATE VIEW highest_views AS
SELECT channel_title, title, views, 
ROW_NUMBER() OVER(PARTITION BY channel_title ORDER BY views DESC) row_numb
FROM
PortfolioProject..USvideos$



-- Looking at views vs likes
-- Showing the likelihood of people liking the video based on the content produced
SELECT
channel_title, title, category_id, views, likes, (likes/views)*100 AS likes_percentage,
ROW_NUMBER() OVER(PARTITION BY channel_title ORDER BY views DESC) row_numb
FROM
PortfolioProject..USvideos$
GROUP BY
channel_title, title, category_id, views, likes
ORDER BY 6 DESC
-- Most liked video based on the percentage of likes vs viewership is Bruno Mars, 'Finesse (Remix) - Feat. Cardi B'

-- TEMP Table (Similar usage as CTE)
DROP TABLE IF EXISTS #MostLikedVideo 
CREATE TABLE #MostLikedVideo
(
channel_title nvarchar(255),
title nvarchar(255),
category_id numeric,
views numeric,
likes numeric,
likes_percentage numeric,
row_numb numeric
)
INSERT INTO #MostLikedVideo
SELECT
channel_title, title, category_id, views, likes, (likes/views)*100 AS likes_percentage,
ROW_NUMBER() OVER(PARTITION BY channel_title ORDER BY views DESC) row_numb
FROM
PortfolioProject..USvideos$
GROUP BY
channel_title, title, category_id, views, likes
ORDER BY 6 DESC

SELECT 
*
FROM
#MostLikedVideo
WHERE
row_numb = 1
ORDER BY
likes_percentage DESC
-- The video with the highest likes vs views percentage is Desimpedidos, 'CRISTIANO RONALDO AND FRED , THE GREAT MEETING'

-- Creating View to store data for later visualizations
CREATE VIEW MostLikedVideo AS
SELECT
channel_title, title, category_id, views, likes, (likes/views)*100 AS likes_percentage,
ROW_NUMBER() OVER(PARTITION BY channel_title ORDER BY views DESC) row_numb
FROM
PortfolioProject..USvideos$
GROUP BY
channel_title, title, category_id, views, likes
-- ORDER BY 6 DESC



-- Looking at views vs dislikes
-- Showing the likelihood of people disliking the video based on the content produced
SELECT
channel_title, title, category_id, views, dislikes, (dislikes/views)*100 AS dislikes_percentage,
ROW_NUMBER() OVER(PARTITION BY channel_title ORDER BY views DESC) row_numb
FROM
PortfolioProject..USvideos$
GROUP BY
channel_title, title, category_id, views, dislikes
ORDER BY 6 DESC
-- Most disliked video based on the percentage of dislikes vs viewership is Daily Caller, 'PSA from Chairman of the FCC Ajit Pai'

-- TEMP Table (Similar usage as CTE)
DROP TABLE IF EXISTS #MostDislikedVideo 
CREATE TABLE #MostDislikedVideo
(
channel_title nvarchar(255),
title nvarchar(255),
category_id numeric,
views numeric,
dislikes numeric,
dislikes_percentage numeric,
row_numb numeric
)
INSERT INTO #MostDislikedVideo
SELECT
channel_title, title, category_id, views, dislikes, (dislikes/views)*100 AS dislikes_percentage,
ROW_NUMBER() OVER(PARTITION BY channel_title ORDER BY views DESC) row_numb
FROM
PortfolioProject..USvideos$
GROUP BY
channel_title, title, category_id, views, dislikes
ORDER BY 6 DESC

SELECT 
*
FROM
#MostDislikedVideo
WHERE
row_numb = 1
ORDER BY
dislikes_percentage DESC
-- The video with the highest dislikes vs views percentage is still Daily Caller, 'PSA from Chairman of the FCC Ajit Pai'

-- Creating View to store data for later visualizations
CREATE VIEW MostDislikedVideo AS
SELECT
channel_title, title, category_id, views, dislikes, (dislikes/views)*100 AS dislikes_percentage,
ROW_NUMBER() OVER(PARTITION BY channel_title ORDER BY views DESC) row_numb
FROM
PortfolioProject..USvideos$
GROUP BY
channel_title, title, category_id, views, dislikes
-- ORDER BY 6 DESC



-- Looking at the trending video with the highest amount of views vs comments 
-- Using CTE to clear the repeated data
-- To take note: The WITH() statement requires the same number of values as the SELECT in the AS() function
WITH highest_comments (channel_title, title, views, comment_count, row_numb)
AS
(
SELECT channel_title, title, views, comment_count, 
ROW_NUMBER() OVER(PARTITION BY channel_title ORDER BY views DESC) row_numb
FROM
PortfolioProject..USvideos$
)
SELECT 
*
FROM
highest_comments
WHERE
row_numb = 1
ORDER BY
comment_count DESC
-- The video with the highest comments is Logan Paul Vlogs, 'So Sorry.'

-- Creating View to store data for later visualizations
CREATE VIEW highest_comments AS
SELECT channel_title, title, views, comment_count, 
ROW_NUMBER() OVER(PARTITION BY channel_title ORDER BY views DESC) row_numb
FROM
PortfolioProject..USvideos$



-- Looking at the categories of the top viewed videos
WITH categories (trending_date, category_id, title, channel_title, tags, views, row_numb)
AS
(
SELECT trending_date, category_id, title, channel_title, tags, views,
ROW_NUMBER() OVER(PARTITION BY title ORDER BY views DESC) row_numb
FROM 
PortfolioProject..USvideos$
)
SELECT
*
FROM 
categories
WHERE
row_numb = 1
ORDER BY
views DESC
-- Music & Entertainment is top ranking in terms of viewership

-- Creating View to store data for later visualizations
CREATE VIEW categories AS
SELECT trending_date, category_id, title, channel_title, tags, views,
ROW_NUMBER() OVER(PARTITION BY title ORDER BY views DESC) row_numb
FROM 
PortfolioProject..USvideos$






