# Version 2.4.1 (en développement)
* Corrections d'anomalies
  * L'export GTFS exige que l'indice de ligne soit renseigné (Mantis 26726)
  * L'import GTFS ne tient pas compte des courses commençant après minuit (Mantis 25824)
  * Mise en place d'un script produisant l'aide en ligne sous forme de docx (Mantis 26604)
  * L'import GTFS plante sur une course qui dessert plus de 2 fois le même arrêt (Mantis 26755)
  * L'export NeTEx produit un fichier invalide si le champ VersionDate du réseau est vide (Mantis 26434)
  * Liens cassés dans les pages d'aide (Mantis 26690)

# Version 2.4.0 (27/05/14)
* Corrections d'anomalies
  * L'Import GTFS n'importe pas les fichiers avec marqueurs BOM (Mantis 21260)
  * L'Import GTFS n'accepte pas des routes sans colonne agencyId (Mantis 22665)
  * L'Export GTFS sort en erreur sur objet à exporter incomplêt (Mantis 24484)
  * L'Export CSV sort un message inexploitable sur informations incomplètes (Mantis 24485)
  * L'import NeTEx n'importe pas les ITL (Mantis 20889)
  * L'ajout de nouvelles dates et périodes d'un calendrier ne propose pas l'assitant de saisie de date (Mantis 24440)
  * Le format de date n'est pas correct en saisie (Mantis 23913)
  * La modification de dates ou de périodes n'actualise pas les limites du calendrier (Mantis 23801)
  * Mieux expliquer les espaces de données dans l'aide (Mantis 22286 et 22811)
  * Créer un calendrier avec des dates ou périodes vides, crée un calendrier vide (Mantis 24425)
  * Remplacer détruire par supprimer dans les confirmation de suppression (Mantis 24414)
  * Protection des listes avec filtre si la page courante est au delà du nombre de pages (Mantis 20954)
  * L'export n'accepte plus une liste de réseaux (Mantis 26438)
  * L'insertion d'un arrêt dans une séquence perturbe les courses existantes (Mantis 23800)
  * Import Neptune : erreur de sauvegarde si le mode de transport est manquant (Mantis 26702)
  * Edition Calendrier : problème de saisie des dates sous Chrome (Mantis 26746)

# Version 2.3.0 (18/04/14)
* Migration technique de chouette (Java)
  * passage sous spring 4
  * passage sous hibernate 4
  * utilisation des annotations JPA

# Version 2.2.0 (06/03/14)
* Refonte des fonctions d'import et validation
  * suppression de la validation de fichiers
  * mise en place de la validation durant l'import
  * ajout de la validation sur les objets en base
  * redéfinition des tests
  * refonte des IHM de résultat

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
