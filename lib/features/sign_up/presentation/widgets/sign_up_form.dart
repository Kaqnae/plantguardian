import 'package:flutter/material.dart';
import 'package:plantguardian/features/sign_up/presentation/widgets/sign_up_textfields.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SignUpTextfields(controller: nameController, label: 'Name'),
        SignUpTextfields(controller: emailController, label: 'Email'),
        SignUpTextfields(controller: passwordController, label: 'Password'),
        SignUpTextfields(
          controller: confirmPasswordController,
          label: 'Confirm Password',
        ),
      ],
    );
  }
}
