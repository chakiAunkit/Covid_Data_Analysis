select * from CovidProject..CovidDeaths
order by 3, 4

--select * from CovidProject..CovidVaccinations
--order by 3, 4

-- Selecting the data we will use
Select location, date, total_cases, new_cases, total_deaths, population
from CovidProject..CovidDeaths
order by 1, 2

-- Total deaths vs Total cases
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRatio
from CovidProject..CovidDeaths
where location like 'India'
order by 1, 2

-- Total population vs total cases
Select location, date, population, total_cases, (total_cases/population)*100 as AffectedRatio
from CovidProject..CovidDeaths
where location like 'India'
order by 1, 2

-- Looking at countries with highest infection compared to population
select location, population, MAX(total_cases) as HighestInfection, MAX((total_cases/population))*100 as InfectedPopulationPercent
from CovidProject..CovidDeaths
group by location, population
order by InfectedPopulationPercent desc

-- Looking at country with highest death counts
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--Looking at the data with respect to continents
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

-- Looking at world data
select date, SUM(new_cases) as total_mew_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidProject..CovidDeaths
where continent is not null
Group by date
order by 1,2

-- Worldwide cases
select SUM(new_cases) as total_mew_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from CovidProject..CovidDeaths
where continent is not null
order by 1,2

-- Joining the two tables and using a CTE
with populationvsvaxx (Continent, Location, Date, Population, New_vaxx, PeopleVacc)
as
(
select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(cast(vax.new_vaccinations as int)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as PeopleVaccinated
from CovidProject..CovidDeaths dea
join CovidProject..CovidVaccinations vax
on dea.location = vax.location and dea.date = vax.date
where dea.continent is not null
-- order by 2, 3
)
Select * from populationvsvaxx