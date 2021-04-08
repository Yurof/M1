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

from nsga2 import my_nsga2

nn = SimpleNeuralControllerNumpy(4, 1, 2, 5)
IND_SIZE = len(nn.get_parameters())

env = gym.make('CartPole-v1')


def eval_nn(genotype, render=False, nbstep=500):
    total_x = 0  # l'erreur en x est dans observation[0]
    total_theta = 0  # l'erreur en theta est dans obervation[2]
    nn = SimpleNeuralControllerNumpy(4, 1, 2, 5)
    nn.set_parameters(genotype)

    observation = env.reset()
    # à compléter
    obs = env.reset()
    for i in range(nbstep):
        cpt = 0
        er_theta = 0
        er_x = 0
        if render:
            env.render()

        if nn.predict(obs)[0] > 0:
            action = 1
        else:
            action = 0

        obs, reward, done, info = env.step(action)
        # print(obs)
        cpt += 1
        er_x += abs(observation[0])  # * (nbsteps - cpt)
        er_theta += abs(observation[2])  # * (nbsteps - cpt)
        if done:
            break
    total_x += er_x*(nbstep + 1 - cpt)
    total_theta += er_theta*(nbstep + 1 - cpt)

    # ATTENTION: vous êtes dans le cas d'une fitness à minimiser. Interrompre l'évaluation le plus rapidement possible est donc une stratégie que l'algorithme évolutionniste peut utiliser pour minimiser la fitness. Dans le cas ou le pendule tombe avant la fin, il faut donc ajouter à la fitness une valeur qui guidera l'apprentissage vers les bons comportements. Vous pouvez par exemple ajouter n fois une pénalité, n étant le nombre de pas de temps restant. Cela poussera l'algorithme à minimiser la pénalité et donc à éviter la chute. La pénalité peut être l'erreur au moment de la chute ou l'erreur maximale.

    return (total_x, total_theta)


if (__name__ == "__main__"):

    # à compléter

    env.close()
