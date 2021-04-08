import sys
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from Introduction import *
from InterTrial import *
from Canvas import *
from EndExperiment import *
import numpy as np
import time

class MainWindow(QMainWindow):

    def __init__(self, parent = None ):
        QMainWindow.__init__(self, parent )
        self.resize(600, 500)
        self.index = 0
        self.participant_id = -1

        self.introduction = Introduction()
        self.introduction.start_button.clicked.connect(self.start_experiment)

        self.canvas = Canvas(self)
        self.canvas.stopTrial.connect(self.stop_trial)
        
        self.interTrial = InterTrial(self)
        self.interTrial.startTrial.connect(self.start_trial)

        #self.endExperiment = EndExperiment(self,titre=str(self.participant_id))
        
        self.stack = QStackedWidget()
        self.stack.addWidget(self.introduction)
        self.stack.addWidget(self.interTrial)
        self.stack.addWidget(self.canvas)
        #self.stack.addWidget(self.endExperiment)
         
        
        self.setCentralWidget(self.stack)
        
        self.load_experiment_plan()
        self.content = ""
        self.participant_col = 1 #TODO
        self.trial_col       = 2 #TODO
        self.block_col       = 3 #TODO
        self.condition_col   = 4 #TODO
        self.grid_size_col   = 5 #TODO
        
        self.t0 = 0
        file = open('./header.csv', 'r')
        self.content += file.readline()
        file.close()
        

    def start_experiment(self):
        self.participant_id = self.introduction.participant_id
        print("start experiment with participant", self.participant_id)
        found = False
        while not found:
            self.index = self.index+1
            found = self.update_trial_values()
        self.setup_trial()
        
            
    def update_trial_values(self):
            same_participant = True
            if self.index >= len(self.plan):     #end of the file
                return False
            trial_str = self.plan[self.index]
            trial_str = trial_str.replace('\r\n', '')
            trial_str = trial_str.replace('\n', '')
            
            trial = trial_str.split(',')
            id = int( trial[ self.participant_col ])
            
            
            if id == self.participant_id:
                self.practice = True if trial[1] == 'true' else False
                self.practice = False
                self.block_id = trial[ self.block_col ]
                self.trial_id = trial[ self.trial_col ]
                self.condition = trial[ self.condition_col ]
                self.mat_size = int( trial[ self.grid_size_col ] ) * int( trial[ self.grid_size_col ] ) 
                print(id, self.trial_id, self.mat_size )
                same_participant = True
                self.content += str(trial[0])+"," + str(id) + "," + str(self.trial_id) + "," + str(self.block_id) + "," + self.condition + "," + str(self.mat_size) + ","
            else:
                same_participant = False
            return same_participant           


    def setup_trial(self):
        list = self.generate_stimulus()
        self.canvas.set_stimulus(list)
        self.canvas.setState(0)
        self.interTrial.set_block_trial(self.block_id, self.trial_id)
        self.interTrial.set_practice(self.practice)
        self.stack.setCurrentWidget(self.interTrial)
        

    def generate_stimulus(self):
        n = self.mat_size
        list = []
        if self.condition == 'Taille': # TODO
            cond = ['Big','Small']
            distractor =  np.random.choice(cond, 1, p=[0.5,0.5])
            distractor = distractor[0]
            target = cond[1] if distractor == cond[0] else cond[0]
            self.pos_target = np.random.randint(n)
            for i in range(0,n):
                list.append(distractor)
            list[self.pos_target] = target

        elif self.condition == 'Courbure': # TODO
            cond = ['Concavity_Big','Convexity_Big']
            distractor =  np.random.choice(cond, 1, p=[0.5,0.5])
            distractor = distractor[0]
            target = cond[1] if distractor == cond[0] else cond[0]
            self.pos_target = np.random.randint(n)
            for i in range(0,n):
                list.append(distractor)
            list[self.pos_target] = target

        elif self.condition == 'Courbure_Taille': # TODO
            cond = ['Concavity_Big', 'Concavity_Small', 'Convexity_Big', 'Convexity_Small']
            target =  np.random.choice(cond, 1, p=[0.25,0.25, 0.25, 0.25])
            target = target[0]
            self.pos_target = np.random.randint(n)
            cond.remove(target)
            nb_occurences = dict()
            # for i in cond :
            #     dict[ i ] = 0

            for i in range(0,n):
                distractor = np.random.choice(cond, 1, p=[0.333,0.333, 0.334])
                list.append(distractor[0])
                # dict[ distractor[0] ] += 1
            list[self.pos_target] = target
        return list

                 



    def start_trial(self):
        self.stack.setCurrentWidget(self.canvas)
        #print("start_trial -> target: ", self.pos_target)

        ####################
        # TODO
        ####################
        self.t0 = time.time()
        
    def stop_trial(self):
        selected_target = self.canvas.selected_target
        print("target vs. selected target: "+ str(self.pos_target) +  " vs. " + str(selected_target) )

        ####################
        # TODO
        ####################
        self.content += str(self.total) + "," + str(self.pos_target==selected_target) + "\n"
        self.index = self.index + 1
        if self.update_trial_values():
            self.setup_trial()
        else:
            print("End of the experiment. Thanks")
            title = "participant_" + str(self.participant_id)
            self.save_user_data(title, self.content)
            
            ####################
            # TODO
            ####################
            self.endExperiment = EndExperiment(self,titre=str(title))
            self.stack.addWidget(self.endExperiment)
            self.stack.setCurrentWidget(self.endExperiment)
            

        

    ####################
    def keyReleaseEvent(self, e):
        if e.key() == Qt.Key_Space:
            if self.interTrial.isVisible():
                self.start_trial()
            elif self.canvas.isVisible():
                self.canvas.setState(1)
                self.t1 = time.time()
                self.total = self.t1 - self.t0
                print("time taken :" + str(self.total)+" s")
    

    ##############
    def load_experiment_plan(self):
        file = open('./mon_experiment.csv', 'r') # TODO
        self.plan = file.readlines()
        file.close()

    ##############
    def save_user_data(self, title, content):
        with open('./logs/'+title + '.csv', 'w') as fileSave:
            fileSave.write(content)
            fileSave.close()

if __name__=="__main__":
   
    app = QApplication(sys.argv)

    window = MainWindow()
    window.show()
    app.exec_()
