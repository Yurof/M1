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

subsS1(C,C).
subsS1(C,D):-subs(C,D),C\==D.
subsS1(C,D):-subs(C,E),subsS1(E,D).

subsS(C,D):-subsS(C,D,[C]).
subsS(C,C,_).
subsS(C,D,_):-subs(C,D),C\==D.
subsS(C,D,L):-subs(C,E),not(member(E,L)),subsS(E,D,[E|L]),E\==D.

:- discontiguous subs/2.
subs(A,B):-equiv(A,B).
subs(B,A):-equiv(A,B).

:- discontiguous subsS/3.
subsS(C,and(D1,D2),L):-D1\=D2,subsS(C,D1,L),subsS(C,D2,L).
subsS(C,D,L):-subs(and(D1,D2),D),E=and(D1,D2),not(member(E,L)),subsS(C,E,[E|L]),E\==C.
subsS(and(C,C),D,L):-nonvar(C),subsS(C,D,[C|L]).
subsS(and(C1,C2),D,L):-C1\=C2,subsS(C1,D,[C1|L]).
subsS(and(C1,C2),D,L):-C1\=C2,subsS(C2,D,[C2|L]).
subsS(and(C1,C2),D,L):-subs(C1,E1),E=and(E1,C2),not(member(E,L)),subsS(E,D,[E|L]),E\==D.
subsS(and(C1,C2),D,L):-Cinv=and(C2,C1),not(member(Cinv,L)),subsS(Cinv,D,[Cinv|L]).
:- discontiguous subs/2.
subs(all(R,C),all(R,D)):-subs(C,D).
subsS(C,all(R,and(D1,D2)),L):-D1\=D2,subsS(C,all(R,D1),L),subsS(C,all(R,D2),L).
subsS(C,all(R,D),L):-subs(and(D1,D2),D),E=all(R,and(D1,D2)),not(member(E,L)),subsS(C,E,[E|L]),E\==C.

subs(all(R,I),all(R,C)):-inst(I,C).
instS(I,C):-inst(I,D),subsS(D,C).
instS(I,some(R)):-instR(I,R,_).
contreExAll(I,R,C):-instR(I,R,I2),not(instS(I2,C)).
:-discontiguous instS/2.
instS(I,all(R,C)):-not(contreExAll(I,R,C)).
/*
:-discontiguous subs/2.
subs(and(dinosaure,reptile), animal).
subs(pteranodon, dinosaure).
subs(pteranodon, reptile).

*/