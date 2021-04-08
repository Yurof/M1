


import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import pingouin as pg


if __name__=="__main__":
   # Load csv
   df = pd.read_csv("./logs/resultat3.csv")
   dfTrue = df.query("Success == True")

   # Display the data with seaborn
   sns.barplot(data=dfTrue, x="ParticipantID",y="Time", hue="Condition").set_title("Temps/Participant pour chaque propriété")
   plt.show()
   sns.lineplot(data=df, x="Grid",y="Time", hue="Condition").set_title("Temps/Taille pour chaque propriété")
   plt.show()
   sns.barplot(data=df, x="Grid",y="Time", hue="Condition").set_title("Temps/Taille pour chaque propriété")
   plt.show()
   sns.countplot(x="Success", data=df).set_title("Nombre de bonnes réponses")
   plt.show()
   
   # # ANOVA test
   # # the parameters are data=, dv=, wihtin=, subject=
   res = pg.rm_anova(dv='Time', within=['Condition', 'Grid'], subject='ParticipantID', data=df)
   print(res.to_string())

   # # Posthoc test (if necessary)
   # # the parameters are data=, dv=, wihtin=, subject=
   posthocs = pg.pairwise_ttests(dv='Time', within=['Condition', 'Grid'], subject='ParticipantID', data=df)
   pg.print_table(posthocs)




    

