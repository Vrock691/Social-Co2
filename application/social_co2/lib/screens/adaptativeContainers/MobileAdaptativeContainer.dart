import 'package:flutter/material.dart';

class MobileAdaptativeContainer extends StatefulWidget {
  const MobileAdaptativeContainer({super.key});

  @override
  State<MobileAdaptativeContainer> createState() =>
      _MobileAdaptativeContainerState();
}

class _MobileAdaptativeContainerState
    extends State<MobileAdaptativeContainer> {
  int selectedIndex =
      0; // Index de l'onglet actuellement selectionné dans la BottomNavigationBar

  @override
  Widget build(BuildContext context) {
    // TODO : À commenter
    return Scaffold(
        body: const Text("Mobile Natif"),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Accueil"),
            BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard_outlined), label: "Classement"),
            BottomNavigationBarItem(
                icon: Icon(Icons.energy_savings_leaf), label: "Activités"),
            BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined), label: "Messages"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: "Profil")
          ],
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ));
  }
}
