import sys
from PyQt5.QtWidgets import *


class MainWindow(QMainWindow):
	
	def __init__(self):
		super(MainWindow, self).__init__()
		print("constructeur de la class MainWindow")
#
#
#	###############
#	def open(self):
#		print("Open...")
#	
#	###############
#	def save():
#		print("Save")		
#
#	###############
#	def quit():
#		print("Quit")		



def main(args):
	app=QApplication(sys.argv)
	fenetre = MainWindow()
	fenetre.show()
	app.exec_()
	print("Hello World")
	
	

if __name__ == "__main__":
	main(sys.argv) 