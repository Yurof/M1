from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *



class Canvas(QWidget):

    def __init__(self, parent = None):
        super(Canvas, self).__init__()
        self.parent = parent
        self.cpt = 1    # Compteur pour avoir des clefs distincts dans le dictionnaire self.listForm
        self.pStart = None  # Coordonnée initial lors de mousePressEvent
        self.pFinish = None # Coordonnée enregistré tant que le clique gauche est maintenu
        self.pTmp = None # Coordonnée intermédiaire pour tracer des lignes en free_drawing
        self.form = "rec" # Forme à dessiner, prend 2 valeurs "rec" ou "ell"
        self.penColor = Qt.black
        self.brushColor = Qt.lightGray
        self.listForm = {} # Dictionnaire de toutes les formes à dessiner
        self.mode = "draw" # Mode "draw" "move" "select"
        self.selectedForm = {} # Dictionnaire des formes sélectionnées
        self.selectLine = [] # Liste de coordonnées pour tracer le trait de selection
        self.selectPolygon = QPolygon() # List des points pour pouvoir effectuer la selection

    def paintEvent(self, event):
        painter = QPainter(self)   
        # Tracer les formes dessinées
        if self.listForm:
            for form in self.listForm.values():
                painter.setPen(form["penCol"])
                painter.setBrush(form["brushCol"])
                if form["type"] == "rec":
                    painter.drawRect(form["param"])
                elif form["type"] == "ell":
                    painter.drawEllipse(form["param"])
                elif form["type"] == "free":
                    for line in form["param"]:
                        painter.drawLine(line)
                
        # Tracer une forme "fantome" par dessus les formes sélectionnées
        if self.selectedForm:
            for form in self.selectedForm.values():
                painter.setPen(form["penCol"])
                painter.setBrush(form["brushCol"])
                if form["type"] == "rec":
                    painter.drawRect(form["param"])
                if form["type"] == "ell":
                    painter.drawEllipse(form["param"])
                elif form["type"] == "free":
                    for line in form["param"]:
                        painter.drawLine(line)
        
        # Tracer le trait de sélection
        painter.setPen(Qt.black)
        if len(self.selectLine) >= 2:
            for i in range (len(self.selectLine) - 1):
                painter.drawLine(self.selectLine[i], self.selectLine[i+1])
                
                

        
        
    def mousePressEvent(self, event):
        self.selectedForm = {}
        self.pStart = event.pos()
        self.pFinish = event.pos()
        self.pTmp = event.pos()
        
        # Draw
        if self.mode == "draw":
            if self.form =="rec":
                self.listForm["form"+str(self.cpt)] = {"type":"rec", "param":QRect(self.pStart.x(), self.pStart.y(), self.pFinish.x() - self.pStart.x(), self.pFinish.y() - self.pStart.y()),"penCol":self.penColor, "brushCol":self.brushColor}
            elif self.form == "ell":
                self.listForm["form"+str(self.cpt)] = {"type":"ell", "param":QRect(self.pStart.x(), self.pStart.y(), self.pFinish.x() - self.pStart.x(), self.pFinish.y() - self.pStart.y()),"penCol":self.penColor, "brushCol":self.brushColor}
            elif self.form == "free":
                self.listForm["form"+str(self.cpt)] = {"type":"free", "param":[],"penCol":self.penColor, "brushCol":self.brushColor}
        
        # Select
        elif self.mode == "select":
            self.selectLine = [self.pStart]
            self.selectPolygon.append(QPoint(self.pStart))
        self.update()
        
    def mouseReleaseEvent(self, event):
        self.pFinish = event.pos()
        
        # Draw
        if self.mode == "draw":
            if self.pStart == self.pFinish: # Supprimer la forme si on a les mêmes coordonnées
                del self.listForm["form"+(str(self.cpt))]
            else:
                if self.form == "free":
                    self.parent.log_action("form"+str(self.cpt) + " : " + self.listForm["form"+str(self.cpt)]["type"])
                else:
                    x, y, _, _ = self.listForm["form"+str(self.cpt)]["param"].getCoords()
                    self.parent.log_action("form"+str(self.cpt) + " : " + str(self.listForm["form"+str(self.cpt)]["type"]) + "(" + str(x) + ", " + str(y) + ")")
                self.cpt +=1
        
        # Select
        elif self.mode == "select":
            if self.pStart == self.pFinish:
                for key, val in self.listForm.items():
                    if val["type"] == "free":
                        continue
                        # Pas réussi à gérer la sélection d'une ligne en un clique
                        # for point in val["param"]:
                        #     if point.x() == event.pos().x() and point.y() == event.pos().y():
                        #         self.selectedForm[key] = {"type":val["type"], "param":val["param"], "penCol":Qt.red, "brushCol":Qt.black}
                    else:
                        if val["param"].contains(event.pos()):
                            self.selectedForm[key] = {"type":val["type"], "param":val["param"], "penCol":Qt.red, "brushCol":Qt.black}
            for key, val in self.selectedForm.items():
                self.parent.log_action(str(key) + " selectionnée")
            self.selectLine = []
            self.selectPolygon = QPolygon()
        self.update()
        
    def mouseMoveEvent(self, event):
        self.pFinish = event.pos()
        
        # Draw
        if self.mode == "draw":
            if self.listForm["form"+str(self.cpt)]["type"] == "free":
                self.listForm["form"+str(self.cpt)]["param"].append(QLine(QPoint(self.pTmp.x(), self.pTmp.y()), QPoint(self.pFinish.x(), self.pFinish.y())))
                self.pTmp = self.pFinish
            else:
                self.listForm["form"+str(self.cpt)]["param"] = QRect(self.pStart.x(), self.pStart.y(), self.pFinish.x() - self.pStart.x(), self.pFinish.y() - self.pStart.y())
        
        # Move
        elif self.mode == "move":
            xTranspose = self.pFinish.x() - self.pStart.x()
            yTranspose = self.pFinish.y() - self.pStart.y()
            self.pStart = self.pFinish
            for key in self.listForm.keys(): 
                if self.listForm[key]["type"] == "free":
                    for i in range (len(self.listForm[key]["param"])):
                        self.listForm[key]["param"][i].translate(xTranspose, yTranspose)
                else:
                    self.listForm[key]["param"].translate(xTranspose, yTranspose)
        
        # Select
        elif self.mode == "select":
            for key, val in self.listForm.items():
                if val["type"] == "free":
                    if self.selectPolygon.containsPoint(val["param"][0].p1(), 1):
                        self.selectedForm[key] = {"type":val["type"], "param":val["param"], "penCol":Qt.red, "brushCol":Qt.black}       
                else:
                    x1, x2, _, _ = val["param"].getCoords()
                    if self.selectPolygon.containsPoint(QPoint(x1, x2), 1):
                        self.selectedForm[key] = {"type":val["type"], "param":val["param"], "penCol":Qt.red, "brushCol":Qt.black}
            self.selectLine.append(self.pFinish)
            self.selectPolygon.append(QPoint(self.pFinish))
        self.update()

        
    def changePenColor(self, color):
        if self.selectedForm:   # Si des formes sont selectionnées
            for key in self.selectedForm.keys(): # Changer uniquement leurs attributs
                self.selectedForm[key]["penCol"] = color
                self.listForm[key]["penCol"] = color
            self.update()
        else:   # Sinon changer l'attribut du pinceau pour les prochaines formes
            self.penColor = color

    def changeBrushColor(self, color):
        if self.selectedForm:
            for key in self.selectedForm.keys():
                self.selectedForm[key]["brushCol"] = color
                self.listForm[key]["brushCol"] = color
            self.update()
        else:
            self.brushColor = color

    def changeToRec(self):
        if self.selectedForm:
            for key, val in self.selectedForm.items():
                if not val["type"] == "free":
                    self.selectedForm[key]["type"] = "rec"
                    self.listForm[key]["type"] = "rec"
            self.update()
        else:
            self.mode = "draw"
            self.form = "rec"

    def changeToEll(self):
        if self.selectedForm:
            for key, val in self.selectedForm.items():
                if not val["type"] == "free":
                    self.selectedForm[key]["type"] = "ell"
                    self.listForm[key]["type"] = "ell"
            self.update()
        else:
            self.mode = "draw"
            self.form = "ell"
    
    def changeToFreeDrawing(self):
        self.mode = "draw"
        self.form = "free"