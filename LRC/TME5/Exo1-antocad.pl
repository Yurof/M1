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
subs(and(plante,animal),nothing).
subs(lion,carnivoreExc).
subs(carnivoreExc,predateur).



subs(animal,some(mange)).
subs(carnivoreExc,all(mange,animal)).
subs(herbivoreExc,all(mange,plante)).
subs(_,not(and(all(mange,_),all(mange,nothing)))).
subs(pet,animal).
subs(all(aMaitre, _), pet).
subs(pet, some(aMaitre, _)).
subs(_, all(aMaitre,humain)).
subs(chihuahua, and(pet,chien)).
subs(felix,chat).
subs(felix,all(aMaitre, pierre)).
subs(pierre,humain).
subs(princesse,chihuahua).
subs(princesse, all(aMaitre,marie)).
subs(marie,humaine).
subs(jerry,souris).
subs(titi,canari).
subs(felix, all(mange, and(jerry, titi))).

