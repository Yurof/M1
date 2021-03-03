import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from pathlib import Path    

import resources
from PyQt5.uic import loadUi


class MainWindow(QMainWindow):
	
	def __init__(self):
		super(MainWindow, self).__init__()
		self.resize(500, 500)
		self.initUI()
	
	def initUI(self):
		self.setWindowTitle('notepad')
		self.setWindowIcon(QIcon(':/notepad.png'))   

		bar = self.menuBar()
		fileMenu = bar.addMenu( "File" )
		fileMenu2 = bar.addMenu( "Help" )
		toolbar = self.addToolBar('')

		newAct = QAction(QIcon("new.png"), "new...", self )
		newAct.setShortcut( QKeySequence("Ctrl+N" ) )
		fileMenu.addAction(newAct)
		toolbar.addAction(newAct)
		newAct.triggered.connect( self.new )

		newAct = QAction(QIcon("open.png"), "open...", self )
		newAct.setShortcut( QKeySequence("Ctrl+O" ) )
		fileMenu.addAction(newAct)
		toolbar.addAction(newAct)		
		newAct.triggered.connect( self.open )

		newAct = QAction(QIcon("save.png"), "save..", self )
		newAct.setShortcut( QKeySequence("Ctrl+S" ) )
		fileMenu.addAction(newAct)
		toolbar.addAction(newAct)
		newAct.triggered.connect( self.save )

		newAct = QAction(QIcon("quit.png"), "quit...", self )
		newAct.setShortcut( QKeySequence("Ctrl+Q" ) )
		fileMenu.addAction(newAct)
		newAct.triggered.connect( self.quit )
		
		newAct = QAction(QIcon('copy.png'), 'copy', self)
		newAct.setShortcut('Ctrl+C')
		toolbar.addAction(newAct)
		newAct.triggered.connect(self.copy)

		newAct = QAction(QIcon('cut.png'), 'cut', self)
		newAct.setShortcut('Ctrl+X')
		toolbar.addAction(newAct)
		newAct.triggered.connect(self.cut)

		newAct = QAction(QIcon('paste.png'), 'past', self)
		newAct.setShortcut('Ctrl+V')
		toolbar.addAction(newAct)
		newAct.triggered.connect(self.paste)

		newAct = QAction(QIcon("about.png"), "About...", self )
		fileMenu2.addAction(newAct)
		newAct.triggered.connect( self.about )

		self.statusBar().showMessage(' statusbar')

		self.textEdit = QTextEdit ( self )
		self.setCentralWidget( self.textEdit  )

		finish = QAction("Quit", self)
		finish.triggered.connect(self.closeEvent)



	def open(self):
		fileName = QFileDialog.getOpenFileName(self, "Open file", "", "*.html") 
		titre = Path(fileName[0]).name
		if fileName:
			with open(fileName[0], 'r') as f:
				html = f.read()
				f.close()
			self.textEdit.setHtml(html)

	def save(self):
		fileName = QFileDialog.getSaveFileName(self, "Save file", "", "*.html") 
		#print (self.textEdit.toPlainText())
		if fileName:
			with open(fileName[0], 'w') as f:
				f.write(self.textEdit.toHtml())
				f.close()

	def quit(self):
		self.close()

	def new(self):
		bouton = QMessageBox.question(self, 'new', "Do you want to delete all not saved change and create a new document  ?", QMessageBox.Yes | QMessageBox.No )
		if bouton == QMessageBox.Yes:
			self.textEdit.setHtml("")

	def closeEvent(self, event):
			bouton = QMessageBox.question(self, 'quit', "Do you want to quit ?", QMessageBox.Yes | QMessageBox.No )
			if bouton == QMessageBox.Yes:
				event.accept()
			else:
				event.ignore()

	def cut(self):
		self.textEdit.cut()
	
	def copy(self):
		self.textEdit.copy()

	def paste(self):
		self.textEdit.paste()

 
	def about(self):
			dialog = about(self)
			dialog.exec()

class about(QDialog):
    def __init__(self, parent=None):
        super().__init__(parent)
        loadUi("about.ui", self)


def main(args):
	app= QApplication(sys.argv)
	fenetre = MainWindow()
	fenetre.show()
	app.exec_()

if __name__ == "__main__":
	main(sys.argv) 