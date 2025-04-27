import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/plant_overview/presentation/pages/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PlantGuardianApp());
}

class PlantGuardianApp extends StatelessWidget {
  const PlantGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Guardian',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
