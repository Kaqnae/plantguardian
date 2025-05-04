import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/models/profile_model.dart';
import 'package:plantguardian/features/profile/presentation/widgets/profile_form.dart';

class ProfilePage extends StatelessWidget {
  final Profile profile;

  const ProfilePage({super.key, required this.profile});

  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: profile.name);
    final emailController = TextEditingController(text: profile.email);
    final userNameController = TextEditingController(text: profile.userName);
    final passwordController = TextEditingController(text: profile.password);

    return Scaffold(
      appBar: AppBar(title: Text(profile.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileForm(
              nameController: nameController,
              emailController: emailController,
              userNameController: userNameController,
              passwordController: passwordController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
