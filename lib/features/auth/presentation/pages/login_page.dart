import 'package:flutter/material.dart';
import 'package:plantguardian/features/auth/data/login_api_service.dart';
import 'package:plantguardian/features/sign_up/presentation/pages/sign_up_page.dart';

/// Login page for user authentication.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// State class for LoginPage.
/// Handles user input, login logic, and navigation.
class _LoginPageState extends State<LoginPage> {
  // Controllers for the email and password text fields
  late TextEditingController emailController;
  late TextEditingController passwordController;

  /// Initializes the text controllers.
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  /// Disposes the text controllers to free resources.
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Builds the login page UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Adds vertical space to center the form
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              // Email input field
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Username'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              // Password input field
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // Login button
              ElevatedButton(
                onPressed: () async {
                  final loginService = LoginApiService();
                  final success = await loginService.login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                  if (success) {
                    Navigator.pushReplacementNamed(context, '/main');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login Failed')),
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              // Sign up button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: const Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
