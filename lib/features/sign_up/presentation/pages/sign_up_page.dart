import 'package:flutter/material.dart';
import 'package:plantguardian/features/shared/models/profile_model.dart';
import 'package:plantguardian/features/sign_up/presentation/widgets/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Sign up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SignUpForm(
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text('Sign up')),
          ],
        ),
      ),
    );
  }
}
