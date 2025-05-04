import 'package:flutter/material.dart';
import 'package:plantguardian/features/add_plant/presentation/pages/add_plant_page.dart';
import 'package:plantguardian/features/auth/presentation/pages/login_page.dart';
import 'package:plantguardian/features/plant_overview/presentation/widgets/plant_add_card.dart';
import 'package:plantguardian/features/plant_overview/presentation/widgets/plant_card.dart';
import 'package:plantguardian/features/shared/models/plant_model.dart';
import 'package:plantguardian/features/plant_detail/presentation/pages/plant_detail_page.dart';
import 'package:plantguardian/features/shared/models/profile_model.dart';
import 'package:plantguardian/features/profile/presentation/pages/profile_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Plant> plants = [
      Plant(
        name: 'Aloe Vera',
        type: 'Succulent',
        description: 'Needs indirect sunlight',
        lastWatered: '2 days ago',
      ),
      Plant(
        name: 'Monstera',
        type: 'Tropical',
        description: 'Keep soil moist',
        lastWatered: '5 days ago',
      ),
    ];

    final List<Profile> profile = [
      Profile(
        name: 'Noah',
        email: 'noah@gmail.com',
        userName: 'noahvi01',
        password: '1234',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plants'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(profile: profile[0]),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: Text('Profile'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: plants.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return PlantAddCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPlantPage()),
                );
              },
            );
          } else {
            final plant = plants[index - 1];
            return PlantCard(
              plant: plant,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantDetailPage(plant: plant),
                    ),
                  ),
            );
          }
        },
      ),
    );
  }
}
