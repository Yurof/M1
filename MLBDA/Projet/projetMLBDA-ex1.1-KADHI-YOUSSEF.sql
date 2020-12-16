create or replace type T_Mondial as object(
   NBCOUNTRY number,
   member function toXML return XMLType
)
/
create or replace type T_Coordonnee as object(
   LATITUDE NUMBER,
   LONGITUDE NUMBER,
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
   NAMEP        VARCHAR2(35 Byte),
   COUNTRY     VARCHAR2(4 Byte),
   POPULATION  NUMBER,
   AREA        NUMBER,
   CAPITAL     VARCHAR2(35 Byte),
   CAPPROV     VARCHAR2(35 Byte),
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
   COORDINATES  T_Coordonnee,
   INPROVINCE VARCHAR2(35 Byte),
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
   INPROVINCE VARCHAR2(35 Byte),
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
   INPROVINCE VARCHAR2(35 Byte),
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
/
create or replace type T_ensMontagne as table of T_Montagne;
/
---------
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
---------
create or replace type body T_Coordonnee as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<coordinates  latitude ="'||latitude ||'" longitude ="'||longitude ||'"/>');
      return output;
   end;
end;
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
create table LesContinents of T_Continent;
/
create or replace type T_ensContinent as table of T_Continent;
/
---------
create or replace type body T_Aeroport as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<airport  name ="'||name||'" nearcity="'||city||'"/>');
      return output;
   end;
end;
/
create table LesAeroport of T_Aeroport;
/
create or replace type T_ensAeroport as table of T_Aeroport;
/
---------
create or replace type body T_Ile as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<island name ="'||name||'"/>');
      output := XMLType.appendchildxml(output,'island', coordinates.toXML());   
      return output;
   end;
end;
/
create table LesIles of T_Ile;
/
create or replace type T_ensIle as table of T_Ile;
/
------------------
create or replace type body T_Province as
   member function toXML return XMLType is
   output XMLType;
   tmpMontagne T_ensMontagne;
   tmpIle T_ensIle;
   tmpDesert T_ensDesert;
    begin
    output := XMLType.createxml('<province name ="'||namep||'" capital="'||capital||'"/>');
    select value(m) bulk collect into tmpMontagne
    from LesMontagnes m
    where namep = m.inprovince ;  
    for indx IN 1..tmpMontagne.COUNT
    loop
      output := XMLType.appendchildxml(output,'province', tmpMontagne(indx).toXML());   
    end loop;
    
    select value(m) bulk collect into tmpDesert
    from LesDesert m
    where namep = m.inprovince ;  
    for indx IN 1..tmpDesert.COUNT
    loop
      output := XMLType.appendchildxml(output,'province', tmpDesert(indx).toXML());   
    end loop;
    
    select value(i) bulk collect into tmpIle
    from LesIles i
    where namep = i.inprovince ;  
    for indx IN 1..tmpIle.COUNT
    loop
      output := XMLType.appendchildxml(output,'province', tmpIle(indx).toXML());   
    end loop;
    return output;
   end;
end;
/
             
create table LesProvinces of T_Province;
/
create or replace type T_ensProvince as table of T_Province;
/
---------
create or replace type body T_Pays as
   member function toXML return XMLType is
   output XMLType;
   tmpContinent T_ensContinent;
   tmpProvince T_ensProvince;
   tmpAeroport T_ensAeroport;
    begin
    output := XMLType.createxml('<country idcountry ="'||code||'" nom="'||name||'"/>');
    
    select value(c) bulk collect into tmpContinent
    from LesContinents c
    where code = c.incountry ;  
    for indx IN 1..tmpContinent.COUNT
    loop
      output := XMLType.appendchildxml(output,'country', tmpContinent(indx).toXML());   
    end loop;
    
    select value(p) bulk collect into tmpProvince
    from LesProvinces p
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
create table LesPays of T_Pays;
/
create or replace type T_ensPays as table of T_Pays;
/
---------
create or replace type body T_Mondial as
   member function toXML return XMLType is
   output XMLType;
   tmpPays T_ensPays;
   begin
      output := XMLType.createxml('<mondial/>');
      select value(p) bulk collect into tmpPays
      from LesPays p
      order by p.name asc;
      for indx IN 1..tmpPays.COUNT
      loop
         output := XMLType.appendchildxml(output,'mondial', tmpPays(indx).toXML());   
      end loop;
      return output;
   end;
end;
/
create table MondialTable of T_Mondial;
/
-------------------------------------------------------------------------------------------
insert into LesPays
  select T_Pays(c.name, c.code, c.capital, 
         c.province, c.area, c.population) 
         from COUNTRY c;
/
insert into LesProvinces
  select T_Province(p.name, p.country,p.population,p.area,p.capital,p.capprov ) 
         from PROVINCE p;    
/
insert into LesContinents
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
         m.type, g.country,T_Coordonnee(m.coordinates.latitude,m.coordinates.longitude), g.province ) 
         from MOUNTAIN m, GEO_MOUNTAIN g
         where g.MOUNTAIN=m.NAME;
/
insert into LesDesert
  select T_Desert(d.name, d.area,
                  T_Coordonnee(d.coordinates.latitude,d.coordinates.longitude), g.province ) 
         from DESERT d, GEO_DESERT g
         where g.DESERT=d.NAME;
/
insert into LesIles
  select T_Ile(i.name, i.islands, i.area, i.height, i.type,
                T_Coordonnee(i.coordinates.latitude,i.coordinates.longitude), g.province ) 
         from ISLAND i, GEO_ISLAND g
         where g.island=i.name;
/
insert into MondialTable Values(T_Mondial(1));
-------------------------------------------------------------------------------------------      
WbExport -type=text
         -file='mondial1.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=' \t'
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select m.toXML().getClobVal() 
from MondialTable m;
