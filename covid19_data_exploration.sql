---================================================================================================
---=========================COVID DEATHS===========================================================
---================================================================================================
---================================================================================================


SELECT 
	*
FROM 
	PortfolioProject..CovidDeaths
ORDER BY 
	3, 4

SELECT 
	*
FROM 
	PortfolioProject..CovidVaccinations
ORDER 
	BY 3, 4
---================================================================================== 

-- Sorting Data by Order (Location and Date)

SELECT 
	Location, 
	Date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL
ORDER BY 
	1,2


-- Total Cases vs Total Deaths
-- Total deaths per Total Cases (Death Percentage)

SELECT 
	Location, 
	date, 
	total_cases,
	total_deaths, ((total_deaths/total_cases)*100) AS death_percentage
FROM 
	PortfolioProject..CovidDeaths
ORDER BY 
	Location;


-- 2020 COVID DEATH RATE PERCENTAGE PER COUNTRY
SELECT
	Location,
	Date,
	total_cases,
	new_cases,
	total_deaths,
	((total_deaths/total_cases)*100) AS death_percentage

FROM
	PortfolioProject..CovidDeaths

WHERE Date = '2020-12-31 00:00:00.000' AND continent IS NOT NULL

ORDER BY 6 DESC;


-- January 2020 - April 2021 Ranking Highest Death rate percentage per Country
SELECT 
	Location,
	MAX(cast(total_deaths as int)) AS max_total_deaths,
	population,
	MAX(cast(total_deaths as int)/(population))*100 AS deathratepercentage_per_country
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL
GROUP BY 
	Location, population
ORDER BY  
	deathratepercentage_per_country DESC;


-- January 2020 - April 2021 Ranking Highest Death Count per Country
SELECT 
	Location,
	MAX(cast(total_deaths as int)) AS total_death_count
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL
GROUP BY 
	Location
ORDER BY  
	2 DESC;


-- January 2020 - April 2021 Infection Rate Percentage
SELECT 
	Location,
	MAX(total_cases) AS InfectionCount,
	population,
	MAX((total_cases/population))*100 AS Population_Infection_Percentage
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL
GROUP BY 
	location, population
ORDER BY  
	4 DESC

-- BY CONTINENT COVID STATS --
---- Total Cases by Continent
SELECT
	location,
	MAX(total_cases) as max_total_cases,
	MAX(cast(Total_deaths as INT)) as total_death_count
FROM
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NULL
GROUP BY
	location
ORDER BY
	2 DESC


-- 
SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL


-- Philippines's Daily Cases From January 2020 - April  2021
SELECT
	location,
	MAX(CAST(total_cases AS INT)) AS totalcases_2020_Apr2021
FROM
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL
	AND location = 'Philippines'
GROUP BY
	location
ORDER BY
	1, 2



-- GLOBAL DEATH PERCENTAGE IN 2020
SELECT
    SUM(new_cases) AS total_cases_2020,
    SUM(CAST(new_deaths AS INT)) AS total_deaths_2020,
    (SUM(new_cases) / (SUM(CAST(new_deaths AS INT)) * 100)) AS global_death_percentage_2020
FROM
    PortfolioProject..CovidDeaths
WHERE
    continent IS NOT NULL
    AND date LIKE '%2020%'


-- GLOBAL DEATH PERCENTAGE IN JAN 22, 2020 - APRIL 2021
SELECT
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    (SUM(CAST(new_deaths AS INT)) / SUM(new_cases)) * 100 AS globaldeathpercentage2020_Apr_2021
FROM
    PortfolioProject..CovidDeaths
WHERE
    continent IS NOT NULL
ORDER BY
	1,2


-- COUNTRIES WITH HIGHEST INFECTION RATE --
SELECT
	location,
	population,
	MAX(total_cases) AS HighestInfectionCount,
	MAX((total_cases)/population)*100 AS InfectionRatePerCountry
FROM
	PortfolioProject..CovidDeaths
GROUP BY
	location, population
ORDER BY
	InfectionRatePerCountry DESC


-- HIGHEST DEATH RATE PER POPULATION PER COUNTRY
SELECT
	location,
	MAX(CAST(total_deaths AS INT)/population)*100 AS DeathRatePerPopulation
FROM
	PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY
	location
ORDER BY
	DeathRatePerPopulation DESC


-- HIGHEST DEATH COUNT PER COUNTRY
SELECT
	location,
	MAX(CAST(total_deaths AS INT)) AS HighestDeathCount
FROM
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL
GROUP BY
	location
ORDER BY
	HighestDeathCount DESC


-- TOTAL DEATH COUNT PER CONTINENT
SELECT
	location,
	MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM
	PortfolioProject..CovidDeaths
WHERE
	continent IS NULL
GROUP BY
	location
ORDER BY
	TotalDeathCount DESC


-- GLOBAL DAILY DEATH PERCENTAGE
SELECT
	date,
	SUM(new_cases) AS total_cases,
	SUM(CAST(new_deaths AS INT)) AS total_deaths,
	SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL
GROUP BY 
	date
ORDER BY 
	1,2


-- GLOBAL DEATH PERCENTAGE AS OF JAN 2020 - APR 2021
SELECT
	SUM(new_cases) AS total_cases,
	SUM(CAST(new_deaths AS INT)) AS total_deaths,
	SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM
	PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL


---================================================================================================
---==================================COVID VACCINATIONS============================================
---================================================================================================

SELECT *
FROM PortfolioProject..CovidVaccinations -- Data Recall purposes


--JOIN 2 TABLES, CovidDeaths x CovidVaccinations
SELECT
	top 20 *
FROM 
	PortfolioProject..CovidDeaths AS dea JOIN
	PortfolioProject..CovidVaccinations AS vac
	ON dea.date = vac.date
	AND
	dea.location = vac.location


--TOTAL POPULATION VS VACCINATIONS
---================================================================================================

--ROLLING COUNT QUERY of POPULATION VS VACCINATIONS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3
---================================================================================================

SELECT *
	--dea.continent,
 --   dea.location,
	--dea.population,
 --   SUM(CAST(vac.new_vaccinations AS INT)) AS total_new_vaccinations
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
    dea.continent,
	dea.location,
	dea.population
ORDER BY
    1

--USING CTE FOR FUTHER CALCULATUINS

WITH PopVsVac (
	continent, location, population, total_new_vaccinations)
	AS
	(
SELECT
	dea.continent,
    dea.location,
	dea.population,
    SUM(CAST(vac.new_vaccinations AS INT)) AS total_new_vaccinations
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
    dea.continent,
	dea.location,
	dea.population
)


SELECT
	*,
	(total_new_vaccinations/population)*100 AS VaccinationRatePerCountry
FROM
	PopVsVac
ORDER BY
	5 DESC



---================================================================================================

--ROLLING COUNT QUERY of POPULATION VS VACCINATIONS
With PopVsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
Select
	dea.continent, 
	dea.location, 
	dea.date, dea.population, 
	vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) 
	OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From 
	PortfolioProject..CovidDeaths dea Join 
	PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where 
	dea.continent is not null 
)

Select
	*,
	(RollingPeopleVaccinated/population)*100 AS RollinVaccinationRate
FROM
	PopVsVac
WHERE location LIKe '%states%'
ORDER BY
	2

---================================================================================================
-- HOSPITALIZED PATIENTS PER TOTAL TOTAL CASES PER COUNTRY

--TEMP TABLE

-- Drop the temporary table when done
DROP TABLE #HospitalizedPatients
-- Create the temporary table
CREATE TABLE #HospitalizedPatients (
    continent NVARCHAR(255),
    date DATETIME,
    location NVARCHAR(255),
    total_people_fully_vaccinated FLOAT,
    total_hospitalized_patients FLOAT,
    new_cases FLOAT,
    total_cases FLOAT,
    population FLOAT
);

-- Insert data into the temporary table
INSERT INTO #HospitalizedPatients
SELECT
    dea.continent,
    dea.date,
    dea.location,
    SUM(CAST(vac.people_fully_vaccinated AS FLOAT)) AS total_people_fully_vaccinated,
    SUM(CAST(dea.hosp_patients AS FLOAT)) AS total_hospitalized_patients,
    dea.new_cases,
    dea.total_cases,
    dea.population
FROM 
    PortfolioProject..CovidDeaths dea 
JOIN
    PortfolioProject..CovidVaccinations vac
ON 
    dea.date = vac.date 
    AND dea.location = vac.location
GROUP BY
    dea.continent,
    dea.date,
    dea.location,
    dea.population,
    dea.new_cases,
    dea.total_cases
ORDER BY
    total_hospitalized_patients DESC;

-- Select data from the temporary table
-- Hospitalization Rate for the Infected people per country's population
SELECT
    location,
    SUM(total_people_fully_vaccinated) AS total_people_fully_vaccinated,
    MAX(population) AS population,
    (MAX(total_people_fully_vaccinated)/MAX(population))*100 AS Vaccination_Rate
FROM 
    #HospitalizedPatients
WHERE 
    continent IS NOT NULL
GROUP BY
    location
ORDER BY 
     4 DESC;
	 

---================================================================================================
-- FOR VISUALIZATIONS Vaccinated population percentage

CREATE VIEW 
	Vaccinated_Population_Percentage AS
SELECT
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) 
	OVER (Partition by dea.Location Order 
	by dea.location, dea.Date) as RollingPeopleVaccinated
FROM 
	PortfolioProject..CovidDeaths dea Join 
	PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
WHERE 
	dea.continent is not null



SELECT *
FROM
	Vaccinated_Population_Percentage










