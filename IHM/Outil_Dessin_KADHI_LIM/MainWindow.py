#Vincent LIM (3970730)
#Youssef KADHI (3680916)

import sys
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from Canvas import *
import resources
from PyQt5.uic import loadUi

class MainWindow(QMainWindow):

    def __init__(self, parent = None ):
        QMainWindow.__init__(self, parent )
        print( "init mainwindow")
        self.resize(600, 500)

#####
        self.setWindowTitle('IHM paint')
        self.setWindowIcon(QIcon(':/icons/paint.png'))   

        # Barre de menu
        bar = self.menuBar()
        fileMenu = bar.addMenu("File")
        colorMenu = bar.addMenu("Color")
        shapeMenu = bar.addMenu("Shape")
        modeMenu = bar.addMenu("Mode")
        helpMenu = bar.addMenu("Help")

        
        # Barre d'outils
        fileToolBar = QToolBar("File")
        self.addToolBar(fileToolBar)
        colorToolBar = QToolBar("Color")
        self.addToolBar( colorToolBar )
        shapeToolBar = QToolBar("Shape")
        self.addToolBar( shapeToolBar )
        modeToolBar = QToolBar("Mode")
        self.addToolBar( modeToolBar )

        # Barre de status (bas de fenetre)
        statusBar = QStatusBar()
        self.setStatusBar(statusBar)
        
        # New
        newAct = QAction(QIcon(":/icons/new.png"), "&New", self) # Definir un icone et un nom
        newAct.setShortcut(QKeySequence("Ctrl+N")) # Definir un raccourci clavier
        newAct.setToolTip("New") # Definir un texte qui apparait à côté de la souris lorsqu'elle passe sur l'icone
        newAct.setStatusTip("New") # Definir un texte qui apparait dans la barre de statut lorsque la souris passe sur la fonctionnalité
                                   # (dans la barre de menu ou la barre d'outils)
        fileMenu.addAction(newAct)# Ajouter a la section file dans la barre de menu
        fileToolBar.addAction(newAct) # Ajouter dans la barre d'outils
        newAct.triggered.connect(self.new) # Déclencher la fonction new() lorsqu'on déclenche la fonctionnalité
        
        # Open
        actOpen = QAction(QIcon(":/icons/open.png"), "&Open", self, triggered = self.open) # On peut definir le trigger ici aussi
        actOpen.setShortcut(QKeySequence("Ctrl+O"))
        actOpen.setStatusTip("Open")
        fileMenu.addAction(actOpen)
        fileToolBar.addAction(actOpen)

        # Save
        actSave = QAction(QIcon(":/icons/save.png"), "&Save", self, triggered = self.save) # On peut definir le trigger ici aussi
        actSave.setShortcut(QKeySequence("Ctrl+S"))
        actSave.setStatusTip("Save")
        fileMenu.addAction(actSave)
        fileToolBar.addAction(actSave)
        
        # Quit
        actQuit = QAction(QIcon(":/icons/quit.png"), "&Quit", self, triggered = self.quit)
        actQuit.setShortcut(QKeySequence("Ctrl+Q"))
        actQuit.setStatusTip("Quit")
        fileMenu.addAction(actQuit)
        fileToolBar.addAction(actQuit)

        # Cut
        actCut = QAction(QIcon(':/icons/cut.png'), 'Cut', self,triggered = self.cut)
        actCut.setShortcut('Ctrl+X')
        actCut.setStatusTip("Cut")
        fileToolBar.addAction(actCut)
        
        # Copy
        actCopy = QAction(QIcon(':/icons/copy.png'), '&Copy', self,triggered = self.copy)
        actCopy.setShortcut('Ctrl+C')
        actCopy.setStatusTip("Copy")
        fileToolBar.addAction(actCopy)

        # Paste
        actPaste = QAction(QIcon(':/icons/paste.png'), 'Paste', self,triggered = self.paste)
        actPaste.setShortcut('Ctrl+V')
        actPaste.setStatusTip("Paste")
        fileToolBar.addAction(actPaste)

        # Pen Color
        actPen = colorMenu.addAction(QIcon(":/icons/pen.png"), "&Pen color", self.pen_color, QKeySequence("Ctrl+P"))
        actPen.setStatusTip("Set Pen Color")
        colorToolBar.addAction( actPen )
        
        # Brush Color
        actBrush = colorMenu.addAction(QIcon(":/icons/brush.png"), "&Brush color", self.brush_color, QKeySequence("Ctrl+B"))
        actBrush.setStatusTip("Set Brush Color")
        colorToolBar.addAction( actBrush )

        # Rectangle
        actRectangle = shapeMenu.addAction(QIcon(":/icons/rectangle.png"), "&Rectangle", self.rectangle )
        actRectangle.setStatusTip("Rectangle")
        shapeToolBar.addAction( actRectangle )
        
        # Ellipse
        actEllipse = shapeMenu.addAction(QIcon(":/icons/ellipse.png"), "&Ellipse", self.ellipse)
        actEllipse.setStatusTip("Ellipse")
        shapeToolBar.addAction( actEllipse )
        
        # Free
        actFree = shapeMenu.addAction(QIcon(":/icons/free.png"), "&Free drawing", self.free_drawing)
        actFree.setStatusTip("Free")
        shapeToolBar.addAction( actFree )

        actMove = modeMenu.addAction(QIcon(":/icons/move.png"), "&Move", self.move)
        actMove.setStatusTip("Move")
        modeToolBar.addAction( actMove )
        
        
        actDraw = modeMenu.addAction(QIcon(":/icons/draw.png"), "&Draw", self.draw)
        actDraw.setStatusTip("Draw")
        modeToolBar.addAction( actDraw )
        
        actSelect = modeMenu.addAction(QIcon(":/icons/select.png"), "&Select", self.select)
        actSelect.setStatusTip("Select")
        modeToolBar.addAction( actSelect )

        actUndo = modeMenu.addAction(QIcon(":/icons/undo.png"), "&Undo", self.undo)
        actUndo.setStatusTip("Undo")
        modeToolBar.addAction( actUndo )

        actDelete = modeMenu.addAction(QIcon(":/icons/delete.png"), "&Delete", self.delete)
        actDelete.setStatusTip("Delete")
        modeToolBar.addAction( actDelete )

        actAbout = helpMenu.addAction(QIcon(":/icons/about.png"), "&About", self.about)

        v_layout = QVBoxLayout()
        self.textEdit = QTextEdit(self)
        v_layout.addWidget(self.textEdit)
        self.canvas = Canvas(self)
        self.canvas.setMinimumSize(300,300)
        v_layout.addWidget(self.canvas)
        
        widget = QWidget()
        widget.setLayout(v_layout)
        self.setCentralWidget(widget)

    ##############
    
    def new(self):
        print("New...")
        bouton = QMessageBox.question(self, 'new', "Create a new document ? Unsaved changes will be lost", QMessageBox.Yes | QMessageBox.No )
        if bouton == QMessageBox.Yes:
            self.textEdit.setHtml("")

    def open(self):
        print("Open...")
        fileName = QFileDialog.getOpenFileName(self, "Open file", "./", "*.txt")
        if fileName:
            with open(fileName[0], 'r') as f:
                text = f.read()
                f.close()
            self.textEdit.setText(text)
	
    def save(self):
        print("Save...")
        fileName = QFileDialog.getSaveFileName(self, "Save file", "./")
        if fileName:
            with open(fileName[0], 'w') as f:
                f.write(self.textEdit.toPlainText())
                f.close()

    def cut(self):
        self.textEdit.cut()
	
    def copy(self):
        self.textEdit.copy()

    def paste(self):
        self.textEdit.paste()
	
    def quit(self):
        print("Quit...")
        self.close()

    def closeEvent(self, event):
        bouton = QMessageBox.question(self, 'quit', "Do you want to quit ? Unsaved changes will be lost", QMessageBox.Yes | QMessageBox.No )
        if bouton == QMessageBox.Yes:
            event.accept()
        else:
            event.ignore()

    def pen_color(self):
        self.log_action("choose pen color")
        self.canvas.changePenColor(QColorDialog.getColor())


    def brush_color(self):
        self.log_action("choose brush color")
        self.canvas.changeBrushColor(QColorDialog.getColor())
        
    def rectangle(self):
        self.log_action("Shape mode: rectangle")
        self.canvas.changeToRec()

    def ellipse(self):
        self.log_action("Shape Mode: circle")
        self.canvas.changeToEll()

    def free_drawing(self):
        self.log_action("Shape mode: free drawing")
        self.canvas.changeToFreeDrawing()

    def move(self):
        self.log_action("Mode: move")
        self.canvas.mode = "move"

    def draw(self):
        self.log_action("Mode: draw")
        self.canvas.mode = "draw"

    def select(self):
        self.log_action("Mode: select")
        self.canvas.mode = "select"
    
    def delete(self): #supprime toutes les figures
        self.canvas.listForm.clear()
        self.canvas.cpt=1
        self.canvas.update()

    def undo(self): #supprime la dernière figure
        if self.canvas.listForm:
            self.canvas.listForm.popitem()
            self.canvas.cpt-=1
            self.canvas.update()

    def log_action(self, str):
        content = self.textEdit.toPlainText()
        self.textEdit.setPlainText( content + "\n" + str)
        
    def about(self):
        dialog = about(self)
        dialog.exec()

class about(QDialog):
    def __init__(self, parent=None):
        super().__init__(parent)
        loadUi("about.ui", self)


if __name__=="__main__":
    app = QApplication(sys.argv)

    window = MainWindow()
    window.show()
    app.exec_()
