import 'package:flutter/material.dart';
import 'package:plantguardian/features/profile/data/fetch_user_api.dart';
import 'package:plantguardian/features/profile/data/update_user_api.dart';
import 'package:plantguardian/features/shared/models/profile_model.dart';
import 'package:plantguardian/features/profile/presentation/widgets/profile_form.dart';

/// ProfilePage is a StatefulWidget that manages user profile settings.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilePage> {
  /// Holds the current user profile data.
  Profile? profile;

  /// Controllers for profile input fields.
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  /// Future that completes when the profile data is loaded.
  late Future<void> fetchingProfileFuture;

  @override
  void initState() {
    super.initState();

    // Initialize text controllers.
    nameController = TextEditingController();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    // Start loading the profile data.
    fetchingProfileFuture = _loadProfile();
  }

  /// Loads the profile from the API and sets the input field values.
  Future<void> _loadProfile() async {
    final data = await FetchUserApi().fetchUser();
    profile = data;

    nameController.text = data.name;
    emailController.text = data.email;
    usernameController.text = data.userName;
    passwordController.text = data.password;
  }

  @override
  void dispose() {
    // Dispose controllers to free resources.
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  /// Saves the profile by sending updated data to the API.
  void _saveProfile() async {
    if (profile == null) return;

    final updatedProfile = Profile(
      id: profile!.id,
      name: nameController.text,
      role: profile!.role,
      email: emailController.text,
      userName: usernameController.text,
      password: passwordController.text,
    );

    final success = await UpdateUserApi().updateUser(updatedProfile);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated!')),
      );
      setState(() {
        profile = updatedProfile;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed updating profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Settings')),
      body: FutureBuilder<void>(
        future: fetchingProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading spinner while waiting for profile data.
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Show error message if loading failed.
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Show profile form once data is loaded.
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProfileForm(
                  nameController: nameController,
                  emailController: emailController,
                  userNameController: usernameController,
                  passwordController: passwordController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}