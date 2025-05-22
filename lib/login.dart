import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_application/screens/admin/admin_dashboard.dart';
import 'package:gym_application/screens/user/user_dashboard.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<UserCredential> _signIn(String email, String password) async {
    try {
      print('Attempting to sign in with email: $email');
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('Signed in successfully: ${userCredential.user!.email}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error Code: ${e.code}');
      print('Firebase Auth Error Message: ${e.message}');
      String message = 'An error occurred.';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format.';
      } else if (e.code == 'user-disabled') {
        message = 'This account has been disabled.';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many attempts. Please try again later.';
      } else if (e.code == 'network-request-failed') {
        message = 'Network error. Please check your internet connection.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
      throw Exception('Firebase Auth Error: ${e.code} - ${e.message}');
    } catch (e) {
      print('Unexpected error during sign in: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An unexpected error occurred. Please try again.'),
        backgroundColor: Colors.red,
      ));
      throw Exception('Unexpected error: $e');
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        print('Starting login process...');
        final userCredential = await _signIn(email, password);

        if (!mounted) return;

        // Check if we have a valid user
        if (userCredential.user != null) {
          print(
              'User authenticated successfully: ${userCredential.user!.email}');

          // Simple email check for admin
          if (email.toLowerCase() == "admin1@gmail.com") {
            print('Admin login detected, navigating to admin dashboard');
            if (!mounted) return;
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboard()),
            );
          } else {
            print('Regular user login detected, navigating to user dashboard');
            if (!mounted) return;
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserDashboard()),
            );
          }
        } else {
          print('Login successful but no user data received');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Login successful but user data not received. Please try again.'),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print('Login failed with error: $e');
        // Error already handled in _signIn
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/pic4.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Image.asset(
                      'assets/logg.png',
                      height: 70,
                      width: 70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Bonjour',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(35, 250, 35, 35),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.white),
                          errorStyle: TextStyle(color: Colors.red[200]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!_emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white),
                          errorStyle: TextStyle(color: Colors.red[200]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        onPressed: _login,
                        height: 40,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: const Color.fromARGB(255, 144, 0, 0),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'OR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      MaterialButton(
                        onPressed: () {}, // Google Sign-In logic here
                        height: 40,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: const Color.fromARGB(255, 144, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Login with Google",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              'assets/goo.png',
                              height: 35,
                              width: 35,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
