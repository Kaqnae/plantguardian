import 'package:flutter/material.dart';
import 'package:plantguardian/features/add_plant/presentation/pages/add_plant_page.dart';
import 'package:plantguardian/features/auth/presentation/pages/login_page.dart';
import 'package:plantguardian/features/plant_overview/data/fetch_custom_plants_api.dart';
import 'package:plantguardian/features/plant_overview/presentation/widgets/plant_add_card.dart';
import 'package:plantguardian/features/plant_overview/presentation/widgets/plant_card.dart';
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/plant_detail/presentation/pages/plant_detail_page.dart';
import 'package:plantguardian/features/profile/presentation/pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<CustomPlantModel>> futureCustomPlants;

  @override
  void initState() {
    super.initState();
    futureCustomPlants = FetchCustomPlantsApi().fetchPlants();
  }

  void _navigateToAddPlant() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPlantPage()),
    );

    // Genhent planter efter man har tilføjet én
    if (result == true) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        futureCustomPlants = FetchCustomPlantsApi().fetchPlants();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    builder: (context) => ProfilePage(),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
            itemBuilder:
                (BuildContext context) => const [
                  PopupMenuItem<String>(
                    value: 'profile',
                    child: Text('Profile'),
                  ),
                  PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
                ],
          ),
        ],
      ),
      body: FutureBuilder<List<CustomPlantModel>>(
        future: futureCustomPlants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Fejl: ${snapshot.error}'));
          }

          final plants = snapshot.data ?? [];

          return ListView.builder(
            itemCount: plants.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return PlantAddCard(onTap: _navigateToAddPlant);
              } else {
                final plant = plants[index - 1];
                return PlantCard(
                  plant: plant,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantDetailPage(plant: plant),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        futureCustomPlants =
                            FetchCustomPlantsApi().fetchPlants();
                      });
                    }
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
