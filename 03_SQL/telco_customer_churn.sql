/* =====================================================================
   PROJET FINAL — TELCO CUSTOMER CHURN
   Analyse SQL — version relue et structurée

   Base utilisée : telco_final
   Table analysée : telco_customer_churn_final

   Objet : contrôles de qualité, analyses descriptives du churn,
   croisements et interprétations métier.

   IMPORTANT : cette version est une revue statique du script reçu.
   Les requêtes doivent être exécutées dans MySQL Workbench pour confirmer
   les résultats sur la base effectivement présente dans l'environnement.
   Les chiffres mentionnés dans les commentaires sont les résultats consignés
   dans le fichier d'origine ; ils ne sont pas recalculés par cette revue.

   Traitement des valeurs manquantes : le script conserve les 11 lignes
   pour lesquelles tenure = 0 et TotalCharges IS NULL.
   ===================================================================== */

use telco_final;
/*** Contrôle de la qualité des données***/
SELECT
    COUNT(*) AS nombre_lignes,
    COUNT(DISTINCT customerID) AS clients_distincts
FROM telco_customer_churn_final;
/*** Vérification de la présence des 11 clients réintégrés ***/
SELECT
    customerID,
    tenure,
    TotalCharges
FROM telco_customer_churn_final
WHERE tenure = 0
  AND TotalCharges IS NULL;
/*** Vérification  du  résultat de la réintégration***/
SELECT
    COUNT(*) AS nombre_lignes,
    COUNT(DISTINCT customerID) AS clients_distincts,
    SUM(
        CASE
            WHEN tenure = 0 AND TotalCharges IS NULL
            THEN 1
            ELSE 0
        END
    ) AS clients_avec_totalcharges_manquant
FROM telco_customer_churn_final;
/***
   INTERPRETATION DES RESULTATS

   La vérification confirme que la table finale contient
   7 043 lignes correspondant à 7 043 clients distincts.

   Les 11 clients ayant une ancienneté de zéro mois
   (tenure = 0) et une valeur manquante dans TotalCharges
   sont bien présents dans la table.

   Ces valeurs manquantes sont conservées afin de
   respecter les données d'origine. Elles ne sont pas
   remplacées arbitrairement par zéro.

   La table est prête pour les analyses du churn.***/

/*** vérifier les valeurs manquantes***/
SELECT
    SUM(customerID IS NULL) AS customerID_null,
    SUM(gender IS NULL) AS gender_null,
    SUM(tenure IS NULL) AS tenure_null,
    SUM(MonthlyCharges IS NULL) AS MonthlyCharges_null,
    SUM(TotalCharges IS NULL) AS TotalCharges_null,
    SUM(Contract IS NULL) AS Contract_null,
    SUM(Churn IS NULL) AS Churn_null
FROM telco_customer_churn_final;
/*** Interpretation
La vérification des valeurs manquantes montre que les colonnes contrôlées sont complètes, 
à l'exception de TotalCharges, qui comporte 11 valeurs manquantes. Ces 11 cas correspondent aux clients dont tenure = 0. 
Nous conservons ces clients afin de ne pas perdre d'observations.***/

/*** vérifier la répartition du churn***/
SELECT
    Churn,
    COUNT(*) AS nombre_clients
FROM telco_customer_churn_final
GROUP BY Churn;
/*** Interpretation
Le jeu de données compte 7 043 clients, dont 1 869 ont résilié leur abonnement, soit un taux de résiliation de 26,54 %. 
Cet indicateur constitue le point de départ de l'analyse : nous chercherons ensuite à comprendre quelles caractéristiques sont associées au départ des clients.***/

/*** Vérification des doublons***/
SELECT
    customerID,
    COUNT(*) AS nombre_occurrences
FROM telco_customer_churn_final
GROUP BY customerID
HAVING COUNT(*) > 1;
/*** Interprétation : aucun doublon de customerID n'a été détecté dans notre table telco_customer_churn_final. Chaque client est donc identifié de manière unique.***/

/*** Analyser le churn selon le type de contrat***/
SELECT
    Contract,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
GROUP BY Contract
ORDER BY taux_churn DESC;
/*** L'analyse du taux de résiliation selon le type de contrat révèle une différence importante entre les clients. 
 taux de churn atteint 42,71 % pour les contrats mensuels, contre 11,27 % pour les contrats d'un an et seulement 2,83 % pour les contrats de deux ans.

Ces résultats montrent que les clients disposant d'un contrat mensuel sont les plus exposés au risque de résiliation. 
L'entreprise pourrait donc renforcer les actions de fidélisation auprès de ces clients et proposer des avantages incitant à souscrire des contrats de plus longue durée.***/

/*** Analyser le churn selon l'ancienneté des clients***/
SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 mois'
        WHEN tenure <= 24 THEN '13-24 mois'
        WHEN tenure <= 48 THEN '25-48 mois'
        ELSE '49 mois et plus'
    END AS tranche_anciennete,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
GROUP BY tranche_anciennete
ORDER BY MIN(tenure);
/*** L'analyse du churn selon l'ancienneté révèle que les clients les plus récents sont les plus exposés au risque de résiliation. 
Le taux de churn atteint 47,44 % durant les 12 premiers mois, puis diminue progressivement pour atteindre 9,51 % chez les clients ayant au moins 49 mois d'ancienneté.

Ces résultats soulignent l'importance de la fidélisation dès les premiers mois de la relation client. 
L'entreprise pourrait mettre en place un programme d'accompagnement des nouveaux abonnés, 
assurer un suivi régulier de leur satisfaction et identifier rapidement les premiers signes d'insatisfaction.***/

/*** Analyser le churn selon le moyen de paiement***/
SELECT
    PaymentMethod,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
GROUP BY PaymentMethod
ORDER BY taux_churn DESC;
/*** L'analyse du churn selon le moyen de paiement révèle que les clients utilisant le chèque électronique présentent le taux de résiliation le plus élevé, 
à 45,29 %. À l'inverse, les clients utilisant le paiement automatique par carte bancaire affichent le taux le plus faible, à 15,24 %.

Ces résultats suggèrent qu'il serait pertinent d'étudier plus précisément le profil des clients utilisant le chèque électronique afin de comprendre 
les facteurs associés à leur départ. L'entreprise pourrait également évaluer l'intérêt de promouvoir les moyens de paiement automatiques, 
sans supposer que le moyen de paiement est, à lui seul, la cause des résiliations.***/

/*** Analyser le churn selon le service Internet***/
SELECT
    InternetService,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
GROUP BY InternetService
ORDER BY taux_churn DESC;
/*** L'analyse du churn selon le service Internet montre que les clients utilisant la fibre optique présentent le taux de résiliation le plus élevé, 
avec 41,89 %, contre 18,96 % pour le DSL et 7,40 % pour les clients ne disposant pas de service Internet.

Cet écart justifie une analyse approfondie du profil des clients utilisant la fibre optique, notamment en matière de tarification, 
de qualité de service et de satisfaction. 
L'entreprise pourrait ainsi identifier les facteurs associés aux résiliations et mettre en place des actions de fidélisation ciblées.***/

/*** Croiser le contrat mensuel et l'ancienneté***/
SELECT
    Contract,
    CASE
        WHEN tenure <= 12 THEN '0-12 mois'
        ELSE 'Plus de 12 mois'
    END AS tranche_anciennete,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
GROUP BY
    Contract,
    tranche_anciennete
ORDER BY
    Contract,
    MIN(tenure);
/*** L'analyse croisée du type de contrat et de l'ancienneté met en évidence un risque de résiliation particulièrement élevé chez les clients disposant d'un contrat mensuel. 
Le taux de churn atteint 51,35 % durant les 12 premiers mois et reste élevé à 33,55 % au-delà de cette période.

À l'inverse, les contrats de deux ans présentent les taux de résiliation les plus faibles : 
0 % chez les clients ayant entre 0 et 12 mois d'ancienneté et 2,95 % chez ceux ayant plus de 12 mois.***/

/*** Analyser le churn selon la sécurité en ligne***/
SELECT
    OnlineSecurity,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
GROUP BY OnlineSecurity
ORDER BY taux_churn DESC;
/*** L'analyse du churn selon la disponibilité du service de sécurité en ligne révèle un taux de résiliation de 41,77 % chez les clients ne disposant pas de ce service, 
contre 14,61 % chez ceux qui en bénéficient. Les clients sans service Internet affichent quant à eux un taux de 7,40 %.

Ces résultats mettent en évidence une association entre la disponibilité du service de sécurité en ligne et le churn. 
Il serait pertinent d'étudier plus précisément les besoins et les caractéristiques des clients ne disposant pas de cette protection afin de déterminer 
les actions de fidélisation les plus adaptées.***/

/***Analyser le churn selon l'assistance technique***/
SELECT
    TechSupport,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
GROUP BY TechSupport
ORDER BY taux_churn DESC;
/*** L'analyse du churn selon la disponibilité de l'assistance technique révèle un taux de résiliation de 41,64 % chez les clients ne disposant pas de ce service, 
contre 15,17 % chez ceux qui en bénéficient. Les clients sans service Internet présentent un taux de 7,40 %.

Ces résultats mettent en évidence une association entre la disponibilité de l'assistance technique et le churn. 
Il serait pertinent d'étudier les difficultés rencontrées par les clients ne disposant pas de ce service et d'évaluer des actions de fidélisation adaptées.***/

/*** Analyser le churn selon les frais mensuels***/
SELECT
    CASE
        WHEN MonthlyCharges < 35 THEN 'Moins de 35'
        WHEN MonthlyCharges < 70 THEN '35 à moins de 70'
        ELSE '70 et plus'
    END AS tranche_frais_mensuels,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
GROUP BY tranche_frais_mensuels
ORDER BY MIN(MonthlyCharges);
/*** L'analyse du churn selon les frais mensuels révèle une augmentation du taux de résiliation avec le montant de l'abonnement. 
Le taux de churn atteint 10,86 % pour les clients payant moins de 35 par mois, 23,65 % pour ceux payant entre 35 et moins de 70, et 35,48 % pour ceux payant 70 ou plus.

Ces résultats suggèrent que les clients ayant les frais mensuels les plus élevés constituent un groupe à examiner en priorité. 
L'entreprise pourrait étudier leur niveau de satisfaction, les services souscrits et la compétitivité de ses tarifs afin d'identifier les facteurs associés aux résiliations.***/

/*** Analyser le churn selon les frais totaux ***/
SELECT
    CASE
        WHEN TotalCharges < 1000 THEN 'Moins de 1000'
        WHEN TotalCharges < 3000 THEN '1000 à moins de 3000'
        ELSE '3000 et plus'
    END AS tranche_frais_totaux,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
WHERE TotalCharges IS NOT NULL
GROUP BY tranche_frais_totaux
ORDER BY MIN(TotalCharges);
/*** L'analyse du churn selon les frais totaux révèle une diminution du taux de résiliation lorsque le montant cumulé augmente. 
Le taux atteint 36,99 % chez les clients ayant moins de 1 000 de frais totaux, contre 23,20 % pour ceux situés entre 1 000 et moins de 3 000, 
et 15,88 % pour ceux ayant au moins 3 000 de frais totaux.

Cette tendance doit être interprétée en tenant compte de l'ancienneté et du montant de l'abonnement, 
qui influencent les frais cumulés. Il serait pertinent de croiser ces variables afin de mieux distinguer l'effet de l'ancienneté de celui du montant payé.***/

/*** analyser le churn selon le genre***/
SELECT
    gender,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
GROUP BY gender
ORDER BY taux_churn DESC;
/*** ANALYSE DU CHURN SELON LE GENRE Le taux de churn atteint 26,92 % chez les femmes et 26,16 % chez les hommes. 
L'écart est faible : 0,76 point de pourcentage. Les taux de résiliation étant très proches, 
le genre ne semble pas être un facteur fortement discriminant dans cette analyse descriptive. 
Les actions de fidélisation devront notamment tenir compte des facteurs présentant des écarts plus marqués, comme le type de contrat et l'ancienneté.***/

/*** Vérifier le churn selon les options de sauvegarde en ligne***/
SELECT
    OnlineBackup,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
GROUP BY OnlineBackup
ORDER BY taux_churn DESC;
/*** INTERPRÉTATION :
 Les clients ne disposant pas de la sauvegarde en ligne présentent un taux de churn de 39,93 %,
 contre 21,53 % pour ceux qui disposent de ce service.
 Cette différence suggère que la présence de services complémentaires peut être associée
 à une meilleure fidélisation. Il s'agit d'une association statistique et non d'une preuve
 de causalité. Les clients sans service Internet présentent un taux de churn de 7,40 %.***/
 
 /*** churn selon DeviceProtection***/
SELECT
    DeviceProtection,
    COUNT(*) AS nombre_clients,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS taux_churn
FROM telco_customer_churn_final
GROUP BY DeviceProtection
ORDER BY taux_churn DESC;
/***
INTERPRÉTATION :
 Les clients ne disposant pas de la protection des appareils présentent un taux de churn
 de 39,13 %, contre 22,50 % pour ceux qui en disposent.
 Cet écart suggère une association entre la souscription à ce service et une meilleure
 fidélisation. Cette relation ne permet toutefois pas d'établir un lien de causalité.
 Les clients sans service Internet présentent un taux de churn de 7,40 %.***/
 
 
 /*** CONCLUSION GÉNÉRALE DE L'ANALYSE SQL ***/

/*
L'analyse SQL du jeu de données de télécommunications a permis d'étudier
les facteurs associés à la résiliation des abonnements.

Les résultats montrent que les clients disposant d'un contrat mensuel
présentent un taux de churn élevé de 42,71 %. Le risque est également
important chez les clients ayant une ancienneté de 12 mois ou moins,
avec un taux de 47,44 %.

D'autres associations ont été observées selon le moyen de paiement,
le service Internet, les frais mensuels et les services complémentaires.
Par exemple, les clients utilisant la fibre optique présentent un taux
de churn de 41,89 %, tandis que ceux dont les frais mensuels atteignent
70 ou plus présentent un taux de 35,48 %.

À l'inverse, les contrats de longue durée sont associés à des taux de
résiliation plus faibles. Les résultats suggèrent donc de renforcer
l'accompagnement des nouveaux clients, d'étudier les motifs d'insatisfaction
des clients les plus exposés et d'adapter les actions de fidélisation.

Cette analyse reste descriptive : les associations observées ne prouvent
pas à elles seules une relation de causalité. Les résultats pourront être
approfondis avec Python, le Machine Learning et Power BI.
***/

/* =====================================================================
   REQUÊTE DE SYNTHÈSE — KPI GLOBALS
   À exécuter pour confirmer le périmètre final et le taux global de churn.
   Les résultats doivent être comparés aux sorties des autres outils.
   ===================================================================== */
SELECT
    COUNT(*) AS nombre_lignes,
    COUNT(DISTINCT customerID) AS clients_distincts,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS clients_resilies,
    SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS clients_restes,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0),
        2
    ) AS taux_churn_pct,
    SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS totalcharges_manquants
FROM telco_customer_churn_final;
