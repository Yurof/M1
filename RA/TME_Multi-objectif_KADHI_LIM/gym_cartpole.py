import cma
import gym
from deap import *
import numpy as np
from fixed_structure_nn_numpy import SimpleNeuralControllerNumpy

from deap import algorithms
from deap import base
from deap import benchmarks
from deap import creator
from deap import tools

import array
import random
import math
import matplotlib.pyplot as plt


from ea_simple import ea_simple

# La ligne suivante permet de lancer des calculs en parallèle, ce qui peut considérablement accélérer les calculs sur une machine multi-coeur. Pour cela, il vous faut charger le module scoop: python -m scoop gym_cartpole.py
#from scoop import futures
# pour que DEAP utilise la parallélisation, il suffit alors d'ajouter toolbox.register("map", futures.map) dans la paramétrisation de l'algorithme évolutionniste. Si vous souhaitez explorer cette possibilité, nous vous conseillons de ne pas mettre l'algorithme évolutionniste dans un fichier séparé, cela peut créer des problèmes avec DEAP.


# Pour récupérer le nombre de paramètre. voir fixed_structure_nn_numpy pour la signification des paramètres. Le TME fonctionne avec ces paramètres là, mais vous pouvez explorer des valeurs différentes si vous le souhaitez.
nn = SimpleNeuralControllerNumpy(4, 1, 2, 5)
IND_SIZE = len(nn.get_parameters())

env = gym.make('CartPole-v1')


def eval_nn(genotype, render=False, nbstep=500):
    total_reward = 0
    nn = SimpleNeuralControllerNumpy(4, 1, 2, 5)
    nn.set_parameters(genotype)

    # à completer
    obs = env.reset()
    for i in range(nbstep):
        if render:
            env.render()

        if nn.predict(obs)[0] > 0:
            action = 1
        else:
            action = 0

        obs, reward, done, info = env.step(action)
        total_reward += reward

        if done:
            break

    # utilisez render pour activer ou inhiber l'affichage (il est pratique de l'inhiber pendant les calculs et de ne l'activer que pour visualiser les résultats.
    # nbstep est le nombre de pas de temps. Plus il est grand, plus votre pendule sera stable, mais par contre, plus vos calculs seront longs. Vous pouvez donc ajuster cette
    # valeur pour accélérer ou ralentir vos calculs. Utilisez la valeur par défaut pour indiquer ce qui doit se passer pendant l'apprentissage, vous pourrez indiquer une
    # valeur plus importante pour visualiser le comportement du résultat obtenu.

    return total_reward,


# faites appel à votre algorithme évolutionniste pour apprendre une politique et finissez par une visualisation du meilleur individu

def main(n, nbgen, ntry, weights=(1.0,)):
    stats = [ea_simple(n, nbgen, eval_nn, IND_SIZE, weights)[2]
             for i in range(ntry)]

    moyenne = []
    maxi = []
    fit_25 = []
    fit_75 = []

    gen = range(nbgen-1)

    for nb in range(nbgen-1):
        points = [stats[t].select('avg')[nb] for t in range(ntry)]
        points2 = [stats[t].select('max')[nb] for t in range(ntry)]
        fit_75.append(np.quantile(points, 0.75))
        fit_25.append(np.quantile(points, 0.25))
        maxi.append(np.median(points2))
        moyenne.append(np.median(points))

    plt.plot(gen, moyenne, label="Fitness moyenne")
    plt.plot(gen, maxi, label="Fitness max")
    plt.fill_between(gen, fit_25, fit_75, alpha=0.25, linewidth=0, label='quartiles')

    plt.title("taille de la population = "+str(n))
    plt.legend(loc="best")
    plt.xlabel("générations")
    plt.ylabel("fitness")
    plt.ylim((0, 550))
    env.close()
