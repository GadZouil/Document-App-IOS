# Réponses

##	1- Exercice 1

### Les Targets
Les targets dans un projet Xcode représentent les objectifs spécifiques à construire, comme une application ou une extension. Chaque target définit un ensemble de fichiers, ressources, frameworks, et paramètres de compilation qui aboutissent à un produit final. Par exemple, la target principale d’un projet génère l’application iOS que vous souhaitez créer. Vous pouvez également ajouter d’autres targets pour des tests automatisés, des widgets ou des extensions comme une application watchOS. Les targets permettent de gérer plusieurs produits dans un même projet, chacun avec ses propres configurations et fonctionnalités.

### Les Fichiers de Base
Lors de la création d’un projet, Xcode fournit plusieurs fichiers par défaut, chacun ayant un rôle essentiel :

AppDelegate.swift : Gère le cycle de vie global de l’application, comme son lancement et sa fermeture.
SceneDelegate.swift : Supervise la gestion des différentes fenêtres (ou scènes) de l’application, utile pour iPad ou le multitâche.
ViewController.swift : Contient le code de l’écran principal de l’application et la logique associée.
Info.plist : Fichier de configuration où sont spécifiées des métadonnées de l’app, comme son nom, ses autorisations, ou sa version minimale d’iOS.
Main.storyboard : Permet de concevoir visuellement l’interface utilisateur et de relier les écrans entre eux.

### Le Dossier Assets.xcassets
Le dossier Assets.xcassets est l’endroit où sont stockées toutes les ressources visuelles de l’application. Vous pouvez y ajouter des images (comme les icônes ou illustrations), des couleurs personnalisées, ou encore les icônes de l’app (App Icon). Xcode simplifie la gestion de différentes résolutions (1x, 2x, 3x) en les regroupant sous un même nom. Ce dossier permet une organisation centralisée et garantit une adaptation automatique des ressources en fonction de l’appareil utilisé.

### Le Storyboard
Le storyboard, ouvert via le fichier Main.storyboard, est un outil graphique permettant de concevoir et visualiser les interfaces utilisateur de l’application. Vous y définissez les écrans (View Controllers), y ajoutez des composants (boutons, étiquettes, champs de texte) et configurez les transitions entre eux (appelées segues). Grâce au storyboard, vous concevez votre application sans écrire de code pour la disposition graphique, ce qui accélère le prototypage et la mise en œuvre des interfaces.

### Le Simulateur
Le simulateur est un outil intégré à Xcode qui reproduit le comportement d’un appareil iOS (iPhone, iPad, etc.) sur votre Mac. Il permet de tester votre application sans avoir besoin d’un appareil physique. Vous pouvez interagir avec l’app via des clics, saisir du texte et vérifier les fonctionnalités comme la navigation. Bien que limité pour certains tests matériels (caméra, GPS précis), le simulateur est indispensable pour un développement rapide et la vérification de l’apparence et des fonctionnalités de base avant de tester sur un appareil réel.

## 1- Exercice 2

### Cmd + R
Ce raccourci permet de lancer l'application. Xcode compile votre projet et exécute l'application sur le simulateur ou l'appareil connecté. S'il y a des erreurs, elles s'affichent dans la console ou la liste des erreurs. Ce raccourci est utilisé très fréquemment pour tester les modifications apportées au code.

### Cmd + Shift + O
Ce raccourci ouvre la fenêtre de recherche universelle dans Xcode. Vous pouvez y taper le nom d'un fichier, d'une classe, d'une méthode ou d'une variable pour y accéder directement. Cela permet de naviguer rapidement dans les grands projets.

### Raccourci pour indenter automatiquement le code
Pour indenter le code automatiquement, utilisez :
Ctrl + I
Ce raccourci réorganise le code sélectionné en respectant les conventions de mise en forme d’Xcode.

### Raccourci pour commenter la sélection
Pour commenter ou décommenter une sélection de code, utilisez :
Cmd + /
Cela ajoute ou enlève automatiquement des // au début des lignes sélectionnées, transformant les lignes en commentaire ou les réactivant.


## 2- Exercice 1

Une propriété statique appartient à la classe ou structure elle-même, et non à ses instances. Elle est utile pour partager des données globales, garantir l'unicité (comme un Singleton), ou stocker des valeurs constantes accessibles sans créer d'objet. Cela simplifie le code, économise la mémoire et permet un accès direct aux ressources ou configurations communes.










