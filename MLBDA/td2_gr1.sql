TD2-TD3
----Exo2
--I Création types

Create type Unité As Object;
/--important sinon show error
create type L_Unités As Table of REF Unité;
--Table of est un ensemble(non ordonnée et modifiable, 
--diff de varray(taille) qui est une list ordonnée non modifiable)
--REF pour ne pas creer une unité MLBDA pour chaque étudiant
/
Create type Etudiant As Object(
    numéro Number(10), 
    nom Varchar2(20),
    âge Number(2),
    année Number(1),
    contrat L_Unités
);
/
Create type L_Etudiants as Table of REF Etudiant;
/
Create type Séance As Object(
    numéro Number(2)
    sujet Varchar(2),
    présents L_Etudiants 
);
/
Create type L_Séances As Table of Séance;--chaque séance est unique,
-- peut etre stockée par la suite dans la Table de l'unité correspondant et non pas dans une Table séparée
/
Create type T_note As object (
    note number(4,2),
    étu REF Etudiant
); --(4,2)->4 chiffre au total dont 2 en décimal
/
Create type L_Notes as Table of T_note;
/
Create type Unité As Object(
    NomU Varchar2(20),
    codeU Varchar2(5),
    crédits Number(2),
    contenu L_Séances,
    notesInscrits L_Notes
);
/

------------II définition des Tables

Create Table TAB_Etudiants of Etudiant nested Table contrat STORE As tab1;
/*1)chaque ligne=1 étudiant
2) une ref unique pour chaque ligne de la Table
(nested ...) uniquement si la liste est de type Table of */

Create Table TAB_Unités of Unité nested Table contenu STORE As tab
                                 nested Table notesInscrit STORE As tab2;


------------III Insertion de données

Insert into TAB_Unités Values(Unité('MLBDA','4I801', 6, L_Séances(Séance(1,'SQL',NULL),
                                                                  Séance(2,'SQL3',NULL),
                                                                  Séance(3,'XML',NULL)),NULL));
--NULL car on ne connait pas encore les présents

Insert into TAB_Unités Values(Unité('PLDAC','4I101', 6, L_Séances(Séance(1,'Intro', NULL),
                                                                  Séance(2,'Méthodologie', NULL)), NULL));

Insert into TAB_Etudiants Values(Etudiant(1234567,'Alice', 28, 4, 
    L_Unités((Select REF(u) From TAB_Unités u Where u.code='4I801'),
            (Select REF(u) From TAB_Unités u Where u.code='4I101'))));

update TAB_Unités set NoteInscrits=L_Notes(T_note(12,(Select REF(e) From TAB_Etudiants e Where e.nom='Alice')) Where nomU='MLBDA'

/* La liste des présents pour la séance 3 de MLBDA existe(pas NULL) -> Alice est presente à cette séance -> inserer une nouvelle entrée dans cette liste*/
insert into Table(Select s.present
                  From TAB_Unités u, Table(u.ontenu) s
                  Where s.numéro=3 and u.nomU='MLBDA') 
        Values((Select REF(e) From TAB_Etudiants Where e.nomE='Alice'));
                                                                
                             