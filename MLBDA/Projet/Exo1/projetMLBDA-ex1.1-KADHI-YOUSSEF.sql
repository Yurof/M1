alter session set ddl_lock_timeout = 10/
/*------------------------DROP TABLE & TYPE------------------------*/
  -----------------------------------------------------------------
drop table LesPays;
/
drop table lesProvinces;
/
drop table LesContinents;
/
drop table LesAeroport;
/
drop table LesMontagnes;
/
drop table LesDeserts;
/
drop table LesIles;
/
drop table MondialTable; 
/
drop type T_Mondial force;
/
drop type T_Coordonnee force;
/
drop type T_Pays force;
/
drop type T_Province force;
/
drop type T_Continent force;
/
drop type T_Montagne force;
/
drop type T_Ile force;
/
drop type T_Aeroport force;
/
drop type T_Desert force;
/
drop type T_ensAeroport force;
/
drop type T_ensContinent force;
/
drop type T_ensDesert force;
/
drop type T_ensIle force;
/
drop type T_ensMontagne force;
/
drop type T_ensPays force;
/
drop type T_ensProvince force;
/
/*------------------------CREATION DES TYPES------------------------*/
  ------------------------------------------------------------------
Create or replace type T_Mondial as object(
   N number, --variable fictive pour ne pas avoir un erreur car type vide
   member function toXML return XMLType
)
/
Create or replace type T_Coordonnee as object( --type creer pour avoir les coordonnées des îles
   LATITUDE NUMBER,
   LONGITUDE NUMBER,
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
Create or replace type T_Province as object(
   NAME        VARCHAR2(35 Byte), --Nom de la province
   COUNTRY     VARCHAR2(4 Byte),  --Pays auquel appartient la province
   POPULATION  NUMBER,            --Population de la province 
   AREA        NUMBER,            --Surface de la province
   CAPITAL     VARCHAR2(35 Byte), --Capitate de la Province 
   CAPPROV     VARCHAR2(35 Byte), --Nom de la province qui appartient a la capitale
   member function toXML return XMLType
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
Create or replace  type T_Montagne as object ( --type Montagne auquel on ajoute la province
   NAME         VARCHAR2(35 Byte), --Nom de la montagne
   MOUNTAINS    VARCHAR2(35 Byte), --Les Montagnes auquelles elle appartient
   HEIGHT       NUMBER,            --Elevation max du sommet de la montagne
   TYPE         VARCHAR2(10 Byte), --Type de montagne
   COORDINATES  T_Coordonnee,      --Coordonnée de la montagne
   INPROVINCE VARCHAR2(35 Byte),   --Province a la quelle appartient la montagne 
   member function toXML return XMLType
)
/
Create or replace  type T_Ile as object (--type Ile auquelle on ajoute la province
   NAME         VARCHAR2(35 Byte), --Nom de l'île
   ISLANDS      VARCHAR2(35 Byte), --Les îles auquelles elle appartient
   AREA         NUMBER,            --Surface de l'ile 
   HEIGHT       NUMBER,            --Elevation max de l'ile
   TYPE         VARCHAR2(10 Byte), --Type de l'ile
   COORDINATES  T_Coordonnee,      --Coordonnée de l'ile
   INPROVINCE VARCHAR2(35 Byte),   --Province a la quelle appartient l'ile 
   member function toXML return XMLType
)
/
Create or replace  type T_Aeroport as object (
   IATACODE   VARCHAR2(3 Byte),    --IATA code 
   NAME       VARCHAR2(100 Byte),  --Nom de l'aéroport
   COUNTRY    VARCHAR2(4 Byte),    --Code du pays auquel appartient l'aéroport 
   CITY       VARCHAR2(50 Byte),   --Ville auquel appartient l'aéroport 
   PROVINCE   VARCHAR2(50 Byte),   --Province auquel appartient l'aéroport 
   ISLAND     VARCHAR2(50 Byte),   --Nom de l'ile si elle est situé sur une ile
   LATITUDE   NUMBER,               
   LONGITUDE  NUMBER,                
   ELEVATION  NUMBER,                               
   GMTOFFSET  NUMBER,
   member function toXML return XMLType
)
/
Create or replace  type T_Desert as object ( --Type Desert auquel on ajoute la province 
   NAME         VARCHAR2(35 Byte), --Nom du desert
   AREA         NUMBER,            --Surface du desert
   COORDINATES  T_Coordonnee,      --Coordonnée du desert 
   INPROVINCE VARCHAR2(35 Byte),   --Province a la quelle appartient le desert
   member function toXML return XMLType
)
/
/*------------------------CREATION DES FONCTIONS & TABLES------------------------*/
  -------------------------------------------------------------------------------

-------------------T_AEROPORT-------------------
/*<!ELEMENT airport EMPTY>
<!ATTLIST airport name CDATA #REQUIRED 
 nearCity CDATA #IMPLIED >*/
Create or replace type body T_Aeroport as
 member function toXML return XMLType is
   output XMLType; 
   Begin
      if city is null then --nearcity est un IMPLIED
         output := XMLType.createxml('<airport  name ="'||name||'"/>'); --name CDATA #REQUIRED 
      else
         output := XMLType.createxml('<airport  name ="'||name||'" nearcity="'||city||'"/>'); --name CDATA #REQUIRED 
         End if;
         return output;
   End;
End;
/
Create table LesAeroport of T_Aeroport;
/
Create or replace type T_ensAeroport as table of T_Aeroport;
/

--------------------T_CONTINENT--------------------
/*<!ELEMENT continent EMPTY >
<!ATTLIST continent name CDATA #REQUIRED 
                      percent CDATA #REQUIRED >*/
Create or replace type body T_Continent as
 member function toXML return XMLType is
   output XMLType;
   Begin
      output := XMLType.createxml('<continent   name ="'||name  ||'" percent ="'||percentage||'"/>');
      return output;
   End;
End;
/
Create table LesContinents of T_Continent;
/
Create or replace type T_ensContinent as table of T_Continent;
/

-------------------T_COORDONNEE-------------------
/*<!ELEMENT coordinates EMPTY >
<!ATTLIST coordinates latitude CDATA #REQUIRED
                        longitude CDATA #REQUIRED>*/
Create or replace type body T_Coordonnee as
 member function toXML return XMLType is
   output XMLType;
   Begin
      output := XMLType.createxml('<coordinates  latitude ="'||latitude ||'" longitude ="'||longitude ||'"/>');
      return output;
   End;
End;
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

---------------------T_DESERT---------------------
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

-------------------T_MONTAGNE-------------------
/*<!ELEMENT mountain EMPTY >
<!ATTLIST mountain name CDATA #REQUIRED 
                   height CDATA #REQUIRED >*/
Create or replace type body T_Montagne as
 member function toXML return XMLType is
   output XMLType;
   Begin
      output := XMLType.createxml('<mountain name ="'||name||'" height="'||height||'"/>'); 
      return output;
   End;
End;
/
Create table LesMontagnes of T_Montagne;
/
Create or replace type T_ensMontagne as table of T_Montagne;
/

---------------------T_PROVINCE---------------------
/*<!ATTLIST province name CDATA #REQUIRED 
                      capital CDATA #REQUIRED >*/
/*<!ELEMENT province ( (mountain|desert)*, island* ) >
 en réalité je l'implemente comme cela :"province ( mountain*,desert*, island* )" qui respect aussi la dtd*/
Create or replace type body T_Province as    
   member function toXML return XMLType is
   output XMLType;
   tmpMontagne T_ensMontagne;
   tmpIle T_ensIle;
   tmpDesert T_ensDesert;
   Begin
      output := XMLType.createxml('<province name ="'||self.name||'" capital="'||capital||'"/>');   
      
      Select value(m) bulk collect into tmpMontagne --Toutes les montagnes dans la province 
      From LesMontagnes m
      Where self.name = m.inprovince ;  
      for indx IN 1..tmpMontagne.COUNT
      loop
         output := XMLType.appEndchildxml(output,'province', tmpMontagne(indx).toXML());   
      End loop;
      
      Select value(m) bulk collect into tmpDesert --Tous les deserts dans la province 
      From LesDeserts m
      Where self.name = m.inprovince ;  
      for indx IN 1..tmpDesert.COUNT
      loop
         output := XMLType.appEndchildxml(output,'province', tmpDesert(indx).toXML());   
      End loop;
      
      Select value(i) bulk collect into tmpIle --Toutes les montagnes dans la province 
      From LesIles i
      Where self.name = i.inprovince ;  
      for indx IN 1..tmpIle.COUNT
      loop
         output := XMLType.appEndchildxml(output,'province', tmpIle(indx).toXML());   
      End loop;
      return output;
   End;
End;
/           
Create table LesProvinces of T_Province;
/
Create or replace type T_ensProvince as table of T_Province;
/

---------------------T_PAYS---------------------
--<!ELEMENT country (continent+, province+, airport*) >
/*<!ATTLIST country idcountry ID #REQUIRED
                  nom CDATA #REQUIRED>*/
Create or replace type body T_Pays as    
   member function toXML return XMLType is
   output XMLType;
   tmpContinent T_ensContinent;
   tmpProvince T_ensProvince;
   tmpAeroport T_ensAeroport;
   Begin
      output := XMLType.createxml('<country idcountry ="'||code||'" nom="'||name||'"/>'); 
      
      Select value(c) bulk collect into tmpContinent --Le(s) continent(s) auquel appartient le pays
      From LesContinents c
      Where code = c.incountry ;  
      for indx IN 1..tmpContinent.COUNT
      loop
         output := XMLType.appEndchildxml(output,'country', tmpContinent(indx).toXML());   
      End loop;
      
      Select value(p) bulk collect into tmpProvince --Les provinces du pays dans l'ordre alphabetique pour simplifier la vérification
      From LesProvinces p
      Where code = p.country
      order by p.name asc ;  
      for indx IN 1..tmpProvince.COUNT
      loop
         output := XMLType.appEndchildxml(output,'country', tmpProvince(indx).toXML());   
      End loop;
      
      Select value(a) bulk collect into tmpAeroport --Les aéroports du pays dans l'ordre alphabetique pour simplifier la vérification
      From LesAeroport a
      Where code = a.country 
      order by a.name asc;  
      for indx IN 1..tmpAeroport.COUNT
      loop
         output := XMLType.appEndchildxml(output,'country', tmpAeroport(indx).toXML());   
      End loop;
      return output;
   End;
End;
/
Create table LesPays of T_Pays;
/
Create or replace type T_ensPays as table of T_Pays;
/

--------------------T_MONDIAL--------------------
--<!ELEMENT mondial (country+) >
Create or replace type body T_Mondial as 
   member function toXML return XMLType is
   output XMLType;
   tmpPays T_ensPays;
   Begin
      output := XMLType.createxml('<mondial/>');

      Select value(p) bulk collect into tmpPays --Toutes les pays dans l'ordre alphabetique pour simplifier la vérification
      From LesPays p
      Order by p.name asc;
      for indx IN 1..tmpPays.COUNT
      loop
         output := XMLType.appEndchildxml(output,'mondial', tmpPays(indx).toXML());   
      End loop;
      return output;
   End;
End;
/
Create table MondialTable of T_Mondial;
/

/*------------------------INSERTION DANS LES TABLES------------------------*/
  -------------------------------------------------------------------------
insert into LesPays --on insert tous les pays
  Select T_Pays(c.name, c.code, c.capital, 
         c.province, c.area, c.population) 
         From COUNTRY c;
/
insert into LesProvinces   --on insert toutes les provinces
  Select T_Province(p.name, p.country,p.population,p.area,p.capital,p.capprov ) 
         From PROVINCE p;    
/
insert into LesContinents --on insert chaque pays avec son continent 
   Select T_Continent(c.name, c.area, e.percentage,
   e.country)
   From ENCOMPASSES e, CONTINENT c
   Where c.name=e.continent;
/
insert into LesAeroport --on insert tous les aéroports
   Select T_Aeroport(a.iatacode, a.name, a.country,
                    a.city, a.province, a.island, a.latitude,
                    a.longitude, a.elevation, a.gmtoffset)
   From AIRPORT a;
  /           
insert into LesMontagnes   --on insert toutes les montagnes et leur province associées
   Select T_Montagne(m.name, m.mountains, m.height, m.type,
                    T_Coordonnee(m.coordinates.latitude,m.coordinates.longitude), g.province ) 
   From MOUNTAIN m, GEO_MOUNTAIN g
   Where g.MOUNTAIN=m.NAME;
/
insert into LesDeserts  --on insert toutes les deserts et leur province associées
  Select T_Desert(d.name, d.area,
                  T_Coordonnee(d.coordinates.latitude,d.coordinates.longitude), g.province ) 
         From DESERT d, GEO_DESERT g
         Where g.DESERT=d.NAME;
/
insert into LesIles --on insert toutes les iles et leur province associées
  Select T_Ile(i.name, i.islands, i.area, i.height, i.type,
                T_Coordonnee(i.coordinates.latitude,i.coordinates.longitude), g.province ) 
         From ISLAND i, GEO_ISLAND g
         Where g.island=i.name;
/
insert into MondialTable Values(T_Mondial(1)); --sert pour avoir <mondial> en racine 
/

/*------------------------EXPORTATION------------------------*/
  -----------------------------------------------------------

WbExport -type=text
         -file='Youssef_KADHI_Exo1-1.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=' \t'
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
Select m.toXML().getClobVal() 
From MondialTable m;
