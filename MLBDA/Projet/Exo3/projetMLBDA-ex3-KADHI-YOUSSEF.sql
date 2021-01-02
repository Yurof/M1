/*------------------------CREATION DES TYPES------------------------*/
  ------------------------------------------------------------------
Create or replace type T_Mondial as object(
   NB number, --variable fictive pour ne pas avoir un erreur car type vide
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
   NAME        VARCHAR2(35 Byte),
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
   AREA NUMBER,
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
create or replace type T_Organisation as object(
   ABBREVIATION  VARCHAR2(12 Byte),
   NAME          VARCHAR2(80 Byte),
   CITY          VARCHAR2(35 Byte), 
   COUNTRY       VARCHAR2(4 Byte) ,
   PROVINCE      VARCHAR2(35 Byte),
   ESTABLISHED   DATE,
   member function toXML return XMLType
)
/
create or replace type T_Membre as object(
   COUNTRY       VARCHAR2(4 Byte),
   ORGANIZATION  VARCHAR2(12 Byte),
   TYPE          VARCHAR2(35 Byte)
)
/
create table LesMembres of T_Membre;
/
create or replace type T_Encompasse as object(
   COUNTRY       VARCHAR2(4 Byte),
   CONTINENT     VARCHAR2(20 Byte),
   PERCENTAGE    NUMBER
)
/
create table LesEncompasses of T_Encompasse;
/
create  or replace type T_Riviere as object(
   NAME            VARCHAR2(35 Byte),
   INCOUNTRY       VARCHAR2(4 Byte),  
   member function toXML return XMLType
)
/
create or replace type T_Frontiere as object(
   COUNTRY1  VARCHAR2(4 Byte),
   COUNTRY2  VARCHAR2(4 Byte),
   LENGTH    NUMBER,          
   member function toXML return XMLType
)
/
/*------------------------CREATION DES FONCTIONS & TABLES------------------------*/
  -------------------------------------------------------------------------------

create or replace type body T_Riviere as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<river name ="'||name||'"/>');
      return output;
   end;
end;
/
create table LesRivieres of T_Riviere;
/
create or replace type T_ensRiviere as table of T_Riviere;
/
-----------------------------------------------------
create or replace type body T_Frontiere as
   member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<border countryCode ="'||COUNTRY1||'" length   ="'||LENGTH||'"/>');
      return output;
   end;
end;
/
create table LesFrontieres of T_Frontiere;
/
create or replace type T_ensFrontiere as table of T_Frontiere;
/

-----------------------------------------------------
create or replace type body T_Coordonnee as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<coordinates  latitude ="'||latitude ||'" longitude ="'||longitude ||'"/>');
      return output;
   end;
end;
/
-----------------------------------------------------

create or replace type body T_Montagne as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<mountain name ="'||name||'" height="'||height||'" />');
        output := XMLType.appEndchildxml(output,'mountain', coordinates.toXML()); 
      return output;
   end;
end;
/
create table LesMontagnes of T_Montagne;
/
create or replace type T_ensMontagne as table of T_Montagne;
/
-----------------------------------------------------

create or replace type body T_Province as
   member function toXML return XMLType is
   output XMLType;
   tmpMontagne T_ensMontagne;
    begin
    output := XMLType.createxml('<province name ="'||self.name||'"/>');
    select value(m) bulk collect into tmpMontagne
    from LesMontagnes m
    where self.name = m.inprovince ;  
    for indx IN 1..tmpMontagne.COUNT
    loop
      output := XMLType.appendchildxml(output,'province', tmpMontagne(indx).toXML());   
    end loop;
    if tmpMontagne.COUNT =0 then 
      output := XMLType.appendchildxml(output,'province', XMLtype('<mountain  name="NO MOUNTAIN"/>'));   
      end if;
    return output;
   end;
end;
/
             
create table LesProvinces of T_Province;
/
create or replace type T_ensProvince as table of T_Province;
/
-----------------------------------------------------

create or replace type body T_Organisation as
   member function toXML return XMLType is
   output XMLType; 
    begin
    output := XMLType.createxml('<organization name="'||name||'" abbreviation="'||abbreviation||'" established="'||to_char(established, 'DD/MM/YYYY')||'"/>');
    return output;
   end;
end;
/
create table LesOrganisations of T_Organisation;
/
create or replace type T_ensOrganisation as table of T_Organisation;
/
-------------------------------------------------------------
create or replace type body T_Pays as
   member function toXML return XMLType is
   output XMLType;
   tmpProvince T_ensProvince;
   tmpOrganisation T_ensOrganisation;
   tmpRiviere T_ensRiviere;
      tmpFrontiere T_ensFrontiere;
    begin
    output := XMLType.createxml('<country idcountry ="'||code||'" nom="'||name||'" population="'||population||'"/>');
    output := XMLType.appendchildxml(output,'country',  XMLType('<organizations/>'));   
    
    select value(o) bulk collect into tmpOrganisation
    from lesOrganisations o, LesMembres m
    where m.organization=o.abbreviation and m.country=code
    order by o.established asc;
    for indx IN 1..tmpOrganisation.COUNT
    loop
      output := XMLType.appendchildxml(output,'country/organizations', tmpOrganisation(indx).toXML());   
    end loop;

        output := XMLType.appendchildxml(output,'country',  XMLType('<provinces/>'));   
    select value(p) bulk collect into tmpProvince
    from LesProvinces p
    where code = p.country ;  
    for indx IN 1..tmpProvince.COUNT
    loop
      output := XMLType.appendchildxml(output,'country/provinces', tmpProvince(indx).toXML());   
    end loop;
    
        output := XMLType.appendchildxml(output,'country',  XMLType('<rivers/>'));   
    select value(r) bulk collect into tmpRiviere
    from LesRivieres r
    where code = r.incountry ;  
    for indx IN 1..tmpRiviere.COUNT
    loop
      output := XMLType.appendchildxml(output,'country/rivers', tmpRiviere(indx).toXML());   
    end loop;
          
    output := XMLType.appendchildxml(output,'country', XMLType('<borders/>'));   
    select T_Frontiere(f.country2,f.country2 ,f.length)  
      bulk collect into tmpFrontiere
      from LesFrontieres f 
      where f.country1 = code
      Union all
      select T_Frontiere(f.country1,f.country1 ,f.length)  
      from LesFrontieres f 
      where f.country2 = code;
      for indx IN 1..tmpFrontiere.COUNT
      loop
         output := XMLType.appendchildxml(output,'country/borders', tmpFrontiere(indx).toXML());   
      end loop;
        
    return output;
   end;
end;
/
create table LesPays of T_Pays;
/
create or replace type T_ensPays as table of T_Pays;
/
-------------------------------------------------------
create or replace type body T_Continent as
 member function toXML return XMLType is
   output XMLType;
   tmpPays T_ensPays;
   begin
      output := XMLType.createxml('<continent   name ="'||name||'"/>');
     select value(p) bulk collect into tmpPays
      from LesPays p, LesEncompasses e
      where e.country=p.code and e.continent=self.name
      order by p.population desc;
      for indx IN 1..tmpPays.COUNT
      loop
         output := XMLType.appendchildxml(output,'continent', tmpPays(indx).toXML());   
      end loop;
      return output;
   end;
end;
/
create table LesContinents of T_Continent;
/
create or replace type T_ensContinent as table of T_Continent;
/
---------
/
create or replace type body T_Mondial as
   member function toXML return XMLType is
   output XMLType;
   tmpContinent T_ensContinent;
   begin
      output := XMLType.createxml('<mondial/>');
      select value(c) bulk collect into tmpContinent
      from LesContinents c;
      for indx IN 1..tmpContinent.COUNT
      loop
         output := XMLType.appendchildxml(output,'mondial', tmpContinent(indx).toXML());   
      end loop;
      return output;
   end;
end;
/
create table MondialTable of T_Mondial;
/
/*------------------------INSERTION DANS LES TABLES------------------------*/
  -------------------------------------------------------------------------
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
   select T_Continent(c.name,c.area)
   from  CONTINENT c;
/         
insert into LesMontagnes
  select T_Montagne(m.name, m.mountains, m.height, 
         m.type, g.country,T_Coordonnee(m.coordinates.latitude,m.coordinates.longitude), g.province ) 
         from MOUNTAIN m, GEO_MOUNTAIN g
         where g.MOUNTAIN=m.NAME;

insert into LesMembres
  select T_Membre(m.country,m.organization, m.type)
         from ISMEMBER m;
/
insert into LesOrganisations
        select T_Organisation( o.abbreviation, o.name, o.city, o.country, o.province, o.established) 
         from ORGANIZATION o
         where o.country is NOT NULL; --On ne prend pas en compte les organisation qui n'on pas de pays
/
insert into LesEncompasses
      select T_Encompasse(e.country, e.continent, e.percentage)
      from ENCOMPASSES e;
/
insert into LesRivieres
      select T_Riviere(g.river, g.country)
      from GEO_RIVER g;
/
insert into LesFrontieres 
  select T_Frontiere( b.country1, b.country2, b.length) 
         from BORDERS b;
/ 
insert into MondialTable Values(T_Mondial(1));

/*------------------------EXPORTATION------------------------*/
  -----------------------------------------------------------      
WbExport -type=text
         -file='exo3.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=' \t'
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select m.toXML().getClobVal() 
from MondialTable m;
