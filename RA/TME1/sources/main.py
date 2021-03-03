#!/usr/local/bin/python
#KADHI YOUSSEF
#LIM VINCENT
import numpy as np
import time
# from rbfn import RBFN
from lwr import LWR
from line import Line
from sample_generator import SampleGenerator
from rbfn import RBFN
import matplotlib.pyplot as plt


class Main:
    def __init__(self):
        self.x_data = []
        self.y_data = []
        self.batch_size = 50

    def reset_batch(self):
        self.x_data = []
        self.y_data = []

    def make_nonlinear_batch_data(self):
        """ 
        Generate a batch of non linear data and store it into numpy structures
        
        """
        self.reset_batch()
        g = SampleGenerator()
        for i in range(self.batch_size):
            # Draw a random sample on the interval [0,1]
            x = np.random.random()
            y = g.generate_non_linear_samples(x)
            self.x_data.append(x)
            self.y_data.append(y)

    def make_linear_batch_data(self):
        """ 
        Generate a batch of linear data and store it into numpy structures
        """
        self.reset_batch()
        g = SampleGenerator()
        for i in range(self.batch_size):
            # Draw a random sample on the interval [0,1]
            x = np.random.random()
            y = g.generate_linear_samples(x)
            self.x_data.append(x)
            self.y_data.append(y)

    def approx_linear_batch(self):
        model = Line(self.batch_size)

        self.make_linear_batch_data()
        
        start = time.process_time()
        model.train(self.x_data, self.y_data)
        print("LLS time:", time.process_time() - start)
        model.plot(self.x_data, self.y_data, "LLS")
        
        start = time.process_time()
        model.train_from_stats(self.x_data, self.y_data)
        print("LLS from scipy stats:", time.process_time() - start)
        model.plot(self.x_data, self.y_data,"LLS from scipy stats")
        
        start = time.process_time()
        model.train_regularized(self.x_data, self.y_data, coef=0.01)
        print("regularized LLS :", time.process_time() - start)
        model.plot(self.x_data, self.y_data, "regularized LLS")
        
        """
        #sert a avoir le residual selon le coef
        List_y=[]
        List_x =[]
        for k in range(1, 50):
            List_y.append( model.train_regularized(self.x_data, self.y_data, coef=k/10))
            List_x.append(k/10)
        plt.plot( List_x, List_y )
        plt.title("residual by coef")
        plt.show()
        """

    def approx_rbfn_batch(self):
        nb_features =10
        model = RBFN(nb_features)
        self.make_nonlinear_batch_data()
        
        start = time.process_time()
        model.train_ls(self.x_data, self.y_data)
        print("RBFN LS time:", time.process_time() - start)
        model.plot(self.x_data, self.y_data,"RBFN LS , nb_features="+str(nb_features))
        
        
        start = time.process_time()
        model.train_ls2(self.x_data, self.y_data)
        print("RBFN LS2 time:", time.process_time() - start)
        model.plot(self.x_data, self.y_data, "RBFN LS2, nb_features="+str(nb_features))
        
    
    def approx_rbfn_iterative(self):
        max_iter = 50
        nb_features = 10
        model = RBFN(nb_features)
        start = time.process_time()
        # Generate a batch of data and store it
        self.reset_batch()
        g = SampleGenerator()
        alpha=0.7
        for i in range(max_iter):
            # Draw a random sample on the interval [0,1]
            x = np.random.random()
            y = g.generate_non_linear_samples(x)
            self.x_data.append(x)
            self.y_data.append(y)
            
            # Comment the ones you don't want to use
            model.train_gd(x, y, alpha)
            #model.train_rls(x, y)
            #model.train_rls2(x,y)
            #model.train_rls_sherman_morrison(x, y)

        print("RBFN Incr time:", time.process_time() - start)
        model.plot(self.x_data, self.y_data,"RBFN ite , max_iter="+str(max_iter)+" nb_feature="+str(nb_features))

    
    def approx_lwr_batch(self):
        nb_features=10
        model = LWR(nb_features)
        self.make_nonlinear_batch_data()

        start = time.process_time()
        model.train_lwls(self.x_data, self.y_data)
        print("LWR time:", time.process_time() - start)
        model.plot(self.x_data, self.y_data, "LWR, nb_features="+str(nb_features))
    

if __name__ == '__main__':
    m = Main()
    m.approx_linear_batch()
    m.approx_rbfn_batch()
    m.approx_rbfn_iterative()
    m.approx_lwr_batch()
