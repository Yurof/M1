1)  Tous les menus à moins de 50EUR
/base/restaurant/menu[@prix<50]
//menu[@prix<50]

2)  les menus des restaurants 2 ou 3 étoiles
//restaurant[@étoile=2 or @étoile=3]/menu

3)  le nom des villes dans le département 69
//ville[@departement=69]/@nom

4)  le nom des restaurant a Lyon
//restaurant[@ville="Lyon"]/@nom

5)  le nom des restaurants dans le departement 75
//restaurant[@ville=//ville[@departement='75']/@nom]/@nom
--égale a au moins un 

6)  le plus beau monument des villes ayant au moins 1 restaurant 3 étoiles
//ville[@nom=//restaurant[@étoile+3]/@ville]/plusBeauMonument
//ville[@nom=../restaurant[@étoile+3]/@ville]/plusBeauMonument
//ville[count(//restaurant[@étoile=3 and @ville=@nom])>1]/plusBeauMonument

7)  les villes avec au moins un restaurant qui a au moins 4 menus
//ville[@nom=//restaurant[count(menu)>=4]/@ville]
//ville [@nom+//restaurant[enu[4]]/@ville]
--il existe un 4eme élément menu 
--position()=4

8)  les restaurants 3 étoiles fermés le dimanche
//restaurant[@étoile +3 and contains(fermeture,'dimanche')]  
--l'éléement fermeture (fils de restaurant) contient la chaine 'dimanche'
 
8b) les restaurants ouverts le lundi
//restaurant[not contains(fermeture,'lundi')]
--faux si un élément fermeture contient lundi
--restaurant[not fermeture] sans fils fermeture
