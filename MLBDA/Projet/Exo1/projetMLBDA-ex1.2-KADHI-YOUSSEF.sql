/*------------------------DROP TABLE & TYPE------------------------*/
  -----------------------------------------------------------------
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
/*------------------------CREATION DES TYPES------------------------*/
  ------------------------------------------------------------------
Create or replace type T_Mondial as object(
   NB number, --variable fictive pour ne pas avoir un erreur car type vide
   member function toXML return XMLType
)
/
Create or replace type T_Pays as object(
   NAME        VARCHAR2(35 Byte), --Nom du pays
   CODE        VARCHAR2(4 Byte),  --Code du pays
   CAPITAL     VARCHAR2(35 Byte), --Capitale du pays
   PROVINCE    VARCHAR2(35 Byte), --Province de la capitale
   AREA        NUMBER,            --Surface du pays
   POPULATION  NUMBER,            --Population du pays
   member function toXML return XMLType   
)
/
create or replace type T_Organisation as object(
   ABBREVIATION  VARCHAR2(12 Byte), --Abbreviation de l'organisation
   NAME          VARCHAR2(80 Byte), --Nom de l'organisation
   CITY          VARCHAR2(35 Byte), --Ville où est situé le "headquarter"
   COUNTRY       VARCHAR2(4 Byte) , --Code du pays où est situé l'organisation 
   PROVINCE      VARCHAR2(35 Byte), --Le nom de la province où est situé l'organisation
   ESTABLISHED   DATE,              --Date de création de l'organisation 
   member function toXML return XMLType
)
/
create or replace type T_Membre as object( --Type pour lier les organisations et les pays membre
   COUNTRY       VARCHAR2(4 Byte), --Code du pays membre
   ORGANIZATION  VARCHAR2(12 Byte),--Nom de l'organisation
   TYPE          VARCHAR2(35 Byte) --Type d'organisation
)
/
create table LesMembres of T_Membre;
/
create or replace type T_Langage as object( 
   COUNTRY     VARCHAR2(4 Byte), --Code du pays
   NAME        VARCHAR2(50 Byte),--Nom de la langue
   PERCENTAGE  NUMBER,           --Pourcentage de la langue dans ce pays
   member function toXML return XMLType
)
/
create or replace type T_Frontiere as object(
   COUNTRY1  VARCHAR2(4 Byte),--Code du pays1
   COUNTRY2  VARCHAR2(4 Byte),--Code du pays2
   LENGTH    NUMBER,          --Taille de la frontière entre les deux pays
   member function toXML return XMLType
)
/
/*------------------------CREATION DES FONCTIONS & TABLES------------------------*/
  -------------------------------------------------------------------------------

---------------------T_FRONTIERE---------------------
/*<!ELEMENT border EMPTY>
<!ATTLIST border countryCode CDATA #REQUIRED
                 length CDATA #REQUIRED >*/
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

---------------------T_LANGAGE---------------------
/*<!ELEMENT language EMPTY >
<!ATTLIST language language CDATA #REQUIRED
                   percent  CDATA #REQUIRED >*/
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

-----------------------T_PAYS-----------------------
/*<!ELEMENT country (language*, borders) >
<!ATTLIST country code CDATA #IMPLIED
                  name CDATA #REQUIRED 
                  population CDATA #REQUIRED > */
create or replace type body T_Pays as
   member function toXML return XMLType is
   output XMLType;
   tmpLangage T_ensLangage;
   tmpFrontiere T_ensFrontiere;
   begin
      if code is null then --code est un #IMPLIED
         output := XMLType.createxml('<country name="'||name||'" population ="'||population ||'"/>');
      else
         output := XMLType.createxml('<country code ="'||code||'" name="'||name||'" population ="'||population ||'"/>');
      end if;

      select value(c) bulk collect into tmpLangage --Toutes les langues parlé dans le pays
      from LesLangages c
      where code = c.country ;  
      for indx IN 1..tmpLangage.COUNT
      loop
         output := XMLType.appendchildxml(output,'country', tmpLangage(indx).toXML());
      end loop;

      output := XMLType.appendchildxml(output,'country', XMLType('<borders/>'));   
      
      select T_Frontiere(f.country2,f.country2 ,f.length)  --Toutes le pays frontalier du notre,T_frontiere n'etant pas symetrique, je fais un union pour recuperer les pays dans les deux sens
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

---------------------T_ORGANISATION---------------------
--<!ELEMENT organization (country+, headquarter) >
create or replace type body T_Organisation as
   member function toXML return XMLType is
   output XMLType;
   tmpPays T_ensPays;
   begin
      output := XMLType.createxml('<organization/>');

      select value(c) bulk collect into tmpPays --Les pays membre de l'organisation
      from LesPays c, LesMembres m
      where country = c.code and m.organization=abbreviation and m.country=c.code
      order by c.name asc ;  
      for indx IN 1..tmpPays.COUNT
      loop
         output := XMLType.appendchildxml(output,'organization', tmpPays(indx).toXML());   
      end loop;
      /*<!ELEMENT headquarter EMPTY>
      <!ATTLIST headquarter name CDATA #REQUIRED>*/
      output := XMLType.appendchildxml(output,'organization', XMLType('<headquarter name="'||city||'"/>'));
      return output;
   end;
end;
/
create table LesOrganisations of T_Organisation;
/
create or replace type T_ensOrganisation as table of T_Organisation;
/

---------------------T_MONDIAL---------------------
--<!ELEMENT mondial (organization+) >
create or replace type body T_Mondial as
   member function toXML return XMLType is
   output XMLType;
   tmpOrganisation T_ensOrganisation;
   begin
      output := XMLType.createxml('<mondial/>');

      select value(p) bulk collect into tmpOrganisation --toutes les organisations
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

/*------------------------INSERTION DANS LES TABLES------------------------*/
  -------------------------------------------------------------------------
insert into LesMondial Values(T_Mondial(0));
/
insert into LesPays --on insert tous les pays
  select T_Pays(c.name, c.code, c.capital, 
         c.province, c.area, c.population) 
         from COUNTRY c
         order by name desc;
/
insert into LesOrganisations --on insert toutes les organisations
        select T_Organisation( o.abbreviation, o.name, o.city, o.country, o.province, o.established) 
         from ORGANIZATION o
         where o.country is NOT NULL;
/
insert into LesLangages --On insert toutes les langues
  select T_Langage( l.country, l.name, l.percentage) 
         from LANGUAGE l;
/
insert into LesFrontieres --On insert toutes les frontières 
  select T_Frontiere( b.country1, b.country2, b.length) 
         from BORDERS b;
/         
insert into LesMembres --on insert tout les pays membre de chaque organisation
  select T_Membre(m.country,m.organization, m.type)
         from ISMEMBER m;
/

/*------------------------EXPORTATION------------------------*/
  -----------------------------------------------------------

WbExport -type=text
         -file= 'Youssef_KADHI_Exo1-2.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select m.toXML().getClobVal() 
from LesMondial m;
