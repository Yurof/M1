concatene([L1_E1|L1Rest], L2, [L1_E1|Result]) :- concatene(L1Rest, L2, Result).
concatene([], L2, L2).              % cas darrêt

inverse(L, Linv):- inverse(L, [], Linv).
inverse([L_E1|LRest], Acc,Result):- inverse(LRest, [L_E1|Acc], Result).
inverse([], Acc,Acc).              % cas darrêt

inverse2([], []).
inverse2([Tete|X], Y):- inverse(X,Z), concatene(Z,[Tete],Y).

supprime([],_, []).                                                                      % cas darrêt
supprime([Supp|L1], Supp, Result):- supprime(L1,Supp,Result).                            % on supprime le caractère
supprime([Tete|L1], Supp, [Tete|Result]):- Tete \= Supp, supprime(L1,Supp,Result).       % on ne supprime pas le caractère

filtre(L1, [Tete|L2], Result) :- supprime(L1, Tete, ResultIntermetdiraire), filtre(ResultIntermetdiraire, L2, Result).
filtre(L1, [], L1).

/*
"commande a lancer" : valeur retournee
pq marche pas ?
inverse([X|Y], [R|X]) :- inverse(Y,R).
inverse([], []).


1)
concatene([a, b, c], [d], Res). : Res = [a, b, c, d].
concatene([a, b,[j,k,l], c], [d], Res). : Res = [a, b, [j, k, l], c, d].

2)
inverse([a,b,c,d],Res). : Res = [d, c, b, a].
inverse2([a,b,c,d],Res). : Res = [d, c, b, a].

3)
supprime([a,b,c,d],Res). : Res = [d, c, b, a].

4)
filtre([1,2,3,4,2,3,4,2,4,1],[2,4],Res). : Res = [1, 3, 3, 1].
*/