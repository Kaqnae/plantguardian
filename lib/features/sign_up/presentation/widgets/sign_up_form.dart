import 'package:flutter/material.dart';
import 'package:plantguardian/features/sign_up/presentation/widgets/sign_up_textfields.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignUpForm({
    super.key,
    required this.nameController,
    required this.userNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SignUpTextfields(controller: nameController, label: 'Name'),
        SignUpTextfields(controller: userNameController, label: 'Username'),
        SignUpTextfields(controller: emailController, label: 'Email'),
        SignUpTextfields(
          controller: passwordController, 
          label: 'Password',
          obscureText: true,
          validator: (value) => 
              value == null || value.isEmpty ? 'Enter a password' : null,
        ),
        SignUpTextfields(
          controller: confirmPasswordController,
          label: 'Confirm Password',
          obscureText: true,
          validator: (value) => 
              value == null || value.isEmpty ? 'Enter a password' : null,
        ),
      ],
    );
  }
}
