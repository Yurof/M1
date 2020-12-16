alter session set ddl_lock_timeout = 10;
/
drop table LesDeserts;
/
drop table LesIles;
/
drop table LesMontagnes;
/
drop table lesPays;
/
drop type force T_COORDONNEE;
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
----------------------------------------------
create or replace type T_Exo2 as object(
   nombre number,
   member function toXML return XMLType
)
/
create or replace type T_Coordonnee as object(
   latitude NUMBER,
   longitude NUMBER,
   member function toXML return XMLType
)
/
create or replace  type T_Montagne as object (
   NAME         VARCHAR2(35 Byte),
   MOUNTAINS    VARCHAR2(35 Byte),
   HEIGHT       NUMBER,
   TYPE         VARCHAR2(10 Byte),
   CODEPAYS         VARCHAR2(4),
   INCOUNTRY VARCHAR2(4 Byte),
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
   INCOUNTRY VARCHAR2(4 Byte),
   member function toXML return XMLType
)
/
create or replace  type T_Desert as object (
   NAME         VARCHAR2(35 Byte)  ,
   AREA         NUMBER,
   INCOUNTRY VARCHAR2(4 Byte),
   member function toXML return XMLType
)
/
create or replace  type T_Geo as object (
  country VARCHAR2(4 Byte),
  --MONTAGNE T_Montagne,
  --ILE T_Ile,
  --DESERT T_Desert,
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
   member function toXML return XMLType,
   member function toPeak return number 
)
/
-----------------------------------------------------------------------------------------------------------
create or replace type body T_Coordonnee as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<coordinates  latitude ="'||latitude ||'" longitude ="'||longitude ||'"/>');
      return output;
   end;
end;
/
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
create table LesDeserts of T_Desert;
/
create or replace type T_ensDesert as table of T_Desert;
/

-------
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
create or replace type body T_GEO as
   member function toXML return XMLType is
   output XMLType;
   tmpMontagne T_ensMontagne;
   tmpIle T_ensIle;
   tmpDesert T_ensDesert;
    begin
    output := XMLType.createxml('<geo/>');
    select value(m) bulk collect into tmpMontagne
    from LesMontagnes m
    where country = m.incountry ;  
    for indx IN 1..tmpMontagne.COUNT
    loop
      output := XMLType.appendchildxml(output,'geo', tmpMontagne(indx).toXML());   
    end loop;
    
    select value(d) bulk collect into tmpDesert
    from LesDeserts d
    where country = d.incountry ;  
    for indx IN 1..tmpDesert.COUNT
    loop
      output := XMLType.appendchildxml(output,'geo', tmpDesert(indx).toXML());   
    end loop;
    
    select value(i) bulk collect into tmpIle
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
create or replace type body T_Pays as
  member function toPeak return number is
     hauteur number;
    begin
    begin
      select distinct m.height into hauteur
      from LesMontagnes m
      where code=m.incountry and m.height>=all(select m.height From LesMontagnes m where m.incountry=code);
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
          hauteur := 0;
      end;
      return hauteur;
    END;
    
   member function toXML return XMLType is
   output XMLType;
   tmpGeo T_ensGeo;

    begin
    output := XMLType.createxml('<country name="'||name||'"/>');
    select value(g) bulk collect into tmpGeo
    from LesGEO g
    where code=g.country;
    for indx IN 1..tmpGeo.COUNT
    loop
    output := XMLType.appendchildxml(output,'country', tmpGeo(indx).toXML());  
    end loop; 
    output := XMLType.appendchildxml(output,'country', XMLType('<peak height ="'||toPeak()||'"/>'));  
    return output;
   end;
end;
/
----
create table LesPays of T_Pays;
/
create or replace type T_ensPays as table of T_Pays;
/
create or replace type body T_Exo2 as
   member function toXML return XMLType is
   output XMLType;
   tmpPays T_ensPays;
   begin
      output := XMLType.createxml('<ex2/>');
      select value(p) bulk collect into tmpPays
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

insert into LesExo2 Values(T_Exo2(0));


insert into LesPays
  select T_Pays(c.name, c.code, c.capital, 
         c.province, c.area, c.population) 
         from COUNTRY c;
/          
insert into LesMontagnes
  select T_Montagne(m.name, m.mountains, m.height, 
         m.type, g.country, g.country ) 
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
      
WbExport -type=text
         -file='exo2.xml'
         -createDir=true
         -encoding=UTF-8
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select e.toXML().getClobVal() 
from LesExo2 e;
