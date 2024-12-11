select*
from portefolioprojet..CovidDeaths$
where continent is not null
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from portefolioprojet..CovidDeaths$
where continent is not null
order by 1,2

looking at total cases vs total deaths 
shows  likelihood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathspourcentage
from portefolioprojet..CovidDeaths$
where location like '%states%'
and continent is not null
order by 1,2

looking at total cases vs population
shows what percentage of population got covid 
select location,date,population,total_cases,(total_cases/population)*100 as percentpopulationinfected
from portefolioprojet..CovidDeaths$
where continent is not null
order by 1,2

looking at countries with highest rate compared to population

select location,population,max(total_cases) as highestinfected ,max((total_cases/population))*100 as percentpopulationinfected
from portefolioprojet..CovidDeaths$
where continent is not null
group by location,population
order by percentpopulationinfected desc

showing countries with highest deaths per population

select location,max(cast(total_deaths as int)) as totaldeathcount 
from portefolioprojet..CovidDeaths$
where continent is not null
group by location
order by totaldeathcount desc

lets break thinks down by continent

select continent ,max(cast(total_deaths as int)) as totaldeathcount 
from portefolioprojet..CovidDeaths$
where continent is not null
group by continent
order by totaldeathcount desc

showing continents with the highest death count per population

select continent ,max(cast(total_deaths as int)) as totaldeathcount 
from portefolioprojet..CovidDeaths$
where continent is not null
group by continent
order by totaldeathcount desc

global numbers
select date,sum(cast(new_cases as int)) ,sum(cast(total_deaths as int)),(sum(total_deaths)/sum(total_cases))*100 as percentpopulationinfected
from portefolioprojet..CovidDeaths$
where continent is not null
group by date
order by 1,2


looking at total population vs vaccination

select dea.continent,dea.date,dea.location,dea.population,vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from portefolioprojet..CovidDeaths$ dea
join portefolioprojet..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

USE CTE

with PopvsVac ( continent,location,date,population, new_vacccinations,rollingpeoplevacinated)
as
(
select dea.continent,dea.date,dea.location,dea.population,vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from portefolioprojet..CovidDeaths$ dea
join portefolioprojet..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
)
select*
from PopvsVac

TEMP TABLE 
create table
(
continent nvarchar(255)
location nvarchar(255)
date datetime
populations numeric
new_vaccinations numeric
rollingpeoplevaccinated numeric
)

insert to #percentpopulationvaccinated
select dea.continent,dea.date,dea.location,dea.population,vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from portefolioprojet..CovidDeaths$ dea
join portefolioprojet..CovidVaccinations$ vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3