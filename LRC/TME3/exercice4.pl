pere('Homer','Bart').
pere('Homer','Lisa').
pere('Homer','Maggie').
pere('Abraham','Homer').
pere('PereAbraham','Abraham').
pere('GrandPereAbraham','PereAbraham').
pere('GGPereAbraham','GrandPereAbraham').
pere('GGGPereAbraham','GGPereAbraham').

mere('Marge','Bart').
mere('Marge','Lisa').
mere('Marge','Maggie').

parent(X,Y) :-pere(X,Y).
parent(X,Y) :-mere(X,Y).

parents(X,Y,Z) :-pere(X,Z),mere(Y,Z).

grandPere(X,Z) :-pere(X,Y),parent(Y,Z).

frereOuSoeur(X,Y) :-parents(A,B,X),parents(A,B,Y),X\=Y.

ancetre(X,Y) :-parent(X,Y).
ancetre(X,Z) :-parent(X,Y),ancetre(Y,Z).

