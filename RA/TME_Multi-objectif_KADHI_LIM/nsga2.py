import numpy as np
from deap import base, creator, benchmarks

from deap import algorithms
from deap.tools._hypervolume import hv
import matplotlib.pyplot as plt
import math

import random
from deap import tools

# ne pas oublier d'initialiser la grane aléatoire (le mieux étant de le faire dans le main))
random.seed()


def my_nsga2(n, nbgen, evaluate, ref_point=np.array([1, 1]), IND_SIZE=5, weights=(-1.0, -1.0)):
    """NSGA-2

    NSGA-2
    :param n: taille de la population
    :param nbgen: nombre de generation
    :param evaluate: la fonction d'évaluation
    :param ref_point: le point de référence pour le calcul de l'hypervolume
    :param IND_SIZE: la taille d'un individu
    :param weights: les poids à utiliser pour la fitness (ici ce sera (-1.0,) pour une fonction à minimiser et (1.0,) pour une fonction à maximiser)
    """

    creator.create("MaFitness", base.Fitness, weights=weights)
    creator.create("Individual", list, fitness=creator.MaFitness)

    toolbox = base.Toolbox()
    paretofront = tools.ParetoFront()

    # à compléter
    toolbox.register("bit", random.uniform, -5, 5)
    toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.bit, n=IND_SIZE)
    toolbox.register("population", tools.initRepeat, list, toolbox.individual, n=n)
    toolbox.register("evaluate", evaluate)
    toolbox.register("mate", tools.cxSimulatedBinary, eta=0.5)
    toolbox.register("mutate", tools.mutPolynomialBounded, eta=15, low=-5, up=5, indpb=0.2)
    toolbox.register("select", tools.selNSGA2)

    stats = tools.Statistics(key=lambda ind: ind.fitness.values)
    stats.register("avg", np.mean)
    stats.register("std", np.std)
    stats.register("min", np.min)
    stats.register("max", np.max)

    logbook = tools.Logbook()
    hof = tools.HallOfFame(1)
    population = toolbox.population()

    fits = toolbox.map(toolbox.evaluate, population)
    for ind, fit in zip(population, fits):
        ind.fitness.values = fit
    paretofront.update(population)

    # Pour récupérer l'hypervolume, nous nous contenterons de mettre les différentes aleur dans un vecteur s_hv qui sera renvoyé par la fonction.
    pointset = [np.array(ind.fitness.getValues()) for ind in paretofront]
    s_hv = [hv.hypervolume(pointset, ref_point)]
    ListPoint = []
    ListPoint2 = []

    # Begin the generational process
    for gen in range(1, nbgen):
        # à completer
        offspring = algorithms.varAnd(population, toolbox, cxpb=0.5, mutpb=0.15)

        invalid_ind = [ind for ind in offspring if not ind.fitness.valid]
        fits = toolbox.map(toolbox.evaluate, invalid_ind)
        for ind, fit in zip(invalid_ind, fits):
            ind.fitness.values = fit

        population = toolbox.select(offspring + population, k=n)

        record = stats.compile(population)
        logbook.record(gen=gen, **record)
        hof.update(population)

        paretofront.update(population)
        pointset = [np.array(ind.fitness.getValues()) for ind in paretofront]
        s_hv.append(hv.hypervolume(pointset, ref_point))

    del creator.MaFitness
    del creator.Individual

    return population, pointset, s_hv


def main(n, nbgen, evaluate, IND_SIZE, ntry):
    stats = [my_nsga2(n, nbgen, evaluate, IND_SIZE=IND_SIZE)[2]
             for i in range(ntry)]

    moyenne = []
    fit_25 = []
    fit_75 = []

    gen = range(nbgen)

    for nb in range(nbgen):
        points = [stats[t][nb] for t in range(ntry)]
        fit_75.append(np.quantile(points, 0.75))
        fit_25.append(np.quantile(points, 0.25))
        moyenne.append(np.median(points, axis=0))

    plt.plot(gen, moyenne, label="hypervolume")
    plt.fill_between(gen, fit_25, fit_75, alpha=0.25, linewidth=0, label='quartiles')
    plt.title("taille de la population = "+str(n))
    plt.legend(loc="best")
    plt.xlabel("générations")
    plt.ylabel("hypervolume")
    plt.ylim((0, 1))


def afficher_points(n, nbgen, evaluate, IND_SIZE):
    pointset = my_nsga2(n, nbgen, evaluate, IND_SIZE=IND_SIZE)[1]
    plt.scatter(*zip(*pointset))
    plt.title("pop = "+str(n) + " , pointset d'une iteration")
    plt.xlabel('x')
    plt.ylabel('y')
