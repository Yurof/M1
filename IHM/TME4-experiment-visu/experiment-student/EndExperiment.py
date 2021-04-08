from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import sys
from MainWindow import *


from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas

from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar


class EndExperiment(QWidget):
	def __init__(self, parent = None, titre=''):
		QWidget.__init__(self, parent )
		self.resize(600, 500)
		print("title ",titre)
		#self.setFocusPolicy(Qt.StrongFocus)
		layout = QGridLayout(self)
		thanks_lab = QLabel()
		thanks_lab.setText("Fin de l'experience. Merci pour votre participation,"+str(titre))		
		layout.addWidget(thanks_lab)

		#######################
		# read csv file
		#######################
		#read your csv file and add the header
		df = pd.read_csv( './logs/'+titre + '.csv')
		print(df)

		self.figure = plt.figure( tight_layout=True )

		self.canvas = FigureCanvas( self.figure )

		self.canvas.setSizePolicy( QSizePolicy( QSizePolicy.Expanding, QSizePolicy.Expanding ) )

		self.toolbar = NavigationToolbar(self.canvas, self )

		layout.addWidget( self.toolbar )

		layout.addWidget( self.canvas )

		plt.subplot(121)
		sns.barplot(x="Condition",y="Time",data=df)
		self.canvas.draw() 
		self.canvas.show()

		plt.subplot(122)
		sns.countplot(x="Success", data=df)
		self.canvas.draw() 
		self.canvas.show()

		##################
		# chart
		##################




