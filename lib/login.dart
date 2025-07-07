import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'MyHomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;

  Future<void> _handleSignIn() async {
    setState(() => _isSigningIn = true);

    final User? user = await signInWithGoogle();

    setState(() => _isSigningIn = false);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(user.displayName ?? "Guest"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Google sign-in failed")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    signOutGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Center(
        child: _isSigningIn
            ? const CircularProgressIndicator()
            : OutlinedButton.icon(
                icon: Image.asset('assets/google_logo.png', height: 30),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                ),
                onPressed: _handleSignIn,
              ),
      ),
    );
  }
}
