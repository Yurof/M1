concatenation([],L,L).
concatenation([A|L], M, [A|R]) :- concatenation(L,M,R).