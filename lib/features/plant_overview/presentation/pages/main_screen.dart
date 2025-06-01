import 'package:flutter/material.dart';
import 'package:plantguardian/features/add_plant/presentation/pages/add_plant_page.dart';
import 'package:plantguardian/features/auth/presentation/pages/login_page.dart';
import 'package:plantguardian/features/plant_overview/data/fetch_custom_plants_api.dart';
import 'package:plantguardian/features/plant_overview/presentation/widgets/plant_add_card.dart';
import 'package:plantguardian/features/plant_overview/presentation/widgets/plant_card.dart';
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/plant_detail/presentation/pages/plant_detail_page.dart';
import 'package:plantguardian/features/profile/presentation/pages/profile_page.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';

/// Main screen displaying the user's custom plants.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

/// State class for MainScreen.
/// Handles fetching, displaying, and refreshing the user's custom plants.
class _MainScreenState extends State<MainScreen> {
  // Future holding the list of custom plants for the user
  late Future<List<CustomPlantModel>> futureCustomPlants;

  /// Initializes the screen by fetching the user's custom plants.
  @override
  void initState() {
    super.initState();
    futureCustomPlants = FetchCustomPlantsApi().fetchPlants();
  }

  /// Navigates to the AddPlantPage and refreshes the plant list if a new plant is added.
  void _navigateToAddPlant() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPlantPage()),
    );

    // Refresh plants after adding a new one
    if (result == true) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        futureCustomPlants = FetchCustomPlantsApi().fetchPlants();
      });
    }
  }

  /// Builds the main screen UI, including the app bar, menu, and plant list.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plants'),
        actions: [
          // Popup menu for profile and logout actions
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'profile') {
                // Navigate to the profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              } else if (value == 'logout') {
                // Clear JWT and navigate to login page
                CookieSingleton().jwtCookie = null;
                CookieSingleton().jwtPayload = null;
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
            // Show loading indicator while fetching data
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Show error message if fetching fails
            return Center(child: Text('Fejl: ${snapshot.error}'));
          }

          final plants = snapshot.data ?? [];

          // Build the list of plants, with an add button at the top
          return ListView.builder(
            itemCount: plants.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Card for adding a new plant
                return PlantAddCard(onTap: _navigateToAddPlant);
              } else {
                final plant = plants[index - 1];
                // Card for displaying a custom plant
                return PlantCard(
                  plant: plant,
                  onTap: () async {
                    // Navigate to plant detail and refresh if updated
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
