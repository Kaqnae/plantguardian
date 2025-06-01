import "package:flutter/material.dart";
import 'package:plantguardian/features/profile/presentation/widgets/profile_textfields.dart';

/// Widget representing a form for editing user profile information.
/// Displays text fields for name, email, username, and password.
class ProfileForm extends StatelessWidget {
  /// Controller for the name text field.
  final TextEditingController nameController;

  /// Controller for the email text field.
  final TextEditingController emailController;

  /// Controller for the username text field.
  final TextEditingController userNameController;

  /// Controller for the password text field.
  final TextEditingController passwordController;

  /// Creates a ProfileForm widget.
  const ProfileForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.userNameController,
    required this.passwordController,
  });

  /// Builds the UI for the profile form.
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
