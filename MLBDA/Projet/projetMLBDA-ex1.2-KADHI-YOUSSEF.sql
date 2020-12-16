/*
drop table LesFrontieres;
/
drop table LesLangages;
/
drop table LesMembres;
/
drop table LesMondial;
/
drop table LesOrganisations;
/
drop table LesPays;
/
drop type  T_ensFrontiere force;
/
drop type  T_ensLangage force;
/
drop type  T_ensPays force;
/
drop type  T_ensOrganisation force;
/
drop type  T_Frontiere force;
/
drop type  T_Langage force;
/
drop type  T_Pays force;
/
drop type  T_Organisation force;
/
drop type  T_Mondial force;
/
drop type  T_Membre force;
/
*/
-----------------------------------------------
create or replace type T_Mondial as object(
   nombre number, --uniquement la pour ne pas avoir un erreur car type vide 
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
create or replace type T_Langage as object(
   COUNTRY     VARCHAR2(4 Byte),
   NAME        VARCHAR2(50 Byte),
   PERCENTAGE  NUMBER,
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
create or replace type body T_Langage as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<language  language  ="'||NAME||'" percent  ="'||PERCENTAGE||'"/>');
      return output;
   end;
end;
/
create table LesLangages of T_Langage;
/
create or replace type T_ensLangage as table of T_Langage;
/
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
create or replace type body T_Pays as
   member function toXML return XMLType is
   output XMLType;
   tmpLangage T_ensLangage;
   tmpFrontiere1 T_ensFrontiere;
   tmpFrontiere2 T_ensFrontiere;
    begin
    output := XMLType.createxml('<country code ="'||code||'" name="'||name||'" population ="'||population ||'"/>');
    
    select value(c) bulk collect into tmpLangage
    from LesLangages c
    where code = c.country ;  
    for indx IN 1..tmpLangage.COUNT
    loop
      output := XMLType.appendchildxml(output,'country', tmpLangage(indx).toXML());
    end loop;
  output := XMLType.appendchildxml(output,'country', XMLType('<borders/>'));   
  select T_Frontiere(f.country2,f.country2 ,f.length)  
  bulk collect into tmpFrontiere1
  from LesFrontieres f 
  where f.country1 = code;
  select T_Frontiere(f.country1,f.country1 ,f.length)  
  bulk collect into tmpFrontiere2
  from LesFrontieres f 
  where f.country2 = code;
  tmpFrontiere1 :=tmpFrontiere1 MULTISET UNION tmpFrontiere2;
      for indx IN 1..tmpFrontiere1.COUNT
    loop
      output := XMLType.appendchildxml(output,'country/borders', tmpFrontiere1(indx).toXML());   
    end loop;
    
    return output;
   end;
end;
/
create table LesPays of T_Pays;
/
create or replace type T_ensPays as table of T_Pays;
/
create or replace type body T_Organisation as
   member function toXML return XMLType is
   output XMLType;
   tmpPays T_ensPays;
   
    begin
    output := XMLType.createxml('<organization/>');
    
    select value(c) bulk collect into tmpPays
    from LesPays c, LesMembres m
    where country = c.code and m.organization=abbreviation and m.country=c.code ;  
    for indx IN 1..tmpPays.COUNT
    loop
      output := XMLType.appendchildxml(output,'organization', tmpPays(indx).toXML());   
    end loop;
    output := XMLType.appendchildxml(output,'organization', XMLType('<headquarter name="'||city||'"/>'));
    return output;
   end;
end;
/
create table LesOrganisations of T_Organisation;
/
create or replace type T_ensOrganisation as table of T_Organisation;
/
create or replace type body T_Mondial as
   member function toXML return XMLType is
   output XMLType;
   tmpOrganisation T_ensOrganisation;
   begin
      output := XMLType.createxml('<mondial/>');
      select value(p) bulk collect into tmpOrganisation
      from LesOrganisations p;
      for indx IN 1..tmpOrganisation.COUNT
      loop
         output := XMLType.appendchildxml(output,'mondial', tmpOrganisation(indx).toXML());   
      end loop;
      return output;
   end;
end;
/
create table LesMondial of T_Mondial;

insert into LesMondial Values(T_Mondial(0));
/
insert into LesPays
  select T_Pays(c.name, c.code, c.capital, 
         c.province, c.area, c.population) 
         from COUNTRY c
         order by name desc;
/
insert into LesOrganisations
        select T_Organisation( o.abbreviation, o.name, o.city, o.country, o.province, o.established) 
         from ORGANIZATION o
         where o.country is NOT NULL;
/
insert into LesLangages
  select T_Langage( l.country, l.name, l.percentage) 
         from LANGUAGE l;
/
insert into LesFrontieres
  select T_Frontiere( b.country1, b.country2, b.length) 
         from BORDERS b;
/         
insert into LesMembres
  select T_Membre(m.country,m.organization, m.type)
         from ISMEMBER m;
/
         
WbExport -type=text
         -file='mondial2.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select m.toXML().getClobVal() 
from LesMondial m;
