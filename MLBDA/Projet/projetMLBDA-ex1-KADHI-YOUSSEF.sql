create or replace type T_Coordonnee as object(
   latitude NUMBER,
   longitude NUMBER,
   member function toXML return XMLType
)
/
create or replace type T_Pays as object(
   NAME        VARCHAR2(35 Byte),
   CODE        VARCHAR2(4 Byte),
   CAPITAL     VARCHAR2(35 Byte),
   PROVINCE    VARCHAR2(35 Byte),
   AREA        NUMBER,
   POPULATION  NUMBER,
   member function toXML return XMLType
)
/
create or replace type T_Province as object(
   NAME        VARCHAR2(35 Byte),
   COUNTRY     VARCHAR2(4 Byte),
   POPULATION  NUMBER,
   AREA        NUMBER,
   CAPITAL     VARCHAR2(35 Byte),
   CAPPROV     VARCHAR2(35 Byte),
   INMOUNTAIN  VARCHAR2(35 Byte),
   INISLAND    VARCHAR2(35 Byte),
   member function toXML return XMLType
)
/
create or replace type T_Continent as object(
   NAME  VARCHAR2(20 Byte),
   AREA  NUMBER(10),
   PERCENTAGE  NUMBER,
   INCOUNTRY VARCHAR2(4 Byte),
   member function toXML return XMLType
)
/
create or replace  type T_Montagne as object (
   NAME         VARCHAR2(35 Byte),
   MOUNTAINS    VARCHAR2(35 Byte),
   HEIGHT       NUMBER,
   TYPE         VARCHAR2(10 Byte),
   CODEPAYS         VARCHAR2(4),
   --COORDINATES  T_Coordonnee,
   member function toXML return XMLType
)
/
create or replace  type T_Ile as object (
   NAME         VARCHAR2(35 Byte),
   ISLANDS      VARCHAR2(35 Byte),
   AREA         NUMBER,
   HEIGHT       NUMBER,
   TYPE         VARCHAR2(10 Byte),
   COORDINATES  T_Coordonnee,
   member function toXML return XMLType
)
/
create or replace  type T_Aeroport as object (
   IATACODE   VARCHAR2(3 Byte),
   NAME       VARCHAR2(100 Byte),
   COUNTRY    VARCHAR2(4 Byte),
   CITY       VARCHAR2(50 Byte),
   PROVINCE   VARCHAR2(50 Byte),
   ISLAND     VARCHAR2(50 Byte),
   LATITUDE   NUMBER,
   LONGITUDE  NUMBER,
   ELEVATION  NUMBER,
   GMTOFFSET  NUMBER,
   member function toXML return XMLType
)
/
create or replace  type T_Desert as object (
   NAME         VARCHAR2(35 Byte)  ,
   AREA         NUMBER,
   COORDINATES  T_Coordonnee,
   member function toXML return XMLType
)
/
-----------------------------------------------------------------------------------------------------------
create or replace type body T_Montagne as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<mountain name ="'||name||'" height="'||height||'"/>');
      return output;
   end;
end;
/
create table LesMontagnes of T_Montagne;

create or replace type T_ensMontagne as table of T_Montagne;

--------
create or replace type body T_Desert as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<desert name ="'||name||'" area="'||area||'"/>');
      return output;
   end;
end;
/
create table LesDesert of T_Desert;
/
create or replace type T_ensDesert as table of T_Desert;
/
-------
create or replace type body T_Coordonnee as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<coordinates  latitude ="'||latitude ||'" longitude ="'||longitude ||'"/>');
      return output;
   end;
end;
/
create table LesCoordonnee of T_Coordonnee;
/
create or replace type T_ensCoordonnee as table of T_Coordonnee;
/
---------
create or replace type body T_Continent as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<continent   name ="'||name  ||'" percent ="'||percentage||'"/>');
      return output;
   end;
end;
/
create table LesContinent of T_Continent;
/
create or replace type T_ensContinent as table of T_Continent;
/
-------
create or replace type body T_Aeroport as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<airport  name ="'||name||'" city="'||city||'"/>');
      return output;
   end;
end;
/
create table LesAeroport of T_Aeroport;
/
create or replace type T_ensAeroport as table of T_Aeroport;
/
-------
create or replace type body T_Ile as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<island name ="'||name||'"/>');
      return output;
   end;
end;
/
create table LesIle of T_Ile;
/
create or replace type T_ensIle as table of T_Ile;
/

------------------
create or replace type body T_Province as
   member function toXML return XMLType is
   output XMLType;
   tmpMontagne T_ensMontagne;
   tmpIle T_ensIle;
    begin
    output := XMLType.createxml('<province name ="'||name||'" capital="'||capital||'"/>');
    select value(m) bulk collect into tmpMontagne
    from LesMontagnes m
    where inmountain = m.name ;  
    for indx IN 1..tmpMontagne.COUNT
    loop
      output := XMLType.appendchildxml(output,'province', tmpMontagne(indx).toXML());   
    end loop;
    
    select value(i) bulk collect into tmpIle
    from Lesile i
    where inisland = i.name ;  
    for indx IN 1..tmpIle.COUNT
    loop
      output := XMLType.appendchildxml(output,'province', tmpIle(indx).toXML());   
    end loop;
  
    return output;
   end;
end;
/
create table LesProvince of T_Province;
/
create or replace type T_ensProvince as table of T_Province;
/
create or replace type body T_Pays as
   member function toXML return XMLType is
   output XMLType;
   tmpContinent T_ensContinent;
   tmpProvince T_ensProvince;
   tmpAeroport T_ensAeroport;
    begin
    output := XMLType.createxml('<country idcountry ="'||code||'" nom="'||name||'"/>');
    
    select value(c) bulk collect into tmpContinent
    from LesContinent c
    where code = c.incountry ;  
    for indx IN 1..tmpContinent.COUNT
    loop
      output := XMLType.appendchildxml(output,'country', tmpContinent(indx).toXML());   
    end loop;
    
    select value(p) bulk collect into tmpProvince
    from LesProvince p
    where code = p.country ;  
    for indx IN 1..tmpProvince.COUNT
    loop
      output := XMLType.appendchildxml(output,'country', tmpProvince(indx).toXML());   
    end loop;
    
    select value(a) bulk collect into tmpAeroport
    from LesAeroport a
    where code = a.country ;  
    for indx IN 1..tmpAeroport.COUNT
    loop
      output := XMLType.appendchildxml(output,'country', tmpAeroport(indx).toXML());   
    end loop;
    return output;
   end;
end;
/
----


create table LesPays of T_Pays;
/
insert into LesPays
  select T_Pays(c.name, c.code, c.capital, 
         c.province, c.area, c.population) 
         from COUNTRY c;
/
insert into LesProvince
  select T_Province(p.name, p.country,p.population,p.area,p.capital,p.capprov,g.mountain,g2.island ) 
         from PROVINCE p, GEO_MOUNTAIN g, GEO_ISLAND g2
         where g.province=p.name and g2.province=p.name;      
/
insert into LesContinent 
   select T_Continent(c.name, c.area, e.percentage,
   e.country)
   from ENCOMPASSES e, CONTINENT c
   where c.name=e.continent;
/
insert into LesAeroport
  select T_Aeroport(a.iatacode, a.name, a.country,
                    a.city, a.province, a.island, a.latitude,
                    a.longitude, a.elevation, a.gmtoffset)
         from AIRPORT a;
  /           
insert into LesMontagnes
  select T_Montagne(m.name, m.mountains, m.height, 
         m.type, g.country ) 
         from MOUNTAIN m, GEO_MOUNTAIN g
         where g.MOUNTAIN=m.NAME;
/
WbExport -type=text
         -file='mondial1.xml'
         -createDir=true
         -encoding=ISO-8859-1
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select p.toXML().getClobVal() 
from LesPays p;


drop table LesAeroport;
