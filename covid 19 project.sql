use project ;

select * from covid19deaths 
order by 1,2 ;

select * from covid19vaccinations 
order by 1,2 ;

-- selection of the datasets that will be used --

select location , dates , total_deaths , new_cases, total_deaths , population
from covid19deaths 
order by 1,2 ;

-- TOTAL CASES VS THE TOTAL DEATHS INCLUDING THE DEATH PERCENTAGE GLOBAL --
select population, total_cases , total_deaths , (total_deaths /total_cases)*100 as death_percentage
from covid19deaths 
order by 1,2 ;

-- TOTAL CASES VS THE TOTAL DEATHS INCLUDING THE DEATH PERCENTAGE INDIA --
select location, population, total_cases , total_deaths , (total_deaths /total_cases)*100 as death_percentage
from covid19deaths 
WHERE location = 'India'
order by 1,2 ;

-- TOTAL CASES VS THE TOTAL POPULATION INCLUDING THE POPULATION PERCENTAGE--
select location ,population, total_cases , (total_case/population)*100 as population_percentage
from covid19deaths 
WHERE location = 'India'
order by 1,2 ;

-- COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO THE POPULATION --
select location ,population, MAX(total_cases)as Highest_infection_rate , MAX((total_case/population))*100 as population_percentage
from covid19deaths
group by location  
order by Highest_infection_rate desc ; 

-- COUNTRIES WITH MAX DEATH COUNT COMPARED TO THE POPULATION --
select location, population , MAX(total_deaths) , MAX(total_deaths /population)*100 as death_percentage
from covid19deaths 
order by 1,2 ;

-- ASIA WITH DEATH COUNT AND DEATH PERCENTAGE --
select location ,count(total_death) as death_count , population , (total_death / population)*100 as death_percentage  
from covid19deaths
where location = 'Asia' 
order by total_death desc ;

-- CONTENENT TOTAL DEATH COUNT -- 
select continent, MAX(total_deaths) as total_deaths 
from covid19deaths 
group by continent
order by total_deaths desc ;

-- GLOBAL NUMBERS ON NEW CASES WITH DEATH PERCENTAGE--

select sum(new_cases) , sum(new_deaths) ,(sum(new_cases) /sum(new_deaths) )*100 as global_death_percentage
from covid19deaths 
group by new_cases
order by 1,2 ;

-- JOIN THE COVID19DEATHS AND THE COVID19VACCINATIONS TABLE --

select d.continent , d.location , d.dates , d.population , v.new_vaccinations
from covid19deaths as d 
join covid19vaccinations as v on d.location = v.location 
where d.continent is not null 
order by 1,2,3 ;

-- TOTAL PEOPLE VS VACCINATIONS --
select d.continent , d.location , d.dates , d.population , v.new_vaccinations ,SUM(convert(int , v.new_vaccinations)) OVER (Partition by  d.location
order by d.dates ) as rolling_vaccinations  
from covid19deaths as d 
join covid19vaccinations as v on d.location = v.location 
where d.continent is not null 
order by 1,2,3 ;

-- TEMP TABLE -- 
create table population_vaccinations 
( continent varchar(255), 
location varchar(255) ,
dates date ,
population numeric ,
vaccinations numeric 
) ;

insert into population_vaccinations 
select d.continent , d.location , d.dates , d.population , v.new_vaccinations ,SUM(convert(int , v.new_vaccinations)) OVER (Partition by  d.location
order by d.dates ) as rolling_vaccinations  
from covid19deaths as d 
join covid19vaccinations as v on d.location = v.location 
where d.continent is not null 
order by 1,2,3 ;

select * from population_vaccinations ;

-- PERCENT OF POPULATION VACCINATED --

SELECT rolling_vaccinations , population , (rolling_vaccinations  / population )*100 as percent_of_population_vaccinated ;

create view population_vaccinations as 
select d.continent , d.location , d.dates , d.population , v.new_vaccinations ,SUM(convert(int , v.new_vaccinations)) OVER (Partition by  d.location
order by d.dates ) as rolling_vaccinations  
from covid19deaths as d 
join covid19vaccinations as v on d.location = v.location 
where d.continent is not null ; 
-- order by 1,2,3 -- 




