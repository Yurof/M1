revise(X) :- serieux(X).
fait_devoir(X):-consciencieux(X).
reussir(X):-revise(X).
serieux(X):-fait_devoir(X).
consciencieux('Pascal').
consciencieux('Zoe').
