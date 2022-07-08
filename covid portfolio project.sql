/* covid 19 data exploration */

select *
from CovidDeaths$
where continent is not null

select *
from CovidVaccinations$

/* select data from data set */

select  location , date , total_cases , new_cases , total_deaths, population 
from CovidDeaths$

-- looking at total cases and total deaths
-- death rate in india

select  location , date , total_cases  , total_deaths, (total_deaths /total_cases)*100 as Deathrate
from CovidDeaths$
where location like '%India%'

-- shows the % of population got covid
select  location , date , total_cases ,population,  (total_cases /population)*100 as activepercentage
from CovidDeaths$
where location like '%India%'

-- countries with highest infection rate compared to population
select  location , population, max(total_cases) as infectioncount , max(total_cases /population)*100 as infectionrate
from CovidDeaths$
group by location , population 
order by infectionrate desc 

----break things down by continent
--showing the countries with highest death count per capita
select  continent , max(cast(total_deaths as int)) as deathcount 
from CovidDeaths$
where continent is not null
group by continent
order by deathcount desc

-- global numbers

select  date , sum (new_cases) as total_cases --total_cases ,population,  (total_cases /population)*100 as activepercentage
from CovidDeaths$
where continent is not null
group by date

select  sum(population) as world_population ,sum (new_cases) as total_cases, sum (cast(new_deaths as int)) as total_deaths
from CovidDeaths$
where continent is not null

select distinct count(location) as total_locations
from  CovidDeaths$

select location from CovidVaccinations$
where positive_rate is  not null

-- looking at total population  vs vaccinations
select *
from CovidDeaths$ dea
join CovidVaccinations$ vac
   on dea.location = vac.location 
   and dea.date = vac.date
where dea.continent is not null

select dea.continent , dea.location , dea.population ,vac.new_vaccinations
from CovidDeaths$ dea
join CovidVaccinations$ vac
   on dea.location = vac.location 
   and dea.date = vac.date
where dea.continent is not null
order by 1,2
 

select dea.location , population , vac.new_vaccinations
from CovidDeaths$ dea
join CovidVaccinations$ vac
 on dea.location = vac.location 
   and dea.date = vac.date
where dea.continent is not null
order by 1,2


delete from CovidVaccinations$
where location like '%india%'

select  distinct continent 
from CovidDeaths$
where total_cases >100 and continent is not null

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one dose of  Covid Vaccine
--We can use the SQL PARTITION BY clause with the OVER clause to specify the column on which we need to perform aggregation

select dea.continent , dea.location , dea.date ,dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location
,dea.date) as rollingpeoplevaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
 on dea.location = vac.location 
   and dea.date = vac.date
where dea.continent is not null


-- creating and droping new table named PercentPopulationVaccinated

DROP Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)



Insert into PercentPopulationVaccinated
select dea.continent , dea.location , dea.date ,dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location
,dea.date) as rollingpeoplevaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
 on dea.location = vac.location 
   and dea.date = vac.date
---where dea.continent is not null
 


Select *, (rollingpeoplevaccinated/Population)*100 
From PercentPopulationVaccinated












