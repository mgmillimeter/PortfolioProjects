-- LONDON BIKE SHARING ANALYSIS:
-- Analyzing bike share data to predict usage patterns and optimize operations.
-- Dataset includes timestamps, weather conditions, and usage details.

-------------------------------------------------------------------------------------------------

/* DATA CLEANING */
-- This query selects data from an existing table and extracts specific columns while transforming the data.
-- It then creates a new table with the extracted columns.

-- SELECT statement retrieves data from the existing table and transforms it as necessary.
SELECT 
    CAST(timestamp AS date) AS date_column,  -- Extracts the date portion from the timestamp and renames the column
    CONVERT(VARCHAR, timestamp, 108) AS time_column,  -- Extracts the time portion from the timestamp and renames the column
    DATENAME(dw, timestamp) AS day_of_week,  -- Extracts the day of the week from the timestamp and renames the column
    cnt AS count_new_bike_shares,  -- Renames the column for clarity
    t1 AS temp_actual,  -- Renames the column for clarity
    t2 AS temp_feels,  -- Renames the column for clarity
    hum AS humidity,  -- Renames the column for clarity
    wind_speed,  -- Leaves the column name unchanged
    weather_code AS weather,  -- Renames the column for clarity
    is_holiday,  -- Leaves the column name unchanged
    is_weekend,  -- Leaves the column name unchanged
    season  -- Leaves the column name unchanged
-- INTO clause creates a new table with the extracted data.
INTO
    PortfolioProject.dbo.new_london_bike_sharing  -- Specifies the name of the new table to be created in the specified schema
-- FROM clause specifies the source table from which data is selected.
FROM 
    PortfolioProject.dbo.london_bike_sharing;  -- Specifies the source table containing the original data


-------------------------------------------------------------------------------------------------


/* EXPLORING DATA AND ANALYZING PATTERN FOR INSIGHTS */

--1. THE BUSIEST DAY OF THE WEEK - PEAK BIKING ACTIVITY IN DESCENDING ORDER
-- Select the day of the week and calculate the total count of new bike shares for each day

SELECT
    day_of_week,
    SUM(count_new_bike_shares) AS total_bike_shares -- Alias the total count as "total_bike_shares"
FROM
    PortfolioProject.dbo.new_london_bike_sharing -- Specify the table containing the bike sharing data
GROUP BY
    day_of_week -- Group the results by day of the week
ORDER BY
    total_bike_shares DESC -- Order the results in descending order based on the total bike shares
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY; -- Retrieve only the first row after ordering to find the busiest day


--2. TOTAL COUNT OF NEW BIKE SHARES FOR EACH SEASON.
-- This query calculates the total count of new bike shares for each season and orders them by total bike shares in descending order.

SELECT
    -- Selects the season based on the numeric value of the "season" column
    CASE
        WHEN season = 0 THEN 'Spring'
        WHEN season = 1 THEN 'Summer'
        WHEN season = 2 THEN 'Fall'
        WHEN season = 3 THEN 'Winter'
    END AS season,
    -- Calculates the total count of new bike shares for each season
    SUM(count_new_bike_shares) AS total_bike_shares
FROM
    -- Specifies the table to select data from
    PortfolioProject.dbo.new_london_bike_sharing
GROUP BY 
    -- Groups the results by the numeric value of the "season" column
    season
ORDER BY 
    -- Orders the results by total bike shares in descending order
    total_bike_shares DESC;


--2.1. DAILY BIKE SHARES CATEGORIZED BY SEASON

-- This query selects the date, count of new bike shares, and corresponding season from the new_london_bike_sharing table, ordered by date.

SELECT
    -- Selects the date from the date_column
    date_column,
    -- Selects the count of new bike shares
    count_new_bike_shares,
    -- Assigns the corresponding season based on the numeric value of the "season" column
    CASE
        WHEN season = 0 THEN 'Spring'
        WHEN season = 1 THEN 'Summer'
        WHEN season = 2 THEN 'Fall'
        WHEN season = 3 THEN 'Winter'
    END AS season
FROM
    -- Specifies the table to select data from
    PortfolioProject.dbo.new_london_bike_sharing
ORDER BY
    -- Orders the results by date in ascending order
    date_column;


--3. TOTAL BIKE SHARES CATEGORIZED BY WEATHER CONDITIONS

-- Selecting weather conditions and summing up bike shares for each condition
SELECT
    CASE
        WHEN weather = 1 THEN 'Clear'
        WHEN weather = 2 THEN 'Scattered Clouds/Few Clouds'
        WHEN weather = 3 THEN 'Broken Clouds'
        WHEN weather = 4 THEN 'Cloudy'
        WHEN weather = 7 THEN 'Rain/Light Rain'
        WHEN weather = 10 THEN 'Rain w/ Thunderstorm'
        WHEN weather = 26 THEN 'Snowfall'
        WHEN weather = 94 THEN 'Freezing Fog'
    END AS weather, -- Assigning labels to weather conditions
    SUM(count_new_bike_shares) AS total_bike_shares -- Summing up bike shares for each weather condition
FROM
    PortfolioProject.dbo.new_london_bike_sharing
GROUP BY
    weather -- Grouping by weather condition
ORDER BY
    total_bike_shares DESC; -- Ordering the results by total bike shares in descending order


--3.1. DAILY BIKE SHARES CATEGORIZED BY WEATHER CONDITIONS

-- Selecting date column, count of new bike shares, and categorizing weather conditions
SELECT
    date_column, -- Selecting the date column
    SUM(count_new_bike_shares) AS total_bike_shares, -- Summing up bike shares for each date
    CASE
        WHEN weather = 1 THEN 'Clear'
        WHEN weather = 2 THEN 'Scattered Clouds/Few Clouds'
        WHEN weather = 3 THEN 'Broken Clouds'
        WHEN weather = 4 THEN 'Cloudy'
        WHEN weather = 7 THEN 'Rain/Light Rain'
        WHEN weather = 10 THEN 'Rain w/ Thunderstorm'
        WHEN weather = 26 THEN 'Snowfall'
        WHEN weather = 94 THEN 'Freezing Fog'
    END AS weather_condition
FROM
    PortfolioProject.dbo.new_london_bike_sharing -- Selecting data from the specified table
GROUP BY
    date_column, -- Grouping the results by date
    weather -- Grouping the results by weather condition
ORDER BY
    date_column; -- Ordering the results by date


--4. WEEK DAY VS WEEKEND USAGE 

-- This query calculates the total bike shares for weekdays and weekends separately.
SELECT
    CASE
        WHEN DATEPART(dw, date_column) IN (1, 7) THEN 'Weekend' -- Sunday (1), Monday(2)... and Saturday (7) are considered weekend days
        ELSE 'Weekday'
    END AS day_type, -- Categorizing days into 'Weekday' and 'Weekend'
    SUM(count_new_bike_shares) AS total_bike_shares -- Summing up bike shares for each day type
FROM
    PortfolioProject.dbo.new_london_bike_sharing
GROUP BY
    CASE
        WHEN DATEPART(dw, date_column) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY
    day_type; -- Ordering the results by day type.


--4.1 WEEKDAYvsWEEKEND: IDENTIFYING DAY TYPE PER DAY OF WEEK

-- This query selects data from the specified table and categorizes days into 'Weekday' and 'Weekend' based on the day of the week.
SELECT
	date_column,
	day_of_week,
    CASE
        WHEN DATEPART(dw, date_column) IN (1, 7) THEN 'Weekend' -- Sunday (1), Monday(2)... and Saturday (7) are considered weekend days
        ELSE 'Weekday'
    END AS day_type, -- Categorizing days into 'Weekday' and 'Weekend'
   count_new_bike_shares -- Summing up bike shares for each day type
FROM
    PortfolioProject.dbo.new_london_bike_sharing
ORDER BY
    day_type; -- Ordering the results by day type.


--5. HOLIDAYS VS NON-HOLIDAYS

SELECT
	-- Convert is_holiday values to descriptive categories
	CASE
		WHEN is_holiday = 1 THEN 'Holiday'  -- If is_holiday is 1, label as 'Holiday'
		WHEN is_holiday = 0 THEN 'Non-holiday'  -- If is_holiday is 0, label as 'Non-holiday'
	END AS is_holiday,
	-- Calculate total bike shares for each category
	SUM(count_new_bike_shares) AS total_bike_shares
FROM
	PortfolioProject.dbo.new_london_bike_sharing
GROUP BY
	is_holiday  -- Group the results by the is_holiday categories
ORDER BY
	total_bike_shares DESC; --Order the results by total bike shares in descending order


--5.1 DAILY VIEW: Holidays vs Non Holidays

SELECT
	-- Convert is_holiday values to descriptive categories
	date_column,
	day_of_week,
	CASE
		WHEN is_holiday = 1 THEN 'Holiday'  -- If is_holiday is 1, label as 'Holiday'
		WHEN is_holiday = 0 THEN 'Non-holiday'  -- If is_holiday is 0, label as 'Non-holiday'
	END AS is_holiday,
	-- Calculate total bike shares for each category
	SUM(count_new_bike_shares) AS total_bike_shares
FROM
	PortfolioProject.dbo.new_london_bike_sharing
GROUP BY
	date_column,
	day_of_week,
	count_new_bike_shares,
	is_holiday  -- Group the results
ORDER BY
	date_column;


--6. PEAK BIKE USAGE OF TIME OF DAY

-- This query retrieves the specific date, time, day of the week, and count of new bike shares for each day where the peak bike usage occurred.

SELECT
    -- Selects the date, time, day of the week, and count of new bike shares
    date_column,
    time_column,
    day_of_week,
    count_new_bike_shares AS peak_bike_usage
FROM (
    -- Subquery to rank the rows by count of new bike shares within each day
    SELECT
        date_column,
        time_column,
        day_of_week,
        count_new_bike_shares,
        -- Assigns a unique row number to each row within each day, ordered by count of new bike shares
        ROW_NUMBER() OVER (PARTITION BY date_column ORDER BY count_new_bike_shares DESC) AS row_num
    FROM
        PortfolioProject.dbo.new_london_bike_sharing
) AS ranked
-- Filters the rows to only include those with the highest count of new bike shares for each day
WHERE
    row_num = 1
-- Orders the results by date
ORDER BY
    date_column;
 

-------------------------------------------------------------------------------------------------



