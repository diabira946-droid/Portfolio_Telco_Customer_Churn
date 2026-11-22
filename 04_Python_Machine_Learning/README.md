# 🐍 04 – Python & Machine Learning

## 1. Présentation

Cette partie du projet est consacrée à l'analyse exploratoire des données et à la construction de modèles de Machine Learning afin d'étudier et de prédire le churn des clients.

Le travail a été réalisé avec Python, Pandas et Scikit-learn dans un environnement Jupyter Notebook.

## 2. Analyse exploratoire avec Python / Pandas

Les principales étapes réalisées :

- Importation et exploration du dataset.
- Vérification des valeurs manquantes.
- Recherche des doublons.
- Nettoyage et conversion des variables.
- Analyse statistique descriptive.
- Étude du taux global de churn.
- Analyse du churn selon les caractéristiques des clients.
- Création de visualisations et interprétation des résultats.

### Traitement des données manquantes

Les 11 valeurs vides de `TotalCharges` concernent des clients ayant une ancienneté (`tenure`) égale à zéro.

Ces valeurs ont été remplacées par 0, car elles correspondent à des clients n'ayant pas encore accumulé de facturation.

## 3. Principaux résultats de l'analyse

- Taux global de churn : 26,54 %.
- Contrats mensuels : 42,71 %.
- Clients ayant entre 0 et 12 mois d'ancienneté : 47,44 %.
- Paiement par Electronic check : 45,29 %.
- Clients utilisant la fibre optique : 41,89 %.

Ces résultats mettent en évidence plusieurs profils présentant une exposition plus importante au churn.

## 4. Machine Learning

Deux modèles de classification ont été développés avec Scikit-learn :

- Régression logistique.
- Random Forest Classifier.

### Préparation des données

- Encodage des variables catégorielles.
- Séparation des données en ensembles d'entraînement et de test.
- Répartition : 80 % entraînement et 20 % test.
- Utilisation de `stratify=y` pour conserver la proportion de la variable cible.

### Comparaison des modèles

| Métrique | Régression logistique | Random Forest |
|---|---:|---:|
| Accuracy | 79,28 % | 79,35 % |
| Precision | 63,31 % | 64,46 % |
| Recall | 52,14 % | 49,47 % |
| F1-score | 57,18 % | 55,98 % |

### Choix du modèle

La régression logistique est retenue comme modèle de référence.

Elle présente un Recall supérieur à celui du Random Forest, ce qui est particulièrement important pour identifier une plus grande proportion de clients ayant réellement résilié.

Les performances restent perfectibles.

## 5. Outils et bibliothèques

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Scikit-learn
- Jupyter Notebook

## 6. Livrable

Le notebook complet est disponible dans ce dossier :

`telco_customer_churn.ipynb`

Il contient les étapes d'exploration, de préparation des données, de modélisation et d'évaluation des performances.

## 7. Conclusion

Cette étape a permis de mettre en pratique les techniques d'analyse exploratoire et de Machine Learning pour mieux comprendre les caractéristiques associées au churn.

La comparaison des modèles montre l'importance du choix des métriques d'évaluation, notamment du Recall, en fonction de l'objectif métier.
