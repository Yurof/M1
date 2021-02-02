import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from pathlib import Path    


class MainWindow(QMainWindow):
	
	def __init__(self):
		super(MainWindow, self).__init__()
		self.resize(500, 500)

		bar = self.menuBar()
		fileMenu = bar.addMenu( "Fichier" )

		newAct = QAction(QIcon("open.png"), "open...", self )
		newAct.setShortcut( QKeySequence("Ctrl+O" ) )
		#newAct.setToolTip("open")
		#newAct.setStatusTip("open")
		fileMenu.addAction(newAct)
		newAct.triggered.connect( self.open )

		newAct2 = QAction(QIcon("save.png"), "save..", self )
		newAct2.setShortcut( QKeySequence("Ctrl+S" ) )
		#newAct2.setToolTip("save")
		#newAct2.setStatusTip("save")
		fileMenu.addAction(newAct2)
		newAct2.triggered.connect( self.save )


		newAct3 = QAction(QIcon("quit.png"), "quit...", self )
		newAct3.setShortcut( QKeySequence("Ctrl+Q" ) )
		#newAct3.setToolTip("quit")
		#newAct3.setStatusTip("quit")
		fileMenu.addAction(newAct3)
		newAct3.triggered.connect( self.quit )

		self.textEdit = QTextEdit ( self )
		self.setCentralWidget( self.textEdit  )


	def open(self):
		fileName = QFileDialog.getOpenFileName(self, "Open file", "", "*.html *.txt") 
		titre = Path(fileName[0]).name
		if fileName:
			with open(fileName[0], 'r') as f:
				html = f.read()
				print(html)
			self.textEdit.setHtml(html)
		#print("Open...")

	def save(self):
		QFileDialog.getSaveFileName(self, "Save file", "", "*.txt") 

		print("Save")		

	def quit(self):
		print("Quit")		



def main(args):
	app= QApplication(sys.argv)
	fenetre = MainWindow()
	fenetre.show()
	app.exec_()

if __name__ == "__main__":
	main(sys.argv) 