Vincent LIM (3970730)
Youssef KADHI (3680916)
## Partie 1

# Question 1 : Que faut-il ne pas oublier pour que le code s’exécute ?
Il faut importer “sys”

# Question 2 ; Pourquoi la fenêtre ne s’affiche pas ? Que faut-il rajouter ?
Il faut ajouter super(MainWindow, self).__init__() dans la fonction __inir__() de la classe MainWindow, 
puis créer une Qapplication à l’aide de la ligne app = QApplication(sys.argv) au début du main et exécuter l’application avec app.exec() à la fin du main.

# Question 4 : Comment connecter les actions aux slots ?
Comme on utilise des Qaction pour le menu, on peut utiliser la fonction triggered.connect(self.slot) ou alors ajouter directement triggered = self.slot) dans les paramètres lorsqu’on crée un Qaction.

# Question 6 : Le code ne s’exécute pas correctement, comment résoudre ce problème ?
Notre code s’est exécuté correctement dès la première compilation.

# Autres choses notables réalisées :
Nous avons réalisé l'option 1(barre de statut) et 2(ressource.qrc) de l'étape 3
Pour l'étape 9 nous avons ajouter le copier, coller, couper
Pour l'étape 10 nous avons réalisé dans Qdesigner la page "About" dans le menu help (fichier about.ui)

------------------------------------------------------------------------------------------------------------------
## Partie 2

# Question 1
Pour avoir un code générique, il aurait fallu faire de l'héritage pour les différentes formes

# Autres choses notables réalisées :
Pour l'étape 3 nous avons réalisé l'option ajouter la couleur du contour
Pour l'étape 5 nous avons réalisé l'option supprimer la dernière figure (undo) et supprimer toutes les figures (delete)
Pour l'étape 9 nous avons réalisé la fonction sauvegarder et charger le ficher de log
Pour l'étape 10 la méthode fonctionne bien avec plusieurs objets

Nous avons aussi implémenté le free drawing et ce qui en découle (select, mouve...) 

# Remarque:
Pour la sélection au lasso, nous l'avons réalisé par rapport au point d'origine de la forme, et donc pour la sélectionner il faut entourer l'origine
