import numpy as np
import matplotlib.pyplot as plt
import random
from deap import base, creator, benchmarks, algorithms, tools


def ea_simple(n, nbgen, evaluate, IND_SIZE, weights=(-1.0,)):
    """Algorithme evolutionniste elitiste

    Algorithme evolutionniste elitiste.
    :param n: taille de la population
    :param nbgen: nombre de generation
    :param evaluate: la fonction d'évaluation
    :param IND_SIZE: la taille d'un individu
    :param weights: les poids à utiliser pour la fitness (ici ce sera (-1.0,) pour une fonction à minimiser et (1.0,) pour une fonction à maximiser)
    """

    creator.create("MaFitness", base.Fitness, weights=weights)
    creator.create("Individual", list, fitness=creator.MaFitness)

    toolbox = base.Toolbox()

    # à compléter pour sélectionner les opérateurs de mutation, croisement, sélection avec des toolbox.register(...)
    toolbox.register("bit", random.uniform, a=-5, b=5)
    toolbox.register("individual", tools.initRepeat, creator.Individual, toolbox.bit, n=IND_SIZE)
    toolbox.register("population", tools.initRepeat, list, toolbox.individual, n=n)
    toolbox.register("evaluate", evaluate)
    toolbox.register("mate", tools.cxSimulatedBinary, eta=0.5)
    toolbox.register("mutate", tools.mutPolynomialBounded, eta=15, low=-5, up=5, indpb=0.2)
    toolbox.register("select", tools.selBest)

    # Les statistiques permettant de récupérer les résultats
    stats = tools.Statistics(key=lambda ind: ind.fitness.values)
    stats.register("avg", np.mean)
    stats.register("std", np.std)
    stats.register("min", np.min)
    stats.register("max", np.max)

    # La structure qui permet de stocker les statistiques
    logbook = tools.Logbook()

    # La structure permettant de récupérer le meilleur individu
    hof = tools.HallOfFame(1)

    # à compléter pour initialiser l'algorithme, n'oubliez pas de mettre à jour les statistiques, le logbook et le hall-of-fame.
    population = toolbox.population()

    fits = toolbox.map(toolbox.evaluate, population)
    for ind, fit in zip(population, fits):
        ind.fitness.values = fit

    for g in range(1, nbgen):

        offspring = algorithms.varAnd(population, toolbox, cxpb=0.5, mutpb=0.15)

        invalid_ind = [ind for ind in offspring if not ind.fitness.valid]
        fits = toolbox.map(toolbox.evaluate, invalid_ind)
        for ind, fit in zip(invalid_ind, fits):
            ind.fitness.values = fit

        population = toolbox.select(offspring + population, k=n)

        record = stats.compile(population)
        logbook.record(gen=g, **record)
        hof.update(population)

    del creator.MaFitness
    del creator.Individual

    return population, hof, logbook


def main(n, nbgen, evaluate, IND_SIZE, ntry, weights=(-1.0,)):
    random.seed()
    stats = [ea_simple(n, nbgen, evaluate, IND_SIZE, weights)[2]
             for i in range(ntry)]

    moyenne = []
    fit_25 = []
    fit_75 = []

    gen = range(nbgen-1)

    for nb in range(nbgen-1):
        points = [stats[t].select('avg')[nb] for t in range(ntry)]
        fit_75.append(np.quantile(points, 0.75))
        fit_25.append(np.quantile(points, 0.25))
        moyenne.append(np.median(points))

    plt.plot(gen, moyenne, label="Fitness moyenne")
    plt.fill_between(gen, fit_25, fit_75, alpha=0.25, linewidth=0, label='quartiles')
    plt.title("taille de la population = "+str(n))
    plt.legend(loc="best")
    plt.xlabel("générations")
    plt.ylabel("fitness")
    plt.ylim((0, 11))
