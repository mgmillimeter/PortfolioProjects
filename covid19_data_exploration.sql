---/////////////////////////////////////////////////////////////////////////
--///////// COVID-19 DATA EXPLORATION AND ANALYSIS /////////////////////////
--/////////////////////////////////////////////////////////////////////////
/*SOURCE: https://github.com/owid/covid-19-data/tree/master/public/data */


--CONTENTS:
------DEATH TOLL PER COUNTRY
------DEATH TOLL PER CONTINENT
------DEATH RATE PERCENTAGE PER COUNTRY
------GLOBAL DEATH TOLL
------GLOBAL DEATH PERCENTAGE
------GLOBAL DEATH PERCENTAGE IN 2020
------GLOBAL DEATH PERCENTAGE 2021
------GLOBAL DEATH PERCENTAGE 2022
------GLOBAL DEATH PERCENTAGE 2023
------POSITIVITY RATE PER COUNTRY

--datasets: CovidDeaths & CovidVaccinations



-----------------------------------------------------------------------------------
-- 1. DEATH TOLL PER COUNTRY
SELECT 
    continent,
	Location,
    MAX(CAST(total_deaths AS int)) AS total_deaths
FROM 
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL
    AND location NOT IN 
    ('World', 'European Union', 'International','High Income',
    'Upper middle income', 'Lower middle income', 'low income')
GROUP BY 
    continent,
	Location
ORDER BY  
    total_deaths DESC;




-----------------------------------------------------------------------------------
-- 2. DEATH TOLL PER CONTINENT
SELECT
    location AS Continent,
    SUM(cast(new_deaths as INT)) as total_death_toll
FROM
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NULL
    AND location NOT IN 
    ('World', 'European Union', 'International','High Income',
    'Upper middle income', 'Lower middle income', 'low income')
GROUP BY
    location
ORDER BY
    total_death_toll DESC;



-----------------------------------------------------------------------------------
-- 3. DEATH RATE PERCENTAGE PER COUNTRY

SELECT
    location AS Country,
    CASE 
        WHEN SUM(CAST(total_cases AS BIGINT)) = 0 THEN 0
        ELSE (SUM(CAST(total_deaths AS BIGINT)) * 100.0) / SUM(CAST(total_cases AS BIGINT))
    END AS Death_Rate
FROM
    PortfolioProject..CovidDeaths
WHERE
	continent IS NOT NULL
GROUP BY
    location
ORDER BY
    Death_Rate DESC;



-----------------------------------------------------------------------------------
-- 4. GLOBAL DEATH TOLL
SELECT
    MAX(CAST(total_deaths AS INT)) AS TotalDeathToll
FROM
    PortfolioProject..CovidDeaths;



-----------------------------------------------------------------------------------
-- 5. GLOBAL DEATH PERCENTAGE
SELECT
    SUM(CAST(new_cases AS BIGINT)) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 AS DeathPercentage
FROM
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL
    AND location NOT IN 
    ('World', 'European Union', 'International', 'High Income', 
    'Upper middle income', 'Lower middle income', 'low income');


-----------------------------------------------------------------------------------
-- 6. GLOBAL DEATH PERCENTAGE IN 2020
SELECT
    YEAR(date) AS Year,
    SUM(CAST(new_cases AS FLOAT)) AS total_cases,
    SUM(CAST(new_deaths AS FLOAT)) AS total_deaths,
    CASE
        WHEN SUM(CAST(new_cases AS FLOAT)) = 0 THEN 0
        ELSE (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 
    END AS Global_Death_Percentage_2020
FROM
    PortfolioProject..CovidDeaths
WHERE
    YEAR(date) = 2020
    AND continent IS NOT NULL
GROUP BY
    YEAR(date);

-- 7. GLOBAL DEATH PERCENTAGE 2021
SELECT
    YEAR(date) AS Year,
    SUM(CAST(new_cases AS FLOAT)) AS total_cases,
    SUM(CAST(new_deaths AS FLOAT)) AS total_deaths,
    CASE
        WHEN SUM(CAST(new_cases AS FLOAT)) = 0 THEN 0
        ELSE (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 
    END AS Global_Death_Percentage_2021
FROM
    PortfolioProject..CovidDeaths
WHERE
    YEAR(date) = 2021
    AND continent IS NOT NULL
GROUP BY
    YEAR(date);

-- 8. GLOBAL DEATH PERCENTAGE 2022
SELECT
    YEAR(date) AS Year,
    SUM(CAST(new_cases AS FLOAT)) AS total_cases,
    SUM(CAST(new_deaths AS FLOAT)) AS total_deaths,
    CASE
        WHEN SUM(CAST(new_cases AS FLOAT)) = 0 THEN 0
        ELSE (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 
    END AS Global_Death_Percentage_2022
FROM
    PortfolioProject..CovidDeaths
WHERE
    YEAR(date) = 2022
    AND continent IS NOT NULL
GROUP BY
    YEAR(date);

-- 9. GLOBAL DEATH PERCENTAGE 2023
SELECT
    YEAR(date) AS Year,
    SUM(CAST(new_cases AS FLOAT)) AS total_cases,
    SUM(CAST(new_deaths AS FLOAT)) AS total_deaths,
    CASE
        WHEN SUM(CAST(new_cases AS FLOAT)) = 0 THEN 0
        ELSE (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 
    END AS Global_Death_Percentage_2023
FROM
    PortfolioProject..CovidDeaths
WHERE
    YEAR(date) = 2023
    AND continent IS NOT NULL
GROUP BY
    YEAR(date);

-- 10. GLOBAL DEATH PERCENTAGE 2024
SELECT
    YEAR(date) AS Year,
    SUM(CAST(new_cases AS FLOAT)) AS total_cases,
    SUM(CAST(new_deaths AS FLOAT)) AS total_deaths,
    CASE
        WHEN SUM(CAST(new_cases AS FLOAT)) = 0 THEN 0
        ELSE (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 
    END AS Global_Death_Percentage_2023
FROM
    PortfolioProject..CovidDeaths
WHERE
    YEAR(date) = 2024
    AND continent IS NOT NULL
GROUP BY
    YEAR(date);


-----------------------------------------------------------------------------------
-- 10. POSITIVITY RATE PER COUNTRY
SELECT 
	Location,
	SUM(CAST(new_cases AS INT)) AS positive_count,
	population,
	SUM(CAST(new_cases AS INT)/population)*100 AS positivity_rate
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL
GROUP BY 
	location, population
ORDER BY  
	location


-----------------------------------------------------------------------------------


-- VACCINATIONS


-- FULLY VACCINATED RATE PER COUTNRIES
--WITH PrimVacVsPopulation AS (
--    SELECT 
--        dea.date,
--        dea.location AS Country,
--        dea.population,
--        MAX(CAST(vac.people_fully_vaccinated AS bigint)) AS completed_primary_series_vaccine
--    FROM 
--        PortfolioProject..CovidDeaths AS dea 
--    JOIN
--        PortfolioProject..CovidVaccinations AS vac
--    ON 
--        dea.date = vac.date
--        AND dea.location = vac.location
--    WHERE 
--        dea.continent IS NOT NULL
--    GROUP BY 
--        dea.date, dea.location, dea.population
--)
--SELECT
--    Country,
--    date,
--    (completed_primary_series_vaccine / population) * 100 AS FullyVaccinatedPopulationRate
--FROM 
--    PrimVacVsPopulation
--ORDER BY
--    Country, date;


WITH PrimVacVsPopulation AS (
    SELECT 
        dea.location AS Country,
        MAX(dea.date) AS LatestDate,
        MAX(dea.population) AS Population,
        MAX(CAST(vac.people_fully_vaccinated AS bigint)) AS completed_primary_series_vaccine
    FROM 
        PortfolioProject..CovidDeaths AS dea 
    JOIN
        PortfolioProject..CovidVaccinations AS vac
    ON 
        dea.date = vac.date
        AND dea.location = vac.location
    WHERE 
        dea.continent IS NOT NULL
    GROUP BY 
        dea.location
)
SELECT
    Country,
    Population,
    LatestDate AS Date,
	completed_primary_series_vaccine,
    (completed_primary_series_vaccine / Population) * 100 AS FullyVaccinatedPopulationRate
FROM 
    PrimVacVsPopulation
ORDER BY
    Country;





-- CUMMLATIVE COVID-19 ADMINISTERED DOSES GLOBALLY
SELECT 
    dea.date,
    dea.location AS Country,
    CAST(vax.total_vaccinations AS BIGINT) AS total_vaccinations,
    
    dea.new_cases_per_million AS Cases_per_million,
    dea.new_deaths_per_million AS Deaths_per_million,
    dea.hosp_patients_per_million AS hosp
FROM
    PortfolioProject..CovidDeaths AS dea 
JOIN
    PortfolioProject..CovidVaccinations AS vax ON dea.date = vax.date 
                                               AND dea.location = vax.location
WHERE dea.location = 'World'
    --dea.continent IS NOT NULL
    --AND dea.location NOT IN ('World', 'European Union', 'International', 'High Income', 
    --                         'Upper middle income', 'Lower middle income', 'low income')
ORDER BY
    dea.location, dea.date;


--PRIMARY SERIES VACCINE(RATE)
WITH PrimVacVsPopulation AS (
    SELECT 
        dea.location AS Country,
        MAX(dea.date) AS LatestDate,
        MAX(dea.population) AS TotalPopulation,
        MAX(CAST(vac.new_vaccinations AS bigint)) AS TotalCompletedPrimarySeriesVaccine
    FROM 
        PortfolioProject..CovidDeaths AS dea 
    JOIN
        PortfolioProject..CovidVaccinations AS vac
    ON 
        dea.date = vac.date
        AND dea.location = vac.location
    WHERE 
        dea.continent IS NOT NULL
    GROUP BY 
        dea.location
)
SELECT
    Country,
    LatestDate AS Date,
    TotalPopulation,
    TotalCompletedPrimarySeriesVaccine,
    (TotalCompletedPrimarySeriesVaccine / TotalPopulation) * 100 AS VaccinationRate
FROM 
    PrimVacVsPopulation
ORDER By
	Country;




 




	







