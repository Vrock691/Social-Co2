import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_co2/screens/dialogs/dialogChangeDisplayName.dart';
import 'package:social_co2/screens/dialogs/dialogChangePassword.dart';
import 'package:social_co2/styles/CardStyles.dart';
import 'package:social_co2/styles/MainScreenStyle.dart';
import 'package:social_co2/utils/responsiveHandler.dart';

import '../dialogs/dialogDeleteAccount.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  final Widget userphoto = (FirebaseAuth.instance.currentUser!.photoURL != null)
      ? Container(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircleAvatar(
              radius: 360,
              backgroundImage: NetworkImage(
                  '${FirebaseAuth.instance.currentUser!.photoURL}'),
            ),
          ),
        )
      : const Icon(
          Icons.account_circle_outlined,
          size: 100,
        );

  @override
  Widget build(BuildContext context) {
    // Variables necessaires au responsive
    int drawerWidth = getDrawerWidth(context);

    String? displayName = FirebaseAuth.instance.currentUser!.displayName;

    return Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width -
            drawerWidth, // On défini la largeur du conteneur pour qu'il prenne tout l'espace à droite du drawer sur le web
        decoration: homeScreenBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: primaryCard,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    userphoto,
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (displayName == null) ? "<...>" : displayName,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                            onPressed: () {
                              showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) =>
                                          const dialogChangeDisplayName())
                                  .then((value) {
                                setState(() {
                                  displayName = FirebaseAuth
                                      .instance.currentUser!.displayName;
                                });
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Changer de nom public")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
                decoration: primaryCard,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ListTile(
                  tileColor: secondaryCardColor,
                  leading: const Icon(Icons.logout),
                  title: const Text("Se déconnecter"),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              icon: const Icon(Icons.logout),
                              title: const Text("Déconnexion"),
                              content: const Text(
                                  "Souhaitez-vous vous déconnecter ?"),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Annuler')),
                                TextButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Déconnexion"),
                                ),
                              ],
                            ));
                  },
                )),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: primaryCard,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.password),
                    title: const Text("Changer de mot de passe"),
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => const dialogChangePassword());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text("Supprimer mon compte"),
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => const dialogDeleteAccount());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text("Contacter le support"),
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
