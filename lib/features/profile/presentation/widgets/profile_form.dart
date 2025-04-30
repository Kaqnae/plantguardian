import "package:flutter/material.dart";
import 'package:plantguardian/features/profile/presentation/widgets/profile_textfields.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController userNameController;
  final TextEditingController passwordController;

  const ProfileForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.userNameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileTextfields(controller: nameController, label: 'Name'),
        ProfileTextfields(controller: emailController, label: 'Email'),
        ProfileTextfields(controller: userNameController, label: 'Username'),
        ProfileTextfields(controller: passwordController, label: 'Password'),
      ],
    );
  }
}
