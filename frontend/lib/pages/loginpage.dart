import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Page',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo
              Center(
                child: Image.asset(
                  'assets/edigicatorlogo.png',
                  width: 100,
                  height: 200,
                ),
              ),

              const SizedBox(height: 20),

              // Box Container for ID and Password fields
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  border: Border.all(color: Colors.grey.shade300), // Border color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(2, 4), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // User ID Field
                    TextField(
                      controller: idController,
                      decoration: InputDecoration(
                        labelText: 'User ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Password Field
                    TextField(
                      controller: passwordController,
                      obscureText: true, // Hide password input
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle login action
                    String userId = idController.text;
                    String password = passwordController.text;
                    print("User ID: $userId, Password: $password");
                  },
                  child: const Text('Login', style: TextStyle(fontSize: 18)),
                ),
              ),
              // Add this inside your Column, right after the Login button
                 Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text("Don't have an account?"),
    TextButton(
      onPressed: () {
        // Navigate to Register Page (replace with your navigation logic)
        print("Navigate to Register Page");
      },
      child: const Text("Register"),
    ),
  ],
),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
