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
p=[int(x) for x in input('list des populations (ex: 100 25 125 ) : ').split()] #somme de la population
limite= int(input("limite de malades par secteur? "))
nbSecteurs = len(Lsecteurs)

# Remplissage de la partie supérieur droite manquante dans les données
d = data[villes]
d = d.fillna(0)
d = d.to_numpy()
d = d + d.T

# Selection des colonnes des villes secteurs
d=d[:,[x-1 for x in Lsecteurs]]
d=d[[x-1 for x in Lsecteurs],:]

#Création d'une modèle
m = Model("health")

# Ajout de la variable
x = m.addVars(nbSecteurs, nbSecteurs, vtype = GRB.INTEGER)

m.update()

# Fonction Objectif
obj = LinExpr();
obj =0
for i in range(nbSecteurs):
    for j in range(nbSecteurs):
        obj += d[i][j]*x[i,j]

m.setObjective(obj,GRB.MINIMIZE)

#Ajout de la contraite qui limite le nombre de malade par unité de soin
for j in range(nbSecteurs):
    lhs = 0
    for i in range(nbSecteurs):
        lhs += x[i,j]
    m.addConstr(lhs<= limite)

# Ajout de la contraite pour avoir les p_i initiaux
for i in range(nbSecteurs):
    lhs = 0
    for j in range(nbSecteurs):
        lhs += x[i,j] 
    m.addConstr(lhs, GRB.EQUAL, p[i])
  
# Resolution
m.optimize()

# Affichage des résultats
solution = m.getAttr('x', x)
printableSolution = np.zeros((nbSecteurs, nbSecteurs))
for i in range(nbSecteurs):
    for j in range(nbSecteurs):
        printableSolution[i,j] = solution[i,j]
print('\nSolution optimale:',printableSolution)

print("")
for i in range(nbSecteurs):
    for j in range(nbSecteurs):
        if i!=j and solution[i,j]>0:
            print("la ville de ", data.axes[1][Lsecteurs[i]+1].strip(),"envoie", int(solution[i,j]),"patients à la ville de ",data.axes[1][Lsecteurs[j]+1] )

print("")
printableSolution2 = np.zeros((nbSecteurs))
for i in range(nbSecteurs):
    for j in range(nbSecteurs):
        printableSolution2[i] += solution[j,i]
        
print('p en sortie:',printableSolution2)

print('\nValeur de la fonction objectif :', m.objVal)

