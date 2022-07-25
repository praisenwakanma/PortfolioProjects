SELECT * FROM PortfolioProject..CovidDeaths
where continent is not null
ORDER BY 3,4;

--SELECT * FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4;

-- Selecting Data that I will be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2;

-- Looking at total cases vs total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2;

-- total cases vs population
SELECT location, date, population, total_cases, (total_cases/population)*100 as CasePop
From PortfolioProject..CovidDeaths
Where location like '%states%'
ORDER BY 1,2;

-- Countries with highest infection rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases)/population)*100 as MaxCasePop
from PortfolioProject..CovidDeaths
GROUP BY population,location
ORDER BY MaxCasePop DESC;

-- Countries with the highest death count per infection
Select location, MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths 
where continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Continents with the highest death counts per population
Select continent, MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths 
where continent is not null
GROUP BY continent 
ORDER BY TotalDeathCount DESC;

-- Global Numbers
Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
GROUP BY date
order by 1,2;

-- Total cases
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2;

-- Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, MAX(RollingPeopleVaccinated)/dea.population
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
Order By 2,3;

-- CTE
With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
( 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, MAX(RollingPeopleVaccinated)/dea.population
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--Order By 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

-- Temp Table
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(continent nvarchar(255), location nvarchar(255), date datetime, population numeric, new_vaccinations numeric, RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, MAX(RollingPeopleVaccinated)/dea.population
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--Order By 2,3
Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

-- Creating a view for later visualization
Create VIEW PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as bigint)) OVER(Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, MAX(RollingPeopleVaccinated)/dea.population
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--Order By 2,3

select * 
From PercentPopulationVaccinated