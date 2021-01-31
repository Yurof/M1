et(0,0,0).
et(1,0,0).
et(0,1,0).
et(1,1,1).

ou(0,0,0).
ou(1,0,1).
ou(0,1,1).
ou(1,1,1).

non(0,1).
non(1,0).

xor(X,Y,Z):-  non(Y,NY),et(X,NY,Z1),non(X,NX),et(NX,Y,Z2),ou(Z1,Z2,Z).

circuit(X,Y,Z) :-non(X,NX),non(Y,NY),ou(NX,NY,NAND),xor(NX,NAND,XOR),non(XOR,Z).

