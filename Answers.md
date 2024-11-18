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

## 2- Exercice 2

dequeueReusableCell améliore les performances en réutilisant les cellules déjà créées, plutôt que d'en générer de nouvelles à chaque fois. Cela réduit la consommation de mémoire, accélère le traitement, et assure une fluidité optimale, même pour de longues listes, en ne gardant en mémoire que les cellules visibles à l'écran et un petit buffer.


## 4- Exercice 1

### Ce que nous venons de faire et le rôle du NavigationController
En ajoutant un NavigationController, nous avons structuré notre application pour gérer la navigation entre plusieurs écrans (ou pages). Le NavigationController agit comme un conteneur qui organise et présente les ViewControllers dans une hiérarchie (appelée pile de navigation). Chaque écran est poussé ou retiré de cette pile lorsque l'utilisateur navigue dans l'application, ce qui permet une navigation fluide et cohérente. Cela inclut la gestion automatique de la NavigationBar, des transitions entre les écrans, et parfois d'une barre d'outils.

### Différence entre la NavigationBar et le NavigationController
La NavigationBar est une partie visible (la barre en haut de l'écran) fournie par le NavigationController. Elle affiche le titre de l'écran courant et peut contenir des boutons (comme "Retour", "Ajouter", ou "Modifier"). En revanche, le NavigationController est une structure plus large, qui englobe la logique de navigation elle-même, y compris la gestion de la pile de ViewControllers et des animations de transition.


## 6- Exercice 1

### Qu’est-ce qu’un Segue et à quoi il sert ?
Un Segue est un mécanisme utilisé dans les Storyboards d'iOS pour gérer la transition visuelle et logique entre deux écrans, appelés ViewControllers. Il permet non seulement de passer d'un écran à l'autre en réponse à une interaction utilisateur, mais aussi de transmettre des données entre les ViewControllers à l'aide de la méthode prepare(for segue:sender:). Les Segues offrent une manière visuelle et intuitive de concevoir les transitions et les flux de navigation dans une application.

## 6- Exercice 2

### Qu’est-ce qu’une constraint ? À quoi sert-elle ? Quel est le lien avec AutoLayout ?
Une constraint est une règle qui détermine la position, la taille ou la relation d’un élément d’interface utilisateur par rapport à d’autres éléments ou à son conteneur. Elle sert à organiser l’affichage de manière précise et à garantir une mise en page cohérente, quel que soit l’appareil ou l’orientation. Les constraints sont utilisées par AutoLayout, le système d’iOS qui calcule automatiquement les positions et dimensions des composants pour rendre l’interface responsive et adaptée à différentes tailles d’écran.


## 9- Questions

### Pourquoi changer l’accessory en disclosureIndicator ?
Le disclosureIndicator est un petit chevron affiché à droite des cellules, indiquant à l’utilisateur qu’en sélectionnant une cellule, il accédera à une vue de détail. Cela améliore l’expérience utilisateur en respectant les directives d'Apple en matière de design (Human Interface Guidelines). Il est particulièrement pertinent pour des actions de navigation, comme ici où l’on ouvre un document. Cela rend l'interface plus intuitive et cohérente avec les standards d’iOS.


## 10- Questions

### Qu’est-ce qu’un #selector ?
Un #selector est une référence utilisée pour indiquer qu’une méthode doit être appelée en réponse à un événement. Il connecte des actions aux composants UI comme des boutons ou des gestes.

### Que représente .add dans notre appel ?
.add est une option prédéfinie de type UIBarButtonItem.SystemItem. Elle affiche un symbole "+" qui est intuitif pour les utilisateurs lorsqu’il s’agit d’ajouter du contenu.

### Pourquoi Xcode demande d’utiliser @objc ?
Le mot-clé @objc est requis car les sélecteurs utilisent des mécanismes hérités d’Objective-C. Il indique que la méthode ciblée peut être appelée par le runtime Objective-C, nécessaire pour les actions associées à des sélecteurs.

### Peut-on ajouter plusieurs boutons dans la barre de navigation ?
Oui, on peut ajouter plusieurs boutons. Il suffit de fournir un tableau de UIBarButtonItem :
navigationItem.rightBarButtonItems = [
    UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument)),
    UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
]

### À quoi sert la fonction defer ?
defer est utilisé pour exécuter du code juste avant de quitter le scope courant, qu’il s’agisse d’un succès ou d’une erreur. C’est utile pour effectuer des opérations de nettoyage, comme fermer un fichier ou libérer une ressource.








