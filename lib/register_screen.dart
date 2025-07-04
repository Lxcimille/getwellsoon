import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Simulate network request
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          // Optional: Navigate back to login
          // Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      children: [
        Positioned(
          right: -30,
          top: 80,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: -50,
          bottom: -20,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFF), // Light blue background
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackgroundCircles(),
            
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Welcome text
                    const Center(
                      child: Text(
                        'Hello!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D6DA8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Profile image placeholder
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Full Name input
                    TextFormField(
                      controller: _nameController,
                      decoration: _buildInputDecoration('Insert full name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    
                    // Username input
                    TextFormField(
                      controller: _usernameController,
                      decoration: _buildInputDecoration('Insert Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    
                    // Email input
                    TextFormField(
                      controller: _emailController,
                      decoration: _buildInputDecoration('Insert email address'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    
                    // Password input
                    TextFormField(
                      controller: _passwordController,
                      decoration: _buildInputDecoration('Insert Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    
                    // Confirm Password input
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: _buildInputDecoration('Reenter Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    
                    // Register button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D6DA8), // Dark blue button
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, '/login');
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Color(0xFF2D6DA8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}