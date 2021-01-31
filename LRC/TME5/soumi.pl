/* UNG Richard - 3680881*/
/* KADHI Youssef - */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Exercice 1 %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subs(chat,felin).
subs(lion,felin).
subs(chien,canide).
subs(canide,chien).
subs(souris,mammifere).
subs(felin,mammifere).
subs(canide,mammifere).
subs(mammifere,animal).
subs(canari,animal).
subs(animal,etreVivant).
subs(and(animal,plante),nothing).
subs(and(animal,some(aMaitre)),pet).
subs(pet,some(aMaitre)).
subs(some(aMaitre),all(aMaitre,humain)).
subs(chihuahua,and(chien,pet)).
subs(lion,carnivoreExc).
subs(carnivoreExc,predateur).
subs(animal,some(mange)).
subs(and(all(mange,nothing),some(mange)),nothing).

equiv(carnivoreExc,all(mange,animal)).
equiv(herbivoreExc,all(mange,plante)).

inst(felix,chat).
inst(pierre,humain).
inst(princesse,chihuahua).
inst(marie,humain).
inst(jerry,souris).
inst(titi,canari).

instR(felix,aMaitre,pierre).
instR(princesse,aMaitre,marie).
instR(felix,mange,jerry).
instR(felix,mange,titi).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Exercice2 %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subsS1(C,C).
subsS1(C,D):-subs(C,D),C\==D.
subsS1(C,D):-subs(C,E),subsS1(E,D).

%%%%%%%%%%%%%%%%%%%%%%%%Question 1:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
subsS1(C,C). indique que la subsomption structurelle est réflexive càd que C est subsumé structurellement par lui même.
subsS1(C,D):-subs(C,D),C\==D. indique que si C est subsumé par D alors C est subsumé structurellement par D.
subsS1(C,D):-subs(C,E),subsS1(E,D). indique que la subsomption structurelle est transitive càd que si C est subsumé par E et que E est subsumé structurellement par D alors C est subsumé par D.


*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 2:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
?- subsS1(canari,animal).
true .

?- subsS1(chat,etreVivant).
true .
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 3:%%%%%%%%%%%%%%%%%%%%%%%%%


/*
Avec l'aide de la commande trace, on remarque que subsS1(chien,souris)
forme une boucle infini car "chien" est subsumé par "canide" et "canide"
est subsumé par "chien".

Lorsque la requête retourne false pour "chien", prolog prend en compte
que "chien" est subsumé par "canide" et prolog refait le test avec
"canide". Et comme la requête retourne false, prolog prend en compte que
"canide" est subsumé par "chien" et refait le test avec "chien". Et
ainsi de suite. Nous n'avons pas encore établis de règle afin de détecter des cycles.

   Call: (10) subsS1(chien, souris) ? creep
   Call: (11) subs(chien, souris) ? creep
   Call: (12) equiv(chien, souris) ? creep
   Fail: (12) equiv(chien, souris) ? creep
   Redo: (11) subs(chien, souris) ? creep
   Call: (12) equiv(souris, chien) ? creep
   Fail: (12) equiv(souris, chien) ? creep
   Fail: (11) subs(chien, souris) ? creep
   Redo: (10) subsS1(chien, souris) ? creep
   Call: (11) subs(chien, _11636) ? creep
   Exit: (11) subs(chien, canide) ? creep
   Call: (11) subsS1(canide, souris) ? creep
   Call: (12) subs(canide, souris) ? creep
   Call: (13) equiv(canide, souris) ? creep
   Fail: (13) equiv(canide, souris) ? creep
   Redo: (12) subs(canide, souris) ? creep
   Call: (13) equiv(souris, canide) ? creep
   Fail: (13) equiv(souris, canide) ? creep
   Fail: (12) subs(canide, souris) ? creep
   Redo: (11) subsS1(canide, souris) ? creep
   Call: (12) subs(canide, _12120) ? creep
   Exit: (12) subs(canide, chien) ? creep
   Call: (12) subsS1(chien, souris) ? creep
   Call: (13) subs(chien, souris) ? creep
   Call: (14) equiv(chien, souris) ? creep
   Fail: (14) equiv(chien, souris) ? creep
   Redo: (13) subs(chien, souris) ? creep
*/

subsS(C,D):-subsS(C,D,[C]).
subsS(C,C,_).
subsS(C,D,_):-subs(C,D),C\==D.
subsS(C,D,L):-subs(C,E),not(member(E,L)),subsS(E,D,[E|L]),E\==D.

%%%%%%%%%%%%%%%%%%%%%%%%Question 4:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
?- subsS(canari,animal).
true .

?- subsS(chat,etreVivant).
true .

?- subsS(chien,canide).
true .

?- subsS(chien,chien).
true .
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 5:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
subsS(souris,some(mange)) réussit bien que "some(mange)" ne soit pas un
concept atomique. En effet, subsS a été codé selon l'exercice 2 pour
des concepts atomiques mais rien ne l'empêche de marcher pour
d'autres concepts. Les objets manipulés par Prolog sont des termes, il
en manipule 3 types : les variables, les termes élémentaires (aussi
appelé terme atomique) et les termes composés. Donc la requête
subsS(souris,some(mange)) peut très bien manipuler le terme composé
"some(mange)". Ici Prolog ne reconnaît pas la sémantique de
"some(mange)" mais cela ne l'empêche pas de reconnaître sa syntaxe.
Dans l'exercice 1, on a écrit que "souris" est subsumé par "mammifere",
que "mammifere" est subsumé par "animal" et que "animal" est subsumé par
"some(mange)". Donc par transitivité de la subsomption, "souris" est
subsumé par "some(mange))".
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 6:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
?- subsS(chat,humain).
false.

?- subsS(chien,souris).
false.
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 7:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
subsS(chat,X) devrait renvoyer pour X:

X = chat, car subsS est réflexive.

X = felin, car subs(chat,felin).

X = mammifere par transitivité car subs(chat,felin) et
subs(felin,mammifere).

X = animal par transitivité car subs(chat,felin), subs(felin,mammifere)
et subs(mammifere,animal).

X = etreVivant par transitivité car subs(chat,felin),
subs(felin,mammifere), subs(mammifere,animal) et
subs(animal,etreVivant).

X = some(mange) par transitivité car subs(chat,felin),
subs(felin,mammifere), subs(mammifere,animal) et
subs(animal,some(mange)).

D'après prolog on trouve :
subsS(chat,X).
X = chat ;
X = felin ;
X = mammifere ;
X = animal ;
X = etreVivant ;
X = some(mange) ;
false.

subsS(X,mammifere) devrait renvoyer pour X:

X = mammifere car subsS est réflexive.

X = canide car subs(canide,mammifere).

X = felin car subs(felin,mammifere).

X = souris car subs(souris,mammifere).

X = chien par transitivité car subs(chien,canide) et
subs(canide,mammifere).

X = lion par transitivité car subs(lion,felin) et subs(felin,mammifere).

X = chat par transitivité car subs(chat,felin) et subs(felin,mammifere).

D'après prolog on trouve :
subsS(X,mammifere).
X = mammifere ;
X = souris ;
X = felin ;
X = canide ;
X = chat ;
X = lion ;
X = chien ;
false.
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 8:%%%%%%%%%%%%%%%%%%%%%%%%%

:- discontiguous subs/2.
subs(A,B):-equiv(A,B).
subs(B,A):-equiv(A,B).

%%%%%%%%%%%%%%%%%%%%%%%%Question 9:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Avant ajout de la question 8:

subsS(lion,all(mange,animal)).
false.

Après ajout dela question 8:

subsS(lion,all(mange,animal)).
true .
*/

%%%%%%%%%%%%%%%%%%%%%%%Question 10:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
On a plus intérêt à dériver la subsomption subs plutôt que subsS. Tout
d'abord, d'un point de vue technique, il est beaucoup plus simple et sûr
de dériver subs plutôt que subsS.

De plus, pour pouvoir répondre à toute requête atomique il faudrait
pouvoir gérer la commutativité de l'intersection avec subsS alors
qu'avec subs c'est très simple (voir question 8).

Les règles de subsS avec la question 8, permettent de répondre à toute
requête atomique si l'on suppose que la T-Box ne contient que des
subsomptions ou équivalences entre concepts atomiques.

Ce n'est pas le cas si la T-Box contient des subsomptions ou
équivalences entre concepts non-atomiques.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Exercice 3 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- discontiguous subsS/3.
subsS(C,and(D1,D2),L):-D1\=D2,subsS(C,D1,L),subsS(C,D2,L).
subsS(C,D,L):-subs(and(D1,D2),D),E=and(D1,D2),not(member(E,L)),subsS(C,E,[E|L]),E\==C.
subsS(and(C,C),D,L):-nonvar(C),subsS(C,D,[C|L]).
subsS(and(C1,C2),D,L):-C1\=C2,subsS(C1,D,[C1|L]).
subsS(and(C1,C2),D,L):-C1\=C2,subsS(C2,D,[C2|L]).
subsS(and(C1,C2),D,L):-subs(C1,E1),E=and(E1,C2),not(member(E,L)),subsS(E,D,[E|L]),E\==D.
subsS(and(C1,C2),D,L):-Cinv=and(C2,C1),not(member(Cinv,L)),subsS(Cinv,D,[Cinv|L]).

%%%%%%%%%%%%%%%%%%%%%%%%Question 1:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
subsS(chihuahua,and(mammifere,some(aMaitre))).
true .

subsS(and(chien,some(aMaitre)),pet).
true .

subsS(chihuahua,and(pet,chien)).
true .
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 2:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
La 1ère règle : subsS(C,and(D1,D2),L):-D1\=D2,subsS(C,D1,L),subsS(C,D2,L).
Elle indique que si C est subsumé structurellement par D1
              et si C est subsumé structurellement par D2
              sachant que D1 est différent de D2
              alors C est subsumé structurellement par l'intersection de
              D1 et D2.

C : lion
D1: felin
D2: carnivoreExc

Exemple sans ajout de la règle 1 :

?- subsS(lion,and(felin,carnivoreExc)).
false.

Exemple avec ajout de la règle 1:

?- subsS(lion,and(felin,carnivoreExc)).
true .
*/

/*
La 2ème règle :subsS(C,D,L):-subs(and(D1,D2),D), E=and(D1,D2), not(member(E,L)),
subsS(C,E,[E|L]),E\==C.
On pose E l'intersection de D1 et de D2.
La 2ème règle indique que si C est subsumé structurellement par E,
                      que E est subsumé par D
                      tel que E est différent de C,
                      alors C est subsumé structurellement par D.

C : pteranodon
D1: dinosaure
D2: reptile
D : animal

*/

/*
% En retirant les commentaires de celui là, on trouve :
:-discontiguous subs/2.
subs(and(dinosaure,reptile), animal).
subs(pteranodon, dinosaure).
subs(pteranodon, reptile).
*/

/*
Exemple sans ajout de la règle 2 :

?- subsS(pteranodon,animal).
false.

Exemple avec ajout de la règle 2 :

?- subsS(pteranodon,animal).
true .
*/

/* La 3ème règle : subsS(and(C,C),D,L):-nonvar(C),subsS(C,D,[C|L]).
On pose que C n'est pas une variable.
La 3ème règle indique que si C est subsumé structurellement par D,
alors l'intersection de C avec C est subsumé structurellement par D.

C : and(lion,canari)
D : animal

Exemple sans ajout de la règle 3 :

?- subsS(and(and(lion,canari),and(lion,canari)),animal).
false.


Exemple avec ajout de la règle 3 :
?- subsS(and(and(lion,canari),and(lion,canari)),animal).
true.

*/

/* La règle 4 : subsS(and(C1,C2),D,L):-C1\=C2,subsS(C1,D,[C1|L]).
Elle indique que si C1 est différent de C2
et que C1 est subsumé structurellement par D
alors l'intersection entre C1 et C2 est subsumé structurellement par D.

C1: chat
C2: chien
D : felin

Exemple sans ajout de la règle 4 :

?- subsS(and(chat,chien),felin).
false.

Exemple avec ajout de la règle 4 :

?- subsS(and(chat,chien),felin).
true.
*/

/* La règle 5 : subsS(and(C1,C2),D,L):-C1\=C2,subsS(C2,D,[C2|L]).
Elle indique que si C1 est différent de C2
et que C2 est subsumé structurellement par D
alors l'intersection entre C1 et C2 est subsumé structurellement par D.

C1: chat
C2: chien
D : canide

Exemple sans ajout de la règle 5 :

?- subsS(and(chat,chien),canide).
false.

Exemple avec ajout de la règle 5 :

?- subsS(and(chat,chien),canide).
true .
*/

/* La règle 6 : subsS(and(C1,C2),D,L):-subs(C1,E1),E=and(E1,C2),not(member(E,L)),subsS(E,D,[E|L]),E\==D.
On pose E l'intersection entre E1 et C2.
La règle 6 indique que si E est différent de D,
                   que E est subsumé structurellement par D,
                   que C1 est subsumé par E1
                   alors l'intersection de C1 et de C2 est subsumé
                   structurellement par D.

C1: X
C2: plante
E1: X
D : nothing

Exemple sans ajout de la règle 6 :

?- subsS(and(X,plante),nothing).
X = animal ;
false.

Exemple avec ajout de la règle 6 : ( réponse identique non affiché)

?- subsS(and(X,plante),nothing).
X = animal ;
X = chat ;
X = lion ;
X = chien ;
X = canide ;
X = souris ;
X = felin ;
X = mammifere ;
X = canari ;
X = and(animal, plante) ;
X = chihuahua ;
X = and(all(manger, nothing), some(mange)) ;
X = and(dinosaure, reptile) ;
false.

*/

/*
La règle 7 : subsS(and(C1,C2),D,L):-Cinv=and(C2,C1),not(member(Cinv,L)),subsS(Cinv,D,[Cinv|L]).
Elle indique la commutativité de l'intersection.
Cad que si l'intersection de C2 et de C1 est subsumé structurellement
par D
alors l'intersection de C1 et de C2 est subsumé structurellement par D.
*/

/*
% En retirant les commentaires de celui là, on trouve :
:-discontiguous subs/2.
subs(and(c1, c2), tmp).
subs(tmp, d).
*/

/*
Exemple sans ajout de la règle 7 :

?- subsS(and(c2,c1),d).
false.

Exemple avec ajout de la règle 7 :

?- subsS(and(c2,c1),d).
true .
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 3:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Ces règles ne suffisent pas, voici un contre-exemple:

?- subsS(lion, and(felin, felin)).
false.
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Exercice 4 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%Question 1:%%%%%%%%%%%%%%%%%%%%%%%%%

:-discontiguous subs/2.
subs(all(R,C),all(R,D)):-subs(C,D).
subsS(C,all(R,and(D1,D2)),L):-D1\=D2,subsS(C,all(R,D1),L),subsS(C,all(R,D2),L).
subsS(C,all(R,D),L):-subs(and(D1,D2),D),E=all(R,and(D1,D2)),not(member(E,L)),subsS(C,E,[E|L]),E\==C.

%%%%%%%%%%%%%%%%%%%%%%%%Question 2:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
?- subsS(lion,all(mange,etreVivant)).
true .

?- subsS(all(mange,canari),carnivoreExc).
true .
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 3:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
?- subsS(and(carnivoreExc,herbivoreExc),all(mange,nothing)).
true .

܀?- subsS(and(and(carnivoreExc,herbivoreExc),animal),nothing).
true .

?- subsS(and(and(carnivoreExc,animal),herbivoreExc),nothing).
true .

Les règles définies plus haut permettent de réussir la dernière requête
car les 2 dernières requêtes sont en soi équivalentes car le "and" est
en plus d'être commutative, associative.
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 4:%%%%%%%%%%%%%%%%%%%%%%%%%

subs(all(R,I),all(R,C)):-inst(I,C).

/* Quelques exemples:

?- subsS(all(mange,felix),all(mange,chat)).
true .

?- subsS(all(mange,pierre),all(mange,humain)).
true .

?- subsS(all(mange,princesse),all(mange,chihuahua)).
true .

?- subsS(all(mange,jerry),all(mange,souris)).
true .

?- subsS(all(mange,titi),all(mange,canari)).
true .

?- subsS(all(mange,marie),all(mange,humain)).
true .
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 5:%%%%%%%%%%%%%%%%%%%%%%%%%
/*
Non ce n'est pas nécessaire car dans la grammaire de FL-, le
quantificateur existantiel ne s'applique qu'à un rôle atomique et
uniquement a un. On peut donc le considérer comme un concept atomique.
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 6:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
On est censé trouver lion, felin, mammifere, animal, etreVivant,
carnivoreExc et predateur grâce aux subsomptions
transitives de l'exercice 1.

Ensuite on trouve aussi all(mange,animal) par
équivalence avec carnivoreExc de l'exercice 1.

Et enfin all(mange, etreVivant) et all(mange, some(mange)) par
subsomption structurelle.

?- subsS(lion,X).
X = lion ;
X = felin ;
X = carnivoreExc ;
X = mammifere ;
X = animal ;
X = etreVivant ;
X = some(mange) ;
X = predateur ;
X = all(mange, animal) ;
X = all(mange, etreVivant) ;
X = all(mange, some(mange)) ;

On est censé trouver lion,carnivoreExc et predateur grâce aux
subsomptions transitives de l'exercice 1.

Ensuite on trouve all(mange, animal) par équivalence avec carnivoreExc
de l'exercice 1.

Et enfin on trouve tout les "all(mange,X)" avec X subsumé par
"animal", soit : all(mange, chat),all(mange, lion), all(mange, chien),
all(mange, souris), all(mange, felin), all(mange, canide), all(mange,
mammifere) et all(mange, canari)


?- subsS(X,predateur).
X = predateur ;
X = carnivoreExc ;
X = lion ;
X = all(mange, animal) ;
X = all(mange, chat) ;
X = all(mange, lion) ;
X = all(mange, chien) ;
X = all(mange, souris) ;
X = all(mange, felin) ;
X = all(mange, canide) ;
X = all(mange, mammifere) ;
X = all(mange, canari) ;
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Exercice 5 %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/*
L'ensemble des règles n'est toujours pas complet pour FL-, voici un
contre-exemple (exercice 3, question 3):

subsS(lion,and(felin,felin)).
false.

Malgré cela, nous avons parcourus tout les grands points majeurs de la
subsomption pour la logique de descriptions FL-:

Subsomption atomique
Equivalences
Intersections
Quantificateur universel( avec concept et avec rôle)
Quantificateur existantiel ( même si inutile voir Ex 4 question 5)
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Exercice 6 %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%Question 1:%%%%%%%%%%%%%%%%%%%%%%%%%

instS(I,C):-inst(I,D),subsS(D,C).

%%%%%%%%%%%%%%%%%%%%%%%%Question 2:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
?- instS(felix,mammifere).
true .

?- instS(princesse,pet).
true .
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 3:%%%%%%%%%%%%%%%%%%%%%%%%%

instS(I,some(R)):-instR(I,R,_).

/*
?- instS(felix,some(mange)).
true .

?- instS(princesse,some(aMaitre)).
true .

?- instS(felix,some(aMaitre)).
true .
*/

%%%%%%%%%%%%%%%%%%%%%%%Question 4a:%%%%%%%%%%%%%%%%%%%%%%%%%

contreExAll(I,R,C):-instR(I,R,I2),not(instS(I2,C)).

%%%%%%%%%%%%%%%%%%%%%%%Question 4b:%%%%%%%%%%%%%%%%%%%%%%%%%

:-discontiguous instS/2.
instS(I,all(R,C)):-not(contreExAll(I,R,C)).

%%%%%%%%%%%%%%%%%%%%%%%Question 4c:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
?- instS(felix,all(mange,animal)).
true.

?- instS(titi,all(mange,personne)).
true.

?- instS(felix,all(mange,mammifere)).
false.

On retrouve bien les résultats attendus.
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 5:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Cela n'est pas nécessaire car nos requêtes du type subs(all(R,I),
all(R,C))renvoie déjà "true" grâce aux règles de subsS et à la question
4 de l'exercice 4 : subs(all(R,I), all(R,C)) :-inst(I,C).
*/

%%%%%%%%%%%%%%%%%%%%%%%%Question 6:%%%%%%%%%%%%%%%%%%%%%%%%%

/*
?- instS(felix,pet).
false.

?- instS(felix,carnivoreExc).
false.

Il faudrait implémenter quelques règles capable d'associer l'instantiation structurelle avec la subsomption structurelle. Comme on la vue précédemment, certains instS fonctionnent. Une règle capable de gérer la transitivité des instances par exemple permettrait de faire réussir les deux dernières requêtes.*/














