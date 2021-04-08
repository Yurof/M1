# Question 1 : Que faut-il ne pas oublier pour que le code s’exécute ?
Il faut importer “sys”

# Question 2 ; Pourquoi la fenêtre ne s’affiche pas ? Que faut-il rajouter ?
Il faut ajouter super(MainWindow, self).__init__() dans la fonction __inir__() de la classe MainWindow, 
puis créer une Qapplication à l’aide de la ligne app = QApplication(sys.argv) au début du main et exécuter l’application avec app.exec() à la fin du main.

# Question 4 : Comment connecer les actions aux slots ?
Comme on utilise des Qaction pour le menu, on peut utiliser la fonction triggered.connect(self.slot) ou alors ajouter directement triggered = self.slot) dans les paramètres lorsqu’on crée un Qaction.

# Question 6 : Le code ne s’exécute pas correctement, comment résoudre ce problème ?
Notre code s’est exécuté correctement dès la première compilation.

# Autres choses notable réalisé :
Nous avons réalisé l'option 1 et 2 de l'étape 3,
Pour l'étape 9 nous avons ajouter le copier, coller, couper
Pour l'étape 10 nous avons réalisé dans Qdesigner la page "About" dans le menu help
