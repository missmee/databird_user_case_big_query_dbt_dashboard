# Projet final pour la formation Analytics engineer de Databird

### Le projet

Modéliser les données d'un client fictif, une entreprise de vélos possédant trois magasins.


### Les objectifs

#### 1. Définir les axes d’analyse :  
- Identifier des axes d'analyse permettant d'aider l'équipe des opérations.
- Le but final est de leur permettre d’optimiser au mieux les ventes et de
maximiser le revenu de l'entreprise grâce aux insights obtenus.

#### 2. Modélisation des données :
- Importer les données brutes dans BigQuery.
- Structurer les données dans un projet DBT pour faciliter les analyses.

#### 3. Implémentation des tests et documentation :
- Ajouter des tests et une documentation complète, en particulier pour
les modèles qui seront connectés aux tableaux de bord.

#### 4. Visualisation et partage :
- Héberger le projet sur Github pour pouvoir permettre de faire une
Peer-Review.
- Créer une ou plusieurs visualisations dans l'outil de BI de votre choix
(Métabase, Power BI, Tableau) pour présenter les insights de manière
visuelle.

### Notes

Le dataset va du 2016-01-01 à 2018-12-28.
Mais les données sont parcellaires après le 2018-04-30. Il n'y a aucune données pour mai 
et une ou deux orders en status 3 pour les mois suivants. 
Soit l'entreprise court à sa perte, soit on pourrait imaginer un bug dans l'acquisition de données.
La deuxième hypothèse est plus plausible sinon solliciter la mise en place de dashboard pour l'usage
des données ne serait pas leur priorité.
Quoiqu'il en soit pour l'exercice j'ai donc limité aux données avant cette date.

La signification des chiffres pour order_status n'n'est pas défini. 
J'ai remarqué que date_shipped n'est renseignée qu'avec le satut 4, j'ai donc inventé les autres.

Après vérification, le dataset ne contient que les prix de vente, pas les prix de gros 
(le prix de la table products est le même que dans la table orders). 
Il n'est donc pas possible de calculer la marge.

Pour l'analyse, j'ai volontairement ecarté l'utilisation de la table staff. A la description de l'entreprise,
il ressort que le fait d'évaluer son personnel selon les ventes ne serait pas aligné avec sa philosophie.
En outre, le petit nombre de salariés et l'âge récent de l'entreprise ne rend pas ce kpi pertinent. Il existe
plusieurs autres points de données à étudier pour évaluer les ventes.
