                                  TD1-SQL avancé


---------------------------1
Select c.name
From Country c,Ismember i, Organization o
Where i.country=c.code and i.organization=o.abbreviation and o.name='United Nations'
Order by name;


---------------------------2
Select c.name, c.population
From Country c,Ismember i, Organization o
Where i.country=c.code and i.organization=o.abbreviation and o.name='United Nations'
Order by population DESC;


---------------------------3
Select name
From Country 
Minus
Select c.name
From Country c,Ismember i, Organization o
Where i.country=c.code and i.organization=o.abbreviation and o.name='United Nations'
Order by name;

Select name 
From Country 
Where name not in(Select c.name
                  From Country c,Ismember i, Organization o
                  Where i.country=c.code and i.organization=o.abbreviation and o.name='United Nations')
Order by name;


---------------------------4
Select c1.name
From Borders b, Country c1, Country c2
Where b.country1=c1.code and b.country2=c2.code and c2.name='France'
Union  
Select c1.name
From Borders b, Country c1, Country c2
Where b.country2=c1.code and b.country1=c2.code and c2.name='France';


---------------------------5
Select c1.name
From Country c1, Country c2, Borders b
Where ((b.country1=c1.code and b.country2=c2.code)
      OR
       (b.country2=c1.code and b.country1=c2.code))
      and c2.name='France';


---------------------------6
Select Sum(b.length)
From Country c, Borders b
Where c.name='France' and (b.country1=c.code OR country2=c.code);


---------------------------7
Select c.name, Count(*)
From Country c, Borders b
Where b.country1=c.code OR b.country2= c.code
Group by c.name;


---------------------------8
Select c1.name, Sum(c2.population)
From Country c1, Country c2, Borders b
Where (b.country1=c1.code and b.country2=c2.code) 
   OR (b.country1=c2.code and b.country2=c1.code) 
Group by c1.name;


---------------------------10
Select o.name, count(*), Sum(c.population)
From Organization o, Country c, Ismember i
Where abbreviation=i.organization and i.country=c.code
Group by o.name;


---------------------------12
Select c.name,m.name, m.height
From Country c, Mountain m, Geo_Mountain g, Encompasses e
Where c.code=e.country and e.continent='America' and g.mountain=m.name and g.country=c.code and m.height>=all(Select m.height
From Mountain m,Geo_Mountain g
Where g.mountain=m.name and g.country=c.code);


---------------------------13
Select name
From River
Where River='Nile';


---------------------------14
Select distinct r.name
From RIver r, River r1, River r2
Where r.River = 'Nile' OR (r.River = r1.Name AND r1.River = 'Nile') OR (r.River = r1.name AND r1.River = r2.Name AND r2.River = 'Nile');


Select r.name
From River r
Where r.River = 'Nile' 
UNION
Select r.name
From River r, River r1
Where r.River = r1.name and r1.river = 'Nile'
UNION
Select r.name 
From River r1, River r2, River r
Where r.River = r1.Name AND r1.River = r2.Name AND r2.River = 'Nile';


---------------------------15
Select  sum( distinct r.length)
From RIver r, River r1
Where r.River = 'Nile' OR (r.River = r1.Name AND r1.River = 'Nile');


---------------------------16a
Select i.Organization, count(*)
From Ismember i
Group by i.Organization
Having count(*)>=all(Select count(*)
                     From Ismember i
                     Group by i.Organization);
                     

select m.organization, count(*) as nb from isMember m
group by m.organization
order by nb desc limit 1;


---------------------------16b
select m.organization, count(*) as nb from isMember m
group by m.organization
order by nb desc limit 3;





---------------------------17
select sum(distinct c2.population)/sum(distinct c2.area) from country c1, borders b, country c2
where (c1.name = 'Algeria' and c1.code = b.country1 and c2.code = b.country2)
or (c1.name = 'Algeria' and c1.code = b.country2 and c2.code = b.country1)
or (c1.name = 'Libya' and c1.code = b.country1 and c2.code = b.country2)
or (c1.name = 'Libya' and c1.code = b.country2 and c2.code = b.country1);


---------------------------18
select sum(distinct c2.population)/(sum(distinct c2.area) - sum(distinct d.area)) from country c1, borders b, country c2, geo_desert gd, desert d
where (c1.name = 'Algeria' and c1.code = b.country1 and c2.code = b.country2 and c2.code = gd.country and d.name = gd.desert)
or (c1.name = 'Algeria' and c1.code = b.country2 and c2.code = b.country1 and c2.code = gd.country and d.name = gd.desert)
or (c1.name = 'Libya' and c1.code = b.country1 and c2.code = b.country2 and c2.code = gd.country and d.name = gd.desert)
or (c1.name = 'Libya' and c1.code = b.country2 and c2.code = b.country1 and c2.code = gd.country and d.name = gd.desert);


---------------------------19
select r.name, sum(c1.population*percentage/100)/sum(c2.population) from country c1, country c2, religion r
where c1.code = country
group by r.name;


---------------------------20
(select c1.name, c2.name from country c1, country c2, encompasses e1, encompasses e2, geo_sea gs1, geo_sea gs2
where c1.code = e1.country
and c2.code = e2.country
and e1.continent = 'Europe'
and e2.continent = 'Europe'
and c1.code = gs1.country
and c2.code = gs2.country
and c1.code > c2.code
and gs1.sea = gs2.sea)
minus
(select c3.name, c4.name from country c3, country c4, encompasses e3, encompasses e4, geo_sea gs3, geo_sea gs4
where c3.code = e3.country
and c4.code = e4.country
and e3.continent = 'Europe'
and e4.continent = 'Europe'
and c3.code = gs3.country
and c4.code = gs4.country
and gs3.sea != gs4.sea);

