# LDVH : Le livre dont VOUS êtes le héros !
Un livre dont vous êtes le héros est un genre de roman ayant pour caractéristique d'être interactif, le déroulement de l'histoire dépendant des choix du lecteur.
Chaque section du livre est numérotée et peut offrir un ou plusieurs enchaînements vers
d’autres sections (jamais d’une section vers elle-même !) selon les choix que fait le lecteur.
Certains de ces choix peuvent être conditionnés par le fait que le lecteur ait préalablement
atteint un certain objectif, par exemple pour ouvrir la porte de la section 131, il faut avoir
obtenu la clé en traversant la section 72. Chaque section peut donc contenir des objets, qui
sont ajoutés automatiquement à l’inventaire du héros quand il traverse la section. L’inventaire
du héros est géré par une fiche de personnage où sont notés les objets obtenus au cours de
l’aventure. La liste des objets que l’on peut obtenir dans une aventure donnée est définie par
l’auteur.  
Le livre débute toujours par la section 1, mais une ou plusieurs sections peuvent mener à la fin
du livre, soit parce que le héros est mort, soit par une fin plus heureuse à l’aventure.

Vous allez réaliser un logiciel d’aide à la création de livres dont vous êtes le héros.
L’auteur crée un nouveau livre (en fixant son titre…) ou charge un livre existant
(précédemment sauvegardé). Il peut alors construire une section en rédigeant son texte. Il peut
aussi définir un nouvel enchaînement entre sections. Les enchaînements peuvent être annotés
par une condition, qui définit les prérequis (objets obtenus) pour franchir cet enchaînement.
L’ensemble est présenté à l’auteur dans une interface graphique qui permet de visualiser le
graphe complet des enchaînements possibles. Une analyse du graphe par l’outil permet de
détecter les sections inatteignables, parce qu’il n’existe pas de chemin depuis la section 1 à la
section incriminée.  
Une fois le graphe des sections et enchainements construit, l’auteur peut demander la
génération d’une version imprimable du livre. Pour ce faire, l’outil numérote les sections de
façon aléatoire (sauf la section 1) puis génère un texte qui capture les enchaînements.
L’auteur peut également demander la génération d’un jeu de pages HTML permettant à un
lecteur de jouer le livre interactivement en ligne. Chaque page HTML correspond à une
section, et seuls les choix actifs (dont la condition est remplie) sont visibles.
L’auteur peut ensuite facilement déployer ces pages web sur un quelconque hébergeur web
pour les offrir au public. Il suffit enfin au lecteur de visiter avec un navigateur web la section 1
du livre pour entamer l’aventure. La gestion de l’inventaire sera réalisée par des cookies HTTP
de durée la session. 
