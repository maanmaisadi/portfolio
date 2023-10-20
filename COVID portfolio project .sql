/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select *
From PortfolioProjects..CovidDEATH$
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjects..CovidDEATH$
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT Location,Date, Total_Cases, Total_Deaths,
(TRY_CAST(Total_Deaths AS float) / NULLIF(TRY_CAST(Total_Cases AS float), 0)) * 100 AS DeathPercentage
FROM PortfolioProjects..CovidDeath$
WHERE
    Location LIKE '%states%'
    AND Continent IS NOT NULL
ORDER BY 1, 2;



-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProjects..CovidDEATH$
--Where location like '%states%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjects..CovidDEATH$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDEATH$
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeath$
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProjects..CovidDeath$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeath$ dea
Join PortfolioProjects..CovidVaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
FROM PortfolioProjects..CovidDeath$ dea
JOIN PortfolioProjects..CovidVaccination$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
)
SELECT *,(RollingPeopleVaccinated / NULLIF(Population, 0)) * 100 AS VaccinationPercentage
FROM PopvsVac;




-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated
(
    Continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    New_vaccinations numeric,
    RollingPeopleVaccinated numeric
);

INSERT INTO #PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(numeric, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
FROM
    PortfolioProjects..CovidDeath$ dea
JOIN
    PortfolioProjects..CovidVaccination$ vac
    ON dea.location = vac.location
    AND dea.date = vac.date;

SELECT
    *,
    (RollingPeopleVaccinated / NULLIF(Population, 0)) * 100 AS VaccinationPercentage
FROM
    #PercentPopulationVaccinated;




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeath$ dea
Join PortfolioProjects..CovidVaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
