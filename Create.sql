CREATE TABLE IF NOT EXISTS public.Crime_List
(
	crime_code INTEGER,
    crime_description VARCHAR(100),
    MO_code VARCHAR(100),
	PRIMARY KEY(crime_code)
);

SELECT * FROM Crime_List LIMIT 5;

SELECT count(*) FROM Crime_List;


CREATE TABLE IF NOT EXISTS public.Weapon
(
	code INTEGER,
    weapon_description VARCHAR(100),
	PRIMARY KEY(code)
);

SELECT count(*) FROM Weapon;

CREATE TABLE IF NOT EXISTS public.Premise
(
	code INTEGER,
    description VARCHAR(100),
	PRIMARY KEY(code)
);
SELECT count(*) FROM Premise;


CREATE TABLE IF NOT EXISTS public.Area
(
	area_id INTEGER,
    area_name VARCHAR(20),
    reporting_district_code INTEGER,
	PRIMARY KEY(area_id, reporting_district_code)
);
SELECT count(*) FROM Area;

CREATE TABLE IF NOT EXISTS public.Location
(
	address VARCHAR(100),
    street VARCHAR(100),
    location_coordinate VARCHAR(20) DEFAULT '(-1,-1)',
	area_id INTEGER,
	reporting_district_code INTEGER,
	PRIMARY KEY(address, street),
	FOREIGN KEY(area_id, reporting_district_code) REFERENCES Area(area_id, reporting_district_code)
);
SELECT count(*) FROM Location;


CREATE TABLE IF NOT EXISTS public.Incident
(
	incident_id INTEGER,
    report_date DATE,
    date_occured DATE NOT NULL,
	time_occured TIME,
	crime_code INTEGER,
	weapon_code INTEGER,
	premise_code INTEGER,
	address VARCHAR(100),
	street VARCHAR(100),
	PRIMARY KEY(incident_id),
	FOREIGN KEY(crime_code) REFERENCES Crime_list(crime_code),
	FOREIGN KEY(weapon_code) REFERENCES Weapon(code),
	FOREIGN KEY(premise_code) REFERENCES Premise(code),	
	FOREIGN KEY(address, street) REFERENCES Location(address, street)
);
SELECT count(*) FROM incident;



CREATE TABLE IF NOT EXISTS public.Victim
(
	id INTEGER,
	age INTEGER,
    name VARCHAR(20),
    sex CHAR(1),
	descent CHAR(1),
	incident_id INTEGER,
	PRIMARY KEY(id),
	FOREIGN KEY(incident_id) REFERENCES Incident(incident_id)
);
SELECT *
FROM victim;


CREATE TABLE IF NOT EXISTS public.Status
(
	id INTEGER,
    status_code CHAR(2),
	description VARCHAR(50),
	incident_id INTEGER,
	PRIMARY KEY(id),
	FOREIGN KEY(incident_id) REFERENCES Incident(incident_id)
);
SELECT count(*) FROM Status;

-- 1)
select count(*) as Total_Incidents, p.description
from incident i
join premise p 
on i.premise_code is not null and i.premise_code = p.code
group by p.description
order by count(*) desc;

-- 2) 
select avg(v.age) as avg_female_age
from incident i
natural join victim v
where v.sex = 'F'

-- 3) 
select * 
from incident 
where report_date - date_occured > 5;

-- 4)
select * from incident i 
where i.address in (
select distinct address
from location l
inner join area a on a.area_id = l.area_id
where a.reporting_district_code = 2071)

-- 5)
select distinct description, status_code
from status;

-- 6)
update crime_list
set crime_description = 'Other'
where crime_code = 814;





