palindrome(L) :- inverse(L,L).

palindrome2(X):- concatene([Tete|Z], [Tete], X), palindrome2(Z).
palindrome2([]).
palindrome2([_]).

palindrome3([Tete|QX]):- concatene(Z, [Tete], QX), palindrome2(Z).
palindrome3([]).
palindrome3([_]).


/*
"commande a lancer" : valeur retournee

1)
palindrome([1, 2, 3, 2, 1]). : true
palindrome([1, 2, 3, 3, 2, 1]). : true
palindrome([1, 2, 3, 2, 2]). : false
palindrome([k, a, y, a, k]). : true

2)
palindrome2([1, 2, 3, 2, 1]). : true
palindrome2([1, 2, 3, 3, 2, 1]). : true
palindrome2([1, 2, 3, 2, 2]). : false
palindrome2([k, a, y, a, k]). : true

palindrome3([1, 2, 3, 2, 1]). : true
palindrome3([1, 2, 3, 3, 2, 1]). : true
palindrome3([1, 2, 3, 2, 2]). : false
palindrome3([k, a, y, a, k]). : true

*/