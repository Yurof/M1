from deap import tools
from deap import base, creator, benchmarks
import numpy as np
from deap import base, creator, benchmarks, tools, algorithms

import random

import matplotlib.pyplot as plt

# ne pas oublier d'initialiser la grane aléatoire (le mieux étant de le faire dans le main))
random.seed(0)


def summary(n, nbgen, evaluate, IND_SIZE, ntry, weights=(-1.0,)):

    stats = np.array([ea_simple(n, nbgen, evaluate, IND_SIZE, weights)
                     for i in range(ntry)])

    moyenne = []
    fit_25 = []
    fit_75 = []

    gen = range(nbgen)

    for t in range(ntry):
        moyenne.append(stats[t, 2].select('avg'))

    moyenne = np.mean(moyenne, axis=0)

    plt.plot(gen, moyenne, label="Fitness moyenne")
    plt.show()


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

    toolbox.register("attr_float", random.uniform, -5, 5)
    toolbox.register("individual", tools.initRepeat, creator.Individual,
                     toolbox.attr_float, n=IND_SIZE)
    toolbox.register("population", tools.initRepeat, list, toolbox.individual)
    toolbox.register("mutate", tools.mutPolynomialBounded,
                     eta=15, low=-5, up=5, indpb=0.2)
    toolbox.register("crossover", tools.cxSimulatedBinary, eta=15)
    toolbox.register("select", tools.selTournament, tournsize=3)
    toolbox.register("evaluate", evaluate)

    # Les statistiques permettant de récupérer les résultats
    stats = tools.Statistics(key=lambda ind: ind.fitness.values)
    stats.register("avg", np.mean)
    stats.register("std", np.std)
    stats.register("1q", np.quantile, q=0.25)
    stats.register("3q", np.quantile, q=0.75)
    stats.register("min", np.min)
    stats.register("max", np.max)

    # La structure qui permet de stocker les statistiques
    logbook = tools.Logbook()

    # La structure permettant de récupérer le meilleur individu
    hof = tools.HallOfFame(1)

    # à compléter pour initialiser l'algorithme, n'oubliez pas de mettre à jour les statistiques, le logbook et le hall-of-fame.

    pop = toolbox.population(n)

    fitnesses = list(map(toolbox.evaluate, pop))
    for ind, fit in zip(pop, fitnesses):
        ind.fitness.values = fit

    record = stats.compile(pop)
    logbook.record(gen=0, fit=np.array(fitnesses)[:, 0], **record)

    CXPB, MUTPB = 0.5, 0.2

    for g in range(1, nbgen):

        offspring = toolbox.select(pop, len(pop))
        offspring = list(map(toolbox.clone, offspring))

        for child1, child2 in zip(offspring[::2], offspring[1::2]):
            if random.random() < CXPB:
                toolbox.crossover(child1, child2)
                del child1.fitness.values
                del child2.fitness.values

        for mutant in offspring:
            if random.random() < MUTPB:
                toolbox.mutate(mutant)
                del mutant.fitness.values

        invalid_ind = [ind for ind in offspring if not ind.fitness.valid]
        fitnesses = toolbox.map(toolbox.evaluate, invalid_ind)
        for ind, fit in zip(invalid_ind, fitnesses):
            ind.fitness.values = fit

        pop[:] = offspring

        record = stats.compile(pop)
        logbook.record(gen=g, **record)

        hof.update(pop)

    del creator.MaFitness
    del creator.Individual
    return pop, hof, logbook


def ea_simple2(n, nbgen, evaluate, IND_SIZE, weights=(-1.0,)):
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
    toolbox.register("bit", random.uniform, -5, 5)
    toolbox.register("individual", tools.initRepeat, creator.Individual,
                     toolbox.bit, n=IND_SIZE)
    toolbox.register("population", tools.initRepeat,
                     list, toolbox.individual, n=n)
    toolbox.register("evaluate", evaluate)
    toolbox.register("mate", tools.cxSimulatedBinary, eta=15.0)
    toolbox.register("mutate", tools.mutPolynomialBounded,
                     eta=15, low=-5, up=5, indpb=0.2)
    toolbox.register("select", tools.selTournament, tournsize=3)

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
    #fits = toolbox.map(toolbox.evaluate, population)

    invalid_ind = [ind for ind in population if not ind.fitness.valid]
    fits = toolbox.map(toolbox.evaluate, invalid_ind)
    for ind, fit in zip(invalid_ind, fits):
        ind.fitness.values = fit

    for g in range(1, nbgen):
        # Pour voir l'avancement
        # if (g % 10 == 0):
        #     print("+", end="", flush=True)
        # else:
        #     print(".", end="", flush=True)

        # à compléter en n'oubliant pas de mettre à jour les statistiques, le logbook et le hall-of-fame
        offspring = algorithms.varAnd(
            population, toolbox, cxpb=0.5, mutpb=0.15)

        fits = toolbox.map(toolbox.evaluate, offspring)
        for fit, ind in zip(fits, offspring):
            ind.fitness.values = fit

        population = toolbox.select(offspring + population, k=n)

        record = stats.compile(population)
        logbook.record(gen=g, **record)
        hof.update(population)

    del creator.MaFitness
    del creator.Individual

    return population, hof, logbook


def ea_simple3(n, nbgen, evaluate, IND_SIZE, weights=(-1.0,)):
    creator.create("MaFitness", base.Fitness, weights=weights)
    creator.create("Individual", list, fitness=creator.MaFitness)

    toolbox = base.Toolbox()
    toolbox.register("bit", random.uniform, -5, 5)
    toolbox.register("individual", tools.initRepeat, creator.Individual,
                     toolbox.bit, n=IND_SIZE)
    toolbox.register("population", tools.initRepeat,
                     list, toolbox.individual, n=n)
    toolbox.register("evaluate", evaluate)
    toolbox.register("mate", tools.cxSimulatedBinary, eta=15.0)
    toolbox.register("mutate", tools.mutPolynomialBounded,
                     eta=15, low=-5, up=5, indpb=0.2)
    toolbox.register("select", tools.selTournament, tournsize=3)

    # Numpy equality function (operators.eq) between two arrays returns the
    # equality element wise, which raises an exception in the if similar()
    # check of the hall of fame. Using a different equality function like
    # numpy.array_equal or numpy.allclose solve this issue.
    hof = tools.HallOfFame(2)
    logbook = tools.Logbook()

    stats = tools.Statistics(lambda ind: ind.fitness.values)
    stats.register("avg", np.mean)
    stats.register("std", np.std)
    stats.register("min", np.min)
    stats.register("max", np.max)

    pop = toolbox.population()

    pop, logbook = algorithms.eaSimple(pop, toolbox, cxpb=0.5, mutpb=0.1, ngen=nbgen, stats=stats,
                                       halloffame=hof, verbose=False)
    return pop,  hof, logbook


def main(n, nbgen, evaluate, IND_SIZE, ntry, weights=(-1.0,)):
    stats = [ea_simple2(n, nbgen, evaluate, IND_SIZE, weights)[2]
             for i in range(ntry)]

    moyenne = []
    fit_25 = []
    fit_75 = []

    gen = range(nbgen-1)

    for nb in range(nbgen-1):
        points = [stats[t].select('max')[nb] for t in range(ntry)]
        #print("gen", nb, points)
        fit_75.append(np.quantile(points, 0.75))
        fit_25.append(np.quantile(points, 0.25))
        moyenne.append(np.median(points, axis=0))
        #points = []

    # print(len(moyenne))
    plt.plot(gen, moyenne, label="Fitness medianne")
    plt.fill_between(gen, fit_25, fit_75, alpha=0.25, linewidth=0)
    plt.title(str(n))
    plt.legend(loc="best")
    plt.ylim((0, 11))
    # plt.show()


def main2(n, nbgen, evaluate, IND_SIZE, ntry, weights=(-1.0,)):
    stats = [ea_simple3(n, nbgen, evaluate, IND_SIZE, weights)[2]
             for i in range(ntry)]

    moyenne = []
    fit_25 = []
    fit_75 = []

    gen = range(nbgen)

    for nb in range(nbgen):
        points = [stats[t].select('avg')[nb] for t in range(ntry)]
        fit_75.append(np.quantile(points, 0.75))
        fit_25.append(np.quantile(points, 0.25))
        moyenne.append(np.median(points, axis=0))

    # print(len(moyenne))
    plt.plot(gen, moyenne, label="Fitness medianne")
    plt.fill_between(gen, fit_25, fit_75, alpha=0.25, linewidth=0)
    plt.title(str(n))
    plt.legend(loc="best")
    plt.ylim((0, 11))


if __name__ == '__main__':
    random.seed(0)
    main(n, nbgen, evaluate, IND_SIZE, ntry, weights=(-1.0,))
    main2(n, nbgen, evaluate, IND_SIZE, ntry, weights=(-1.0,))
