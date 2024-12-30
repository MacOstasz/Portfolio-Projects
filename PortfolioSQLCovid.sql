-- Select Data that we are going to be using
--Select Location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--order by 1,2

--Loking at total cases vs total deaths
-- Shows likelihood of dying you contract covid in your country
--Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
--Where location like '%states'
--order by 1,2

--Looking at Total Cases vs Population
-- Shows what percetantage of population got Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
Where location like '%states'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--Where location like '%states'
Group by Location, Population
order by PercentPopulationInfected desc


--Showing Countries with Highest Death Count per Population


SELECT Location, Population, MAX (cast(Total_deaths as int)) AS TotalDeathsCount
--, MAX((cast(total_deaths as int)/Population))*100 as PercentPopulationDeath
FROM PortfolioProject.dbo.CovidDeaths
Where continent is not null
Group by Location, Population
Order by TotalDeathsCount desc

-- Lets break things down by continent

SELECT continent, MAX (cast(Total_deaths as int)) AS TotalDeathsCount
FROM PortfolioProject.dbo.CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathsCount desc

-- Showing continents with the highest death count per population

SELECT continent, MAX (cast(Total_deaths as int)) AS TotalDeathsCount
FROM PortfolioProject.dbo.CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathsCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
Where continent is not null
Order by 1,2

-- Looking at Total Population vs Vaccinations
 Select dea.continent, dea. location, dea. date, dea.population, vac.new_vaccinations
 , SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date ) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 From PortfolioProject.dbo.CovidDeaths dea 
 Join   PortfolioProject.dbo.CovidVaccinations vac
 ON dea.location = vac. location
 and dea.date = vac.date
 Where dea.continent is not null
 order by 2,3


 -- WIth CTE

 With PopvsVac (continent, Location, Date, Population, New_Vaccinations, RollingPoepleVaccinated)
 as
 (
  Select dea.continent, dea. location, dea. date, dea.population, vac.new_vaccinations
 , SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date ) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 From PortfolioProject.dbo.CovidDeaths dea 
 Join   PortfolioProject.dbo.CovidVaccinations vac
 ON dea.location = vac. location
 and dea.date = vac.date
 Where dea.continent is not null
 --order by 2,3
 )

 Select *, (RollingPoepleVaccinated/Population)*100
 From PopvsVac


 --TEMP TABLE
 DROP Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
 Insert into #PercentPopulationVaccinated
 
  
  Select *, (RollingPeopleVaccinated/Population)*100
 From #PercentPopulationVaccinated


 -- Creating view to stode data for later visualisations

 Create View PercentPopulationVaccinated as
   Select dea.continent, dea. location, dea. date, dea.population, vac.new_vaccinations
 , SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date ) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 From PortfolioProject.dbo.CovidDeaths dea 
 Join   PortfolioProject.dbo.CovidVaccinations vac
 ON dea.location = vac. location
 and dea.date = vac.date
 Where dea.continent is not null
 --order by 2,3


 Select *
 From PercentPopulationVaccinated