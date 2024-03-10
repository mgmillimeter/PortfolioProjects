-- COVID-19 DATASET (JANUARY 2020 - MARCH 09, 2024) QUERIES --

-- OVERALL VIEW OF THE DATASET (COVID DEATHS AND COVID VACCINATIONS)

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

-- SORTING DATA BY ORDER (LOCATION AND DATE)

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

---==================================================================================

--TOTAL CASES VS TOTAL DEATHS
	--Daily Total deaths per Total Cases & Death Percentage per Countries

SELECT 
    Location, 
    date, 
    total_cases,
    total_deaths, 
    CASE 
        WHEN total_cases = 0 THEN 0 
        ELSE (CAST(total_deaths AS float) / total_cases) * 100 
    END AS death_percentage
FROM 
    PortfolioProject..CovidDeaths
ORDER BY 
    Location;

---==================================================================================

-- DEATH RATE PERCENTAGE PER COUNTRY

SELECT
    location AS Country,
    SUM(CAST(total_deaths AS BIGINT)) AS Total_Deaths,
    SUM(CAST(total_cases AS BIGINT)) AS Total_Cases,
    CASE 
        WHEN SUM(CAST(total_cases AS BIGINT)) = 0 THEN 0
        ELSE (SUM(CAST(total_deaths AS BIGINT)) * 100.0) / SUM(CAST(total_cases AS BIGINT))
    END AS Death_Rate
FROM
    PortfolioProject..CovidDeaths
GROUP BY
    location
ORDER BY
    Death_Rate DESC;

---==================================================================================

-- DEATH COUNT PER COUNTRY

SELECT 
    Location,
    MAX(CAST(total_deaths AS int)) AS total_death_count
FROM 
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    Location
ORDER BY  
    total_death_count DESC;

---==================================================================================

-- INFECTION RATE PERCENTAGE

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

---==================================================================================

-- DEATH COUNT PER CONTINENT

SELECT
	location,
	MAX(total_cases) as max_total_cases,
	MAX(cast(Total_deaths as INT)) as total_death_count
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
	3 DESC

---==================================================================================

-- GLOBAL DEATH PERCENTAGE IN 2020

SELECT
    SUM(CAST(new_cases AS FLOAT)) AS Total_Cases_2020,
    SUM(CAST(new_deaths AS FLOAT)) AS Total_Deaths_2020,
    (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 AS Global_Death_Percentage_2020
FROM
    PortfolioProject..CovidDeaths
WHERE
    CONVERT(VARCHAR, date, 112) LIKE '2020%'
    AND continent IS NOT NULL;

---==================================================================================
	   	
-- GLOBAL DEATH PERCENTAGE 2021

SELECT
    SUM(CAST(new_cases AS FLOAT)) AS Total_Cases,
    SUM(CAST(new_deaths AS FLOAT)) AS Total_Deaths,
    (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 
	AS Global_Death_Percentage_2021
FROM
    PortfolioProject..CovidDeaths
WHERE
    CONVERT(VARCHAR, date, 112) LIKE '2021%'
    AND continent IS NOT NULL;

---==================================================================================

-- GLOBAL DEATH PERCENTAGE 2022

SELECT
    SUM(CAST(new_cases AS FLOAT)) AS Total_Cases,
    SUM(CAST(new_deaths AS FLOAT)) AS Total_Deaths,
    (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 
	AS Global_Death_Percentage_2022
FROM
    PortfolioProject..CovidDeaths
WHERE
    CONVERT(VARCHAR, date, 112) LIKE '2022%'
    AND continent IS NOT NULL;

---==================================================================================

-- GLOBAL DEATH PERCENTAGE 2023

SELECT
    SUM(CAST(new_cases AS FLOAT)) AS Total_Cases,
    SUM(CAST(new_deaths AS FLOAT)) AS Total_Deaths,
    (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 
	AS Global_Death_Percentage_2023
FROM
    PortfolioProject..CovidDeaths
WHERE
    CONVERT(VARCHAR, date, 112) LIKE '2023%'
    AND continent IS NOT NULL;

---==================================================================================

-- COUNTRIES WITH HIGHEST INFECTION RATE

SELECT
	location,
	population,
	MAX(total_cases) AS HighestInfectionCount,
	ROUND(MAX((total_cases)/population)*100,4) AS InfectionRatePerCountry
FROM
	PortfolioProject..CovidDeaths
GROUP BY
	location, population
ORDER BY
	InfectionRatePerCountry DESC

---==================================================================================

-- HIGHEST DEATH RATE PER POPULATION PER COUNTRY

SELECT
    location,
    MAX(CAST(total_deaths AS INT)) AS max_total_deaths,
    population,
    MAX(CAST(total_deaths AS INT)) / NULLIF(population, 0) * 100 AS DeathRatePerPopulation
FROM
    PortfolioProject..CovidDeaths
WHERE
    continent IS NOT NULL
GROUP BY
    location, population
ORDER BY
    DeathRatePerPopulation DESC;

---==================================================================================	

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

---==================================================================================

-- TOTAL DEATH COUNT PER CONTINENT

SELECT
	location,
	MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
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
	TotalDeathCount DESC

---==================================================================================

-- GLOBAL DAILY DEATH PERCENTAGE

SELECT
    date,
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS INT)) AS total_deaths,
    SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(new_cases), 0) * 100 AS Daily_Death_Percentage
FROM
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    date
ORDER BY 
    date;

---==================================================================================

-- GLOBAL DEATH COUNT

SELECT
	SUM(CAST(new_deaths AS INT)) AS TotalDeathToll

FROM
    PortfolioProject..CovidDeaths
WHERE 
	continent IS NOT NULL;


---==================================================================================

-- GLOBAL DEATH PERCENTAGE
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

-- Common Table Expression (CTE) to calculate vaccination data per country
-- Vaccinaton Rate Per Population
WITH PopVsVac AS (
    SELECT
        dea.continent,
        dea.location,
        dea.population,
        SUM(CAST(vac.new_vaccinations AS INT)) AS total_new_vaccinations,
        MAX(dea.date) AS latest_date
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
    (total_new_vaccinations / population) * 100 AS VaccinationRatePerPopulation
FROM
    PopVsVac
ORDER BY
    VaccinationRatePerPopulation DESC;



	
---================================================================================================

--ROLLING COUNT QUERY of POPULATION VS VACCINATIONS
WITH RollingVaccinations AS (
    SELECT
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM 
        PortfolioProject..CovidDeaths dea 
    JOIN 
        PortfolioProject..CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL 
)

SELECT
    location,
    date,
    population,
    new_vaccinations,
    RollingPeopleVaccinated,
    (RollingPeopleVaccinated / population) * 100 AS RollingVaccinationRate
FROM
    RollingVaccinations
ORDER BY
    location, date;


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










