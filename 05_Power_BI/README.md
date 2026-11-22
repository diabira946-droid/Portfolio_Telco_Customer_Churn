# 📊 05 – Power BI : Tableau de bord interactif

## 1. Présentation

Cette partie du projet est consacrée à la visualisation et à la restitution des résultats de l'analyse du churn client.

L'objectif est de transformer les données et les analyses précédentes en indicateurs visuels permettant de mieux comprendre les profils de clients exposés au risque de résiliation.

## 2. Objectifs du tableau de bord

- Suivre le taux global de churn.
- Mesurer le nombre de clients et le nombre de résiliations.
- Comparer les taux de churn selon les caractéristiques des clients.
- Identifier les segments les plus exposés.
- Faciliter l'exploration des résultats grâce aux filtres interactifs.
- Présenter des recommandations destinées à améliorer la fidélisation.

## 3. Indicateurs clés (KPI)

| Indicateur | Résultat |
|---|---:|
| Nombre de clients | 7 043 |
| Nombre de clients ayant résilié | 1 869 |
| Taux global de churn | 26,54 % |
| Churn des contrats mensuels | 42,71 % |
| Churn des clients avec 0 à 12 mois d'ancienneté | 47,44 % |

## 4. Organisation du tableau de bord

Le rapport Power BI est organisé en quatre pages :

**Page 1 – Vue générale et indicateurs**
- Cartes KPI.
- Répartition du churn.
- Analyse par type de contrat et ancienneté.

**Page 2 – Principaux facteurs associés au churn**
- Analyse du mode de paiement.
- Analyse du service Internet.
- Analyse du statut senior.
- Comparaison selon l'ancienneté.

**Page 3 – Profil des clients à risque**
- Croisement contrat et statut senior.
- Analyse paiement et contrat.
- Croisement ancienneté et contrat.
- Identification des segments prioritaires.

**Page 4 – Conclusion et recommandations**
- Synthèse des principaux résultats.
- Identification des profils les plus exposés.
- Propositions d'actions de fidélisation.

## 5. Mesures DAX et modélisation

Le tableau de bord utilise des mesures DAX pour calculer les principaux indicateurs :

- `Nombre_Clients` : nombre total de clients.
- `Nombre_Churn` : nombre de clients ayant résilié.
- `Taux_Churn` : proportion de clients ayant résilié.

Une table calendrier a également été créée pour faciliter l'organisation et l'analyse temporelle des données.

Les filtres et les croisements permettent d'explorer les différents segments de clientèle.

## 6. Principaux enseignements

L'analyse visuelle met notamment en évidence :

- Un taux de churn global de 26,54 %.
- Un taux de 42,71 % pour les contrats mensuels.
- Un taux de 47,44 % pour les clients ayant entre 0 et 12 mois d'ancienneté.
- Un taux de 45,29 % pour le paiement Electronic check.
- Un taux de 41,89 % pour le service Fiber optic.
- Un taux de 51,35 % pour le croisement contrats mensuels et ancienneté de 0 à 12 mois.

Ces résultats permettent de mieux cibler les actions de fidélisation.

## 7. Livrable

Le fichier Power BI du projet est disponible dans ce dossier :

`telco_customer_churn.pbix`

Il contient le rapport interactif composé de quatre pages.

## 8. Conclusion

Power BI permet de rendre les résultats de l'analyse accessibles à travers un tableau de bord interactif.

Cette étape complète le travail réalisé avec Excel, SQL, Python et le Machine Learning en facilitant l'interprétation des données et la prise de décision métier.
