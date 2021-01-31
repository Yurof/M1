# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np
from gurobipy import *


# Lecture du fichier 
data = pd.read_excel('data/villes.xlsx')
villes = data['Ville'].to_numpy()

# Paramètres
nbSecteurs=int(input("nombre de secteurs ? "))
alpha=float(input("alpha ? "))
nbVilles = len(villes)
pop = data["Population"]
gamma = (1+alpha)/(nbSecteurs) * pop.sum()

# Remplissage de la partie supérieur droite manquante dans les données
d = data[villes]
d = d.fillna(0)
d = d.to_numpy()
d = d + d.T

#Création d'une modèle
m = Model("health")

# Ajout des variables binaires
x = m.addVars(nbVilles, nbVilles, vtype = GRB.BINARY)
S = m.addVars(nbVilles, 1, vtype = GRB.BINARY)
m.update()


# Ajout de la contrainte de la capacité maximum d'une ville secteur
for j in range(nbVilles):
    lhs = 0
    for i in range(nbVilles):
        lhs += pop[i]*x[i,j]
    m.addConstr(lhs <= gamma)

# Ajout de la contrainte liant une ville a un unique secteur
for i in range(nbVilles):
    lhs = 0
    for j in range(nbVilles):
        lhs += x[i,j] 
    m.addConstr(lhs, GRB.EQUAL, 1)

# Ajout de la contrainte pour ne pas lié de ville a une ville non secteur
for j in range(nbVilles):
    for i in range(nbVilles):
        m.addConstr(x[i,j]  <= S[j,0])

# Ajout de la contrainte pour n'avoir que k villes secteur   
lhs = 0
for j in range(nbVilles):
    lhs += S[j,0]
m.addConstr(lhs, GRB.EQUAL, nbSecteurs)

# Fonction Objectif
obj = LinExpr();
obj =0
for i in range(nbVilles):
    for j in range(nbVilles):
        obj += d[i][j]*x[i,j]*(pop[i]/pop.sum())

m.setObjective(obj,GRB.MINIMIZE)

# Resolution
m.optimize()


# Affichage des résultats
solution = m.getAttr('x', x)
solution2 = m.getAttr('x', S)
printableSolution = np.zeros((nbVilles, nbVilles))
printableSolution2 = np.zeros((nbVilles,1))

for i in range(nbVilles):
    printableSolution2[i] = solution2[i,0]
    for j in range(nbVilles):
        printableSolution[i,j] = solution[i,j]
        
print("\nSolution optimale:\n'x:\n",printableSolution)
print("S:\n",printableSolution2.T)

print("\nalpha =",alpha,"\n")
print('Valeur de la fonction objectif :', m.objVal)

print('------------------------------------')
print('\nLes secteurs sélectionnés sont : ')
secteurs = []
for i in range(nbVilles):
    if(printableSolution2[i] == 1):
        secteurs.append(villes[i])
print(secteurs,"\n")

printableSolution=printableSolution[:,[x for x in range (nbVilles) if printableSolution2[x] == 1 ]]

for i in range(nbSecteurs):
    print("Les villes affectées au secteur ",secteurs[i],"sont :" )
    A = np.where(printableSolution[:,i] == 1)
    print(villes[A])
    print("")

