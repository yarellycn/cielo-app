# Cielo

Cielo est une application Flutter Web qui affiche l'historique météo ainsi que les prévisions à venir en utilisant les API [Open-Meteo](https://open-meteo.com/).

L'application a pour objectif de rendre les informations météo demandées faciles à consulter sur une période sélectionnée : température, température ressentie, humidité, vent, précipitations et couverture nuageuse.

## Fonctionnalités

- Résumé de la météo actuelle pour la ville sélectionnée.
- Cartes météo journalières pour les dates passées, actuelles et à venir.
- Filtres rapides: 3 derniers jours, aujourd'hui, 3 prochains jours, 7 prochains jours et l'ensemble de la période chargée.
- Sélection d'un intervalle personnalisé avec un calendrier.
- Récupération des données historiques et prévisionnelles via Open-Meteo.
- Localisation par défaut sur Montpellier lorsqu'aucune ville n'est sélectionnée.
- Aucune clé API requise.

## Bonus

Le projet inclut une barre de recherche de ville connectée à l'API de géocodage Open-Meteo.

L'utilisateur peut saisir le nom d'une ville, sélectionner l'un des résultats suggérés, puis l'application recharge les données météo pour les coordonnées sélectionnées.

L'application est également presque entièrement responsive. La principale exception restante est la barre de sélection de dates/d'intervalle, qui nécessite encore des améliorations de mise en page sur les écrans étroits.

## Stack technique

- Flutter Web
- Dart
- API Open-Meteo Forecast
- API Open-Meteo Historical Weather
- API Open-Meteo Geocoding
- `http` pour les appels API
- `intl` pour le formatage des dates
- `syncfusion_flutter_datepicker` pour la sélection d'un intervalle personnalisé
- `google_fonts` pour la typographie
- `fl_chart` est déjà déclaré et prévu pour la prochaine fonctionnalité de graphique

## Installation

Assurez-vous que Flutter est installé et disponible dans votre terminal.

Ce projet nécessite un SDK Dart compatible avec la version `3.11.5`, comme indiqué dans `pubspec.yaml`.

Vérifiez vos versions locales:

```bash
dart --version
flutter --version
```

Si votre version de Flutter ou Dart est trop ancienne, mettez Flutter à jour:

```bash
flutter upgrade
```

Installez ensuite les dépendances du projet:

```bash
flutter pub get
```

## Lancer l'application

Lancez l'application Flutter Web dans Chrome:

```bash
flutter run -d chrome
```

Vous pouvez également la lancer depuis Visual Studio Code en sélectionnant une cible Chrome/Web puis en utilisant la commande Run.

## Utilisation

1. Ouvrez l'application dans le navigateur.
2. Utilisez la barre de recherche dans l'en-tête pour sélectionner une ville. Si aucune ville n'est sélectionnée, Montpellier est utilisée par défaut.
3. Choisissez l'un des intervalles prédéfinis ou ouvrez le sélecteur d'intervalle personnalisé.
4. Consultez la carte de météo actuelle et les cartes météo journalières pour la période sélectionnée.

Chaque carte journalière affiche:

- Température minimale et maximale
- Température ressentie minimale et maximale
- Humidité relative moyenne
- Vitesse maximale du vent
- Total des précipitations
- Couverture nuageuse moyenne
- Description météo basée sur le code météo

## Structure du projet

- `lib/main.dart`: point d'entrée de l'application et état principal de l'écran.
- `lib/open_meteo_api.dart`: appels aux API forecast et archive d'Open-Meteo.
- `lib/geocoding_api.dart`: recherche de ville via le géocodage Open-Meteo.
- `lib/models/`: modèles typés pour les données météo et les villes.
- `lib/widgets/`: composants d'interface pour l'app bar, la barre de recherche, le sélecteur d'intervalle, la météo actuelle et les prévisions journalières.
- `lib/theme/`: couleurs et styles de boutons partagés.
- `assets/`: icône et logo de l'application.

## Problèmes connus

- `ForecastRangeSelector` n'est pas encore entièrement responsive et ne passe pas sur deux lignes lorsque l'espace horizontal est trop limité.
- Le texte de l'interface est encore écrit en dur en français. La localisation n'est pas encore implémentée.
- Il n'y a pas encore de page d'erreur dédiée en cas d'échec de l'API. Les erreurs sont actuellement affichées directement dans l'interface.

## Améliorations prévues

- Corriger les problèmes connus de mise en page responsive et de gestion d'erreurs.
- Ajouter la prise en charge de la localisation au lieu des textes français écrits en dur.
- Ajouter la navigation au clavier dans les suggestions de la recherche de ville.
- Ajouter un bouton `X` pour vider le champ de recherche de ville.
- Utiliser la position actuelle de l'utilisateur comme localisation par défaut au lieu de Montpellier.
- Ajouter un petit tag `Passé` sur les cartes météo qui affichent des données historiques.
- Utiliser `fl_chart` et les données horaires déjà récupérées depuis l'API pour afficher des graphiques des différentes métriques météo par heure.
- Ajouter des tests pour le parsing des réponses API et l'intégration avec l'API Open-Meteo.

## Note de développement

C'est mon premier projet Flutter. Comme j'avais également des projets scolaires en parallèle, je n'ai pas pu faire tout ce que je voulais avant la date de rendu.

Pour le rendu dans le cadre du test technique, la branche `main` restera inchangée. Je continuerai cependant à améliorer le projet sur la branche `dev` si vous souhaitez voir les prochaines itérations séparément.
