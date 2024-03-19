import 'package:flutter/material.dart';
import 'package:social_co2/collections/MoreInformationsData.dart';
import 'package:social_co2/main.dart';
import 'package:social_co2/utils/enumDataParser.dart';
import 'package:social_co2/utils/requestsService.dart';

class UserSCO2DataProvider extends ChangeNotifier {
  // Données sur le score
  int CurrentUserScore = 0;
  int CurrentUserScoreScale = 0;

  // Données liées au multiplicateur
  double homeSurface = 150; // Surface du domicile
  HeatingModes heatMode = HeatingModes.electrique; // Type de chauffage
  int heatersCount = 3; // Nombre de chauffage
  int buildingDate = 1875; // Date de construction/rénovation du batiment
  bool garden = true; // Possède un jardin ou non
  bool recycling = true; // Recycle ou non
  CarSizes carSize = CarSizes.mid; // Taille de la voiture
  bool isCarHybrid = false; // Motorisation hybride ou non de la voiture

  // Données du statut du provider sur les requettes
  bool isLoading = false;
  String error = "";

  // Cette fonction calcule le classement du score sur une echelle de 1 à 5 pour le widget de l'écran d'accueil
  int calcUserScoreScale() {
    var scale = 0;
    if (CurrentUserScore >= 0 && CurrentUserScore < 2000) {
      scale = 5;
    } else if (CurrentUserScore >= 2000 && CurrentUserScore < 4000) {
      scale = 4;
    } else if (CurrentUserScore >= 4000 && CurrentUserScore < 6000) {
      scale = 3;
    } else if (CurrentUserScore >= 6000 && CurrentUserScore < 8000) {
      scale = 2;
    } else if (CurrentUserScore >= 8000) {
      scale = 1;
    }
    return scale;
  }

  Future<int> getUserSCO2Data() async {
    isLoading = true;
    notifyListeners();

    // On récupère le token de connexion
    final authToken = await firebaseAuth.currentUser!.getIdToken();
    final userID = await firebaseAuth.currentUser!.uid;

    // On fait la requette au server
    final data = await requestService().get("user/", {
      "authorization": '$authToken',
      'userid': '$userID',
    });

    // On analyse la réponse du server
    // En cas d'erreur, on renvoie erreur aux widgets
    if (data["error"] == true) {
      try {
        error = 'error: ${data["error_message"].toString()}';
      } catch (e) {
        error = "error: unknown error";
      }
      CurrentUserScoreScale = 0;
      isLoading = false;

      notifyListeners();
      return CurrentUserScore;
    }

    // Si pas d'erreur on met à jour le score pour toute l'appli et on met à jour le provider
    CurrentUserScore = int.parse(data["score"]);
    CurrentUserScoreScale = calcUserScoreScale();

    // On met à jour les variables liés au multiplicateur
    homeSurface = data['surface']; // Surface du domicile
    heatMode =
        getHeatingModeFromString(data['heatingMode']); // Type de chauffage
    heatersCount = data['heatingCount']; // Nombre de chauffage
    buildingDate =
        data['surface']; // Date de construction/rénovation du batiment
    garden = data['potager']; // Possède un jardin ou non
    recycling = data['recycl']; // Recycle ou non
    carSize = getCarSizeFromString(data['carSize']); // Taille de la voiture
    isCarHybrid = data['hybride'];

    // On met à jour les données d'état du provider
    error = "";
    isLoading = false;

    notifyListeners();
    return CurrentUserScore;
  }
}
