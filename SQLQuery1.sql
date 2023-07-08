--select * 
--from portfolioProject..CovidVaccination

select * 
from portfolioProject.dbo.CovidDeaths


--select location,date,total_cases,total_deaths, (total_cases/population)*100 as infectedPercentage
--from portfolioProject.dbo.CovidDeaths
--where location like 'Pakis%' 
--order by 1,2


select location,population,max(cast(total_cases as int)) as maximuncases, max((cast(total_cases as int)/population))*100 as infectedPercentage
from portfolioProject.dbo.CovidDeaths
where continent  is not null
group by location,population
order by infectedPercentage DESC


--country with highest death ratio
select location,max(cast(total_deaths as int)) as TotalDeathCount
from portfolioProject.dbo.CovidDeaths
where continent is not null
group by location,population
order by  TotalDeathCount DESC


select location,continent,max(cast(total_deaths as int)) as TotalDeathCount
from portfolioProject.dbo.CovidDeaths
where continent is not null
group by location
order by  TotalDeathCount DESC


--global cases according to the date

select date,sum(new_cases),sum(new_deaths) 
from portfolioProject.dbo.CovidDeaths
where continent is not null
group by date



select vac.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(float,new_vaccinations)) 
over (partition by dea.location order by dea.location , dea.date) as RollingPeoplevVaccinated
from portfolioProject.dbo.CovidDeaths as dea
join portfolioProject.dbo.CovidVaccination as vac
	on dea.date=vac.date
	and dea.location=vac.location
	where dea.continent is not null





with ptvacR(continent,location,date,population,new_vaccination,RollingPeopleVaccinated)
as
(
select vac.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(float,new_vaccinations)) 
over (partition by dea.location order by dea.location , dea.date) as RollingPeoplevVaccinated
from portfolioProject.dbo.CovidDeaths as dea
join portfolioProject.dbo.CovidVaccination as vac
	on dea.date=vac.date
	and dea.location=vac.location
	where dea.continent is not null
	)
select *,(RollingPeopleVaccinated/population)*100 as ratioOfVacinatedPeople 
from ptvacR





--temop table

drop table if exists #percentpeoplepopulation
create table #percentpeoplepopulation(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rpv numeric
)
insert into  #percentpeoplepopulation
select vac.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(float,new_vaccinations)) 
over (partition by dea.location order by dea.location , dea.date) as rpv-- RollingPeopleVaccinated
from portfolioProject.dbo.CovidDeaths as dea
join portfolioProject.dbo.CovidVaccination as vac
	on dea.date=vac.date
	and dea.location=vac.location
--	where dea.continent is not null

select *,(rpv/population)*100 
from  #percentpeoplepopulation



create view percentpeoplepopulation as
select vac.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(float,new_vaccinations)) 
over (partition by dea.location order by dea.location , dea.date) as rpv-- RollingPeopleVaccinated
from portfolioProject.dbo.CovidDeaths as dea
join portfolioProject.dbo.CovidVaccination as vac
	on dea.date=vac.date
	and dea.location=vac.location
	where dea.continent is not null




create view ptvacr as
select vac.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(float,new_vaccinations)) 
over (partition by dea.location order by dea.location , dea.date) as RollingPeoplevVaccinated
from portfolioProject.dbo.CovidDeaths as dea
join portfolioProject.dbo.CovidVaccination as vac
	on dea.date=vac.date
	and dea.location=vac.location
	where dea.continent is not null

select *
from ptvacr