# Version 2.4.0 (en développement)
* Corrections d'annomalies
  * L'Import GTFS importe les fichiers avec marqueurs BOM (Mantis 21260)
  * L'Import GTFS accepte des routes sans colonne agencyId (Mantis 22665)
  * L'Export GTFS sort en erreur sur objet à exporter incomplêt (Mantis 24484)
  * L'Export CSV sort un message inexploitable sur informations incomplètes (Mantis 24485)
  * L'import NeTEx n'importe pas les ITL (Mantis 20889)
  * L'ajout de nouvelles dates et périodes d'un calendrier ne propose pas l'assitant de saisie de date (Mantis 24440)
  * Le format de date n'est pas correct en saisie (Mantis 23913)
  * La modification de dates ou de périodes n'actualise pas les limites du calendrier (Mantis 23801)
  * Mieux expliquer les espaces de données dans l'aide (Mantis 22286 et 22811)
  
# Version 2.3.0 (06/03/14, en cours de qualification)
* Migration technique de chouette (Java)

# Version 2.2.0 (06/03/14)
* Refonte des fonctions d'import et validation

# Version 2.1.1 (20/12/13)
* Ajout de Google Analytics
* Clonage de courses
  * les calendiers de la course initiale sont reportés dans les copies

# Version 2.1.0 (15/07/13)
* suppression des coordonnées projetées en base
  * les données sont produites à la volée pour l'export et l'affichage à partir de la projection fixée dans le référentiel
* consolidation de l'import GTFS
* ajout d'un export KML :
  * lignes
  * séquences d'arrêt
  * arrêts (une chouche par type)
  * missions
  * correspondances
  * accès et liaisons accès-arrêt
* Intégration des cartes du géoportail (IGN)
  * ajout des fonds niveau cadastre et orthophoto
  * affichage de l'orthophoto IGN par défaut lorsque la clé IGN est présente

# Version 2.0.3 (27/05/13)
* Ajout des imports/export NeTex
* Fonctionnement sous windows
* Prise en compte de grandes quantités de calendriers.
* Reprise des logs d'import Neptune
* Intégration des cartes du géoportail (IGN)

# Version 2.0.2 (28/01/13)
* Ajout de l'import GTFS (expérimental, ne traite pas les stations)
* Ajout d'API Rest pour accéder aux données depuis une autre application

# Version 2.0.1 (17/12/12)
* Ajout de la gestion des groupes de lignes
* Ajout de la gestion des accès et des relations arrêts-accès
* Ajout d'une vue calendaire des calendriers d'application
* Améliorations ergonomiques et cartographiques
* L'import Neptune accepte les principaux formats d'encodage : ISO-8859-1, UTF-8, ...

# Version 2.0.0 (10/09/12)
* refonte de l'interface graphique
* ajout d'une gestion simplifiée d'utilisateurs :
  * ajout d'une notion d'organisation
  * ajout d'une notion d'espace de données
