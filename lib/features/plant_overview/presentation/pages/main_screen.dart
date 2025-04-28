import 'package:flutter/material.dart';
import 'package:plantguardian/features/add_plant/presentation/pages/add_plant_page.dart';
import 'package:plantguardian/features/plant_overview/presentation/widgets/plant_add_card.dart';
import 'package:plantguardian/features/plant_overview/presentation/widgets/plant_card.dart';
import 'package:plantguardian/features/shared/models/plant_model.dart';
import 'package:plantguardian/features/plant_detail/presentation/pages/plant_detail_page.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plants'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPlantPage()),
              );
            },
            itemBuilder: (BuildContext context) {
              return {'Add Plant'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
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
