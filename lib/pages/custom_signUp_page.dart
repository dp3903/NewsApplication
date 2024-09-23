import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'custom_signIn_page.dart';

class CustomSignUpScreen extends StatefulWidget {
  const CustomSignUpScreen({Key? key}) : super(key: key);

  @override
  _CustomSignUpScreenState createState() => _CustomSignUpScreenState();
}

class _CustomSignUpScreenState extends State<CustomSignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;

  // Function to sign up with email and password
  Future<void> _signUpWithEmail() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords don't match")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // await _auth.signInWithEmailAndPassword(
      //   email: _emailController.text.trim(),
      //   password: _passwordController.text.trim(),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    Navigator.pop(context);
  }

  // Function to sign up with Google
  Future<void> _signUpWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web sign-in using signInWithPopup
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        await _auth.signInWithPopup(googleProvider);
      } else {
        // Mobile sign-in using GoogleSignIn and Firebase
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          // User canceled the sign-in
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential for mobile
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the mobile credentials
        await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      print("Error during Google sign-up: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign-Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/img.png', height: 150), // Custom header image
                const SizedBox(height: 20),

                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email_outlined),
                    hintText: "example@abc.com",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.password_outlined),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    icon: Icon(Icons.password_outlined),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: _signUpWithEmail,
                  child: const Text(
                    "Sign-up",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black, // Background color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Google Sign-Up Button
                ElevatedButton.icon(
                  onPressed: _signUpWithGoogle,
                  icon: Image.asset(
                    'assets/images/google_icon.png', // Custom Google icon
                    height: 24,
                  ),
                  label: const Text(
                    'Sign Up with Google',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);// Go back to the sign-in screen
                  },
                  child: const Text(
                    "Sign in here",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black, // Background color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'By signing up, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
