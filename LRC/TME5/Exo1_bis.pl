%Les chats sont des félins, comme les lions
subs(chat, felin).
subs(lion, felin).

%Les seuls canidés considérés sont les chiens.
subs(chien, canide).
subs(canide, chien).

%Souris, félins et canidés sont des mammifères.
subs(souris, mammifere).
subs(felin, mammifere).
subs(canide, mammifere).

%Les mammifères sont des animaux, de mˆeme que les canaris.
subs(mammifere, animal).
subs(canari, animal).

%Les animaux sont des êtres vivants
subs(animal, etreVivant).

%On ne peut être à la fois animal et plante.
subs(and(animal, plante), nothing).

%Un animal qui a un maître est un animal de compagnie
%existe aMaitre et animal
subs(and(some(aMaitre), animal), pet).

%Un animal de compagnie a forcément un maˆıtre,
subs(pet, some(aMaitre)).

%toute entité qui a maˆıtre ne peut avoir qu’un (ou plusieurs) maître(s) humain(s).
%existe aMaitre subs pour tout aMaitre.humain
subs(some(aMaitre),all(aMaitre,humain)).

%Un chihuahua est à la fois un chien et un animal de compagnie.
subs(chihuahua, and(chien, pet)).

%Un carnivore exclusif est défini comme une entité qui mange uniquement des animaux
equiv(carnivoreExc, all(mange,animal)).

%un herbivore exclusif est une entité qui mange uniquement des plantes.
equiv(herbivoreExc, all(mange,plante)).

%Le lion est un carnivore exclusif
subs(lion,carnivoreExc).

%On considère que tout carnivore exclusif est un prédateur
subs(carnivoreExc,predateur).

%Tout animal se nourrit
subs(animal,  some(mange)).

%On ne peut pas à la fois ne rien manger (ne manger que des choses qui n’existent pas) et manger quelque chose
subs(and(all(mange,nothing),some(mange)),nothing).

%F´elix est un chat.
inst(felix,chat).


%Il a pour maˆıtre Pierre, qui est un humain. 
inst(pierre,humain).
instR(felix, aMaitre, pierre).


% Princesse est un chihuahua qui a pour maˆıtre Marie, une humaine.
inst(princesse,chihuahua).
inst(marie,humain).
instR(princesse, aMaitre, marie).

%Jerry est une souris et Titi un canari.
inst(jerry, souris).
inst(titi, canari).

% Félix mange Jerry et Titi.
instR(felix,mange,jerry).
instR(felix,mange,titi).


subsS1(C,C).
subsS1(C,D):-subs(C,D),C\==D.
subsS1(C,D):-subs(C,E),subsS1(E,D).