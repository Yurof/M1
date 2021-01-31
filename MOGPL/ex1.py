# -*- coding: utf-8 -*-

import pandas as pd
import numpy as np
from gurobipy import *

print("1-Toulouse\n2-Nice\n3-Nantes\n4-Montpellier\n5-Strasbourg\n6-Bordeaux\n7-Lille\n8-Rennes\n9-Reims\n10-Saint-Étienne\n11-Toulon\n12-Le Havre\n13-Grenoble\n14-Dijon\n15-Angers")

# Lecture du fichier 
data = pd.read_excel('data/villes.xlsx')
villes = data['Ville'].to_numpy()

# Paramètres
Lsecteurs=[int(x) for x in input('list de numéro de villes secteurs (ex:"1 2 3") : ').split()]
alpha=float(input("alpha ? "))
nbSecteurs = len(Lsecteurs)
nbVilles = len(villes)
pop = data["Population"]
gamma = (1+alpha)/(nbSecteurs) * pop.sum()

# Remplissage de la partie supérieur droite manquante dans les données
d = data[villes]
d = d.fillna(0)
d = d.to_numpy()
d = d + d.T

# Selection des colonnes des villes secteurs
d=d[:,[x-1 for x in Lsecteurs]]

#Création d'une modèle
m = Model("health")

# Ajout de la variable binaire
x = m.addVars(nbVilles, nbSecteurs, vtype = GRB.BINARY)
m.update()

# Fonction Objectif
obj = LinExpr();
obj =0
for i in range(nbVilles):
    for j in range(nbSecteurs):
        obj += d[i][j]*x[i,j]*(pop[i]/pop.sum())

# Definition de la fonction objective
m.setObjective(obj,GRB.MINIMIZE)

# Ajout de la contrainte de la capacité maximum d'une ville secteur
for j in range(nbSecteurs):
    lhs = 0
    for i in range(nbVilles):
        lhs += pop[i]*x[i,j]
    m.addConstr(lhs <= gamma)

# Ajout de la contrainte liant une ville a un unique secteur
for i in range(nbVilles):
    lhs = 0
    for j in range(nbSecteurs):
        lhs += x[i,j] 
    m.addConstr(lhs, GRB.EQUAL, 1)
    
# Resolution
m.optimize()

# Affichage des résultats
solution = m.getAttr('x', x)
printableSolution = np.zeros((nbVilles, nbSecteurs))
for i in range(nbVilles):
    for j in range(nbSecteurs):
        printableSolution[i,j] = solution[i,j]
        
print("\nSolution optimale:\n'x:\n",printableSolution)

print("\nalpha =",alpha,"\n")
print('Valeur de la fonction objectif :', m.objVal)

print('------------------------------------')
print("")
  
for i in range(nbSecteurs):
    print("Les villes affectées au secteur",data.axes[1][Lsecteurs[i]+1].strip(),"sont :" )
    A = np.where(printableSolution[:,i] == 1)
    print(villes[A])
    print("")
        

