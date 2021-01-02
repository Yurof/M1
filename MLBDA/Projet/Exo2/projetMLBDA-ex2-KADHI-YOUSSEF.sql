alter session set ddl_lock_timeout = 10;
/

/*------------------------DROP TABLE & TYPE------------------------*/
  -----------------------------------------------------------------
/*
drop table LesDeserts;
/
drop table LesIles;
/
drop table LesMontagnes;
/
drop table lesPays;
/
drop type force T_Desert;
/
drop type force T_ensDesert;
/
drop type force T_ensGeo;
/
drop type force T_ensIle;
/
drop type force T_ensMontagne;
/
drop type force T_ensPays;
/
drop type force T_Exo2;
/
drop type force T_Geo;
/
drop type force T_Ile;
/
drop type force T_Montagne;
/
drop type force T_Pays;
/
*/
/*------------------------CREATION DES TYPES------------------------*/
  ------------------------------------------------------------------
create or replace type T_Exo2 as object(
   NB number, --variable fictive pour ne pas avoir un erreur car type vide
   member function toXML return XMLType
)
/
Create or replace type T_Coordonnee as object( --type creer pour avoir les coordonnées des îles
   LATITUDE NUMBER,
   LONGITUDE NUMBER,
   member function toXML return XMLType
)
/
Create or replace  type T_Montagne as object ( --type Montagne auquel on ajoute le pays
   NAME         VARCHAR2(35 Byte), --Nom de la montagne
   MOUNTAINS    VARCHAR2(35 Byte), --Les Montagnes a laquel elle appartient
   HEIGHT       NUMBER,            --Elevation max du sommet de la montagne
   TYPE         VARCHAR2(10 Byte), --Type de montagne
   INCOUNTRY VARCHAR2(4 Byte),     --Code du pays où est situé
   member function toXML return XMLType
)
/
Create or replace  type T_Ile as object (--type Ile auquel on ajoute le pays
   NAME         VARCHAR2(35 Byte), --Nom de l'île
   ISLANDS      VARCHAR2(35 Byte), --Les îles a laquel elle appartient
   AREA         NUMBER,            --Surface de l'ile 
   HEIGHT       NUMBER,            --Elevation max de l'ile
   TYPE         VARCHAR2(10 Byte), --Type de l'ile
   COORDINATES  T_Coordonnee,      --Coordonnée de l'ile
   INCOUNTRY VARCHAR2(4 Byte),     --Code du pays a la quelle appartient l'ile 
   member function toXML return XMLType
)
/
Create or replace  type T_Desert as object ( --Type Desert auquel on ajoute le pays 
   NAME         VARCHAR2(35 Byte), --Nom du desert
   AREA         NUMBER,            --Surface du desert
   INCOUNTRY VARCHAR2(4 Byte),     --Code du pays auquel il appartient
   member function toXML return XMLType
)
/
create or replace  type T_Geo as object ( --type pour lier les pays a leur geographie(montagnes, iles, deserts)
  country VARCHAR2(4 Byte),
  --MONTAGNE T_Montagne,
  --ILE T_Ile,
  --DESERT T_Desert,
  member function toXML return XMLType
  )

/
create or replace type T_Pays as object(
   NAME        VARCHAR2(35 Byte), --Nom du pays
   CODE        VARCHAR2(4 Byte),  --Code du pays
   CAPITAL     VARCHAR2(35 Byte), --Capitale du pays
   PROVINCE    VARCHAR2(35 Byte), --Province de la capitale
   AREA        NUMBER,            --Surface du pays
   POPULATION  NUMBER,            --Population du pays
   member function toXML return XMLType,
   member function toPeak return number, --fonction pour avoir le plus haut sommet
   member function toPrincipalContinent return varchar2, --fonction pour avoir le continent principale du pays
   member function toBlength return number --fonction pour avoir la longueur totale de la frontière
)
/
Create or replace type T_Continent as object( --Ce type relie chaque pays a son/ces continent(s)
   NAME  VARCHAR2(20 Byte),       --Nom du continent
   AREA  NUMBER(10),              --Surface du continent
   PERCENTAGE  NUMBER,            --Pourcentage du pays qui appartient au continent
   INCOUNTRY VARCHAR2(4 Byte),    --Nom du pays
   member function toXML return XMLType
)
/
create table LesContinents of T_Continent;
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

--------------------T_COORDONNEE--------------------
/*<!ELEMENT coordinates EMPTY >
<!ATTLIST coordinates latitude CDATA #REQUIRED
                      longitude CDATA #REQUIRED>*/
create or replace type body T_Coordonnee as
   member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<coordinates  latitude ="'||latitude ||'" longitude ="'||longitude ||'"/>');
      return output;
   end;
end;
/

--------------------T_MONTAGNE--------------------
/*<!ELEMENT mountain EMPTY >
<!ATTLIST mountain name CDATA #REQUIRED 
                   height CDATA #REQUIRED >*/
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

--------------------T_DESERT--------------------
/*<!ELEMENT desert EMPTY >
<!ATTLIST desert name CDATA #REQUIRED 
                 area CDATA #IMPLIED >*/
Create or replace type body T_Desert as
 member function toXML return XMLType is
   output XMLType;
   Begin
      if area is null then --A cause du IMPLIED on verifie si area existe pour notre desert
         output := XMLType.createxml('<desert name ="'||name||'"/>');     
      else
         output := XMLType.createxml('<desert name ="'||name||'" area="'||area||'"/>'); 
      End if;
      return output;
   End;
End;
/
Create table LesDeserts of T_Desert;
/
Create or replace type T_ensDesert as table of T_Desert;
/
---------------------T_ILE---------------------
--<!ELEMENT island (coordinates?) >
--<!ATTLIST island name CDATA #REQUIRED >
Create or replace type body T_Ile as
 member function toXML return XMLType is
   output XMLType;
   Begin
      output := XMLType.createxml('<island name ="'||name||'"/>');
        
      if  coordinates.latitude is not null and coordinates.longitude is not null then --Une île n'a pas obligatoirement de coordonnées
        output := XMLType.appEndchildxml(output,'island', coordinates.toXML()); 
      end if;  
      return output;
   End;
End;
/
Create table LesIles of T_Ile;
/
Create or replace type T_ensIle as table of T_Ile;
/

--------------------T_FRONTIERE--------------------
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

-----------------------T_GEO-----------------------
/*<!ELEMENT geo ( (mountain|desert)*, island* ) >
<!ELEMENT mountain EMPTY >
<!ATTLIST mountain name CDATA #REQUIRED 
                   height CDATA #REQUIRED >*/
--en réalité je l'implemente comme cela :"geo ( mountain*,desert*, island* )" qui respect aussi la dtd*/

create or replace type body T_GEO as
   member function toXML return XMLType is
   output XMLType;
   tmpMontagne T_ensMontagne;
   tmpIle T_ensIle;
   tmpDesert T_ensDesert;
   begin
      output := XMLType.createxml('<geo/>');

      select value(m) bulk collect into tmpMontagne--Toutes les montagnes dans le pays
      from LesMontagnes m
      where country = m.incountry ;  
      for indx IN 1..tmpMontagne.COUNT
      loop
         output := XMLType.appendchildxml(output,'geo', tmpMontagne(indx).toXML());   
      end loop;
      
      select value(d) bulk collect into tmpDesert --Tous les deserts dans le pays
      from LesDeserts d
      where country = d.incountry ;  
      for indx IN 1..tmpDesert.COUNT
      loop
         output := XMLType.appendchildxml(output,'geo', tmpDesert(indx).toXML());   
      end loop;
      
      select value(i) bulk collect into tmpIle --Toutes les montagnes dans le pays 
      from Lesiles i
      where country = i.incountry ;  
      for indx IN 1..tmpIle.COUNT
      loop
         output := XMLType.appendchildxml(output,'geo', tmpIle(indx).toXML());   
      end loop;

      return output;
   end;
end;
/         
create table LesGEO of T_GEO;
/
create or replace type T_ensGEO as table of T_GEO;
/

---------------------T_PAYS----------------------
/*<!ELEMENT country (geo, peak?, contCountries) >
<!ATTLIST country name CDATA #REQUIRED continent CDATA #REQUIRED blength CDATA #REQUIRED> */
create or replace type body T_Pays as

  --function toPeak servant a retrouver le plus haut sommet :
  /*<!ELEMENT peak EMPTY > 
   <!ATTLIST peak height CDATA #REQUIRED > */
   member function toPeak return number is
   hauteur number; --variable qui stock la hauteur du plus haut sommet, qui vaut 0 si il n'ya pas de montagne
   begin
      begin
         select distinct m.height into hauteur
         from LesMontagnes m
         where code=m.incountry and m.height>=all(select m.height From LesMontagnes m where m.incountry=code);
         EXCEPTION
         when NO_DATA_FOUND then
            hauteur := 0;
      end;
      return hauteur;
   end;

   --fonction toPrincipalContinent qui sert a retrouvé le continent principal
   member function toPrincipalContinent return varchar2 is
   continant varchar2(20 Byte); 
   begin
      begin
         select c.name into continant 
         from LesContinents c
         where code = c.incountry and c.percentage>=all(select c.percentage from LesContinents c where code = c.incountry);
      end;
      return continant;
   end;

   --fonction toBlength qui sert a avoir la somme des frontiere de notre pays, 0 si il n(yen a pas 
   member function toBlength return number is
   somme number;
   begin
      begin
         select sum(f.length) into somme 
         from LesFrontieres f
         where code=f.country1 or code=f.country2;
         end;
      if somme is null then 
        somme:=0 ;
      end if;
      return somme;
   end;

   member function toXML return XMLType is
   output XMLType;
   tmpGeo T_ensGeo;
   tmpFrontiere T_ensFrontiere;
   begin
      output := XMLType.createxml('<country name="'||name||'" continent="'||toPrincipalContinent()||'" blength="'||toBlength||'"/>');       select value(g) bulk collect into tmpGeo
      from LesGEO g
      where code=g.country;
      for indx IN 1..tmpGeo.COUNT
      loop
         output := XMLType.appendchildxml(output,'country', tmpGeo(indx).toXML());  
      end loop; 

      if toPeak()!=0 then --Si le pays a une montagne, donne le sommet le plus haut
         output := XMLType.appendchildxml(output,'country', XMLType('<peak height ="'||toPeak()||'"/>'));
      end if;

      output := XMLType.appendchildxml(output,'country', XMLType('<contCountries/>'));   

      select T_Frontiere(f.country2,f.country2 ,f.length)   --Toutes le pays frontalier du notre appartenant au même continent,T_frontiere n'etant pas symetrique, je fais un union pour recuperer les pays dans les deux sens
      bulk collect into tmpFrontiere
      from LesFrontieres f, LesContinents c
      where f.country1 = code and c.incountry=f.country2 and self.toPrincipalContinent()=c.name
      Union all
      select T_Frontiere(f.country1,f.country1 ,f.length)  
      from LesFrontieres f , LesContinents c
      where f.country2 = code and c.incountry=f.country1 and self.toPrincipalContinent()=c.name;

      for indx IN 1..tmpFrontiere.COUNT
      loop
        output := XMLType.appendchildxml(output,'country/contCountries', tmpFrontiere(indx).toXML());   
      end loop;
 
      return output;
      end;
end;
/
create table LesPays of T_Pays;
/
create or replace type T_ensPays as table of T_Pays;
/
--------------------T_EXO2--------------------
--<!ELEMENT ex2 (country+) >
create or replace type body T_Exo2 as
   member function toXML return XMLType is
   output XMLType;
   tmpPays T_ensPays;
   begin
      output := XMLType.createxml('<ex2/>');

      select value(p) bulk collect into tmpPays --Tous les pays
      from LesPays p
          order by name asc;
      for indx IN 1..tmpPays.COUNT
      loop
         output := XMLType.appendchildxml(output,'ex2', tmpPays(indx).toXML());   
      end loop;
      return output;
   end;
end;
/
create table LesExo2 of T_Exo2;

/*------------------------INSERTION DANS LES TABLES------------------------*/
  -------------------------------------------------------------------------

insert into LesExo2 Values(T_Exo2(0));

insert into LesPays
  select T_Pays(c.name, c.code, c.capital, 
         c.province, c.area, c.population) 
         from COUNTRY c;
/          
insert into LesMontagnes
  select T_Montagne(m.name, m.mountains, m.height, 
         m.type, g.country ) 
         from MOUNTAIN m, GEO_MOUNTAIN g
         where g.MOUNTAIN=m.NAME;
/
insert into LesDeserts
  select T_Desert(d.name, d.area, g.country ) 
         from DESERT d, GEO_DESERT g
         where g.DESERT=d.NAME;
/
insert into LesIles
  select T_Ile(i.name, i.islands, i.area, i.height, i.type,T_Coordonnee(i.coordinates.latitude,i.coordinates.longitude), g.country ) 
         from ISLAND i, GEO_ISLAND g
         where g.island=i.name;
/
insert into LesGEO
  select T_GEO(c.code) 
         from COUNTRY c;
/
insert into LesContinents
   select T_Continent(c.name, c.area, e.percentage,
   e.country)
   from ENCOMPASSES e, CONTINENT c
   where c.name=e.continent;
/
insert into LesFrontieres
  select T_Frontiere( b.country1, b.country2, b.length) 
         from BORDERS b;
/
/*------------------------EXPORTATION------------------------*/
  -----------------------------------------------------------
      
WbExport -type=text
         -file='Youssef_KADHI_Exo2.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select e.toXML().getClobVal() 
from LesExo2 e;
