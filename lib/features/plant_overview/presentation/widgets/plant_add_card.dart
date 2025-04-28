import 'package:flutter/material.dart';

class PlantAddCard extends StatelessWidget {
  final VoidCallback onTap;
  const PlantAddCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 65,
          child: Center(child: Icon(Icons.add_box_outlined, size: 30)),
        ),
      ),
    );
  }
}
