// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
// import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart'; // new
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// class CustomSignInScreen extends StatelessWidget {
//   const CustomSignInScreen({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SignInScreen(
//       styles: {
//         EmailFormStyle(
//           signInButtonVariant: ButtonVariant.filled,
//         ),
//       },
//       showPasswordVisibilityToggle: true,
//       providers: [
//         EmailAuthProvider(),
//         GoogleProvider(clientId: dotenv.env["WEB_CLIENT_SECRET"] ?? "KEY_NOT_FOUND")
//       ],
//       headerBuilder: (context, constraints, shrinkOffset) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: AspectRatio(
//             aspectRatio: 1,
//             child: Image.asset('images/img.png'),
//           ),
//         );
//       },
//       subtitleBuilder: (context, action) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: action == AuthAction.signIn
//               ? const Text('Welcome to Any-News, please sign in!')
//               : const Text('Welcome to Any-News, please sign up!'),
//         );
//       },
//       footerBuilder: (context, action) {
//         return const Padding(
//           padding: EdgeInsets.only(top: 16),
//           child: Text(
//             'By signing in, you agree to our terms and conditions.',
//             style: TextStyle(color: Colors.grey),
//           ),
//         );
//       },
//       sideBuilder: (context, shrinkOffset) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: AspectRatio(
//             aspectRatio: 1,
//             child: Image.asset('images/img.png'),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart'; // For Google sign-in
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomSignInScreen extends StatefulWidget {
  const CustomSignInScreen({Key? key}) : super(key: key);

  @override
  _CustomSignInScreenState createState() => _CustomSignInScreenState();
}

class _CustomSignInScreenState extends State<CustomSignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // Function to sign in with email and password
  Future<void> _signInWithEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to sign in with Google
  Future<void> _signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      await _auth.signInWithPopup(googleProvider);  // For web-based sign-in
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign-In'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                constraints: BoxConstraints(
                  maxWidth: 700,
                ),
                child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                Image.asset('images/img.png', height: 150), // Custom header image
                const SizedBox(height: 20),

                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Icon(
                      Icons.email_outlined
                    ),
                    hintText: "example@abc.com",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    icon: Icon(
                      Icons.password_outlined
                    )
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: _signInWithEmail,
                  child: Text(
                    "Sign-in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black, // Background color
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),// Border around the button
                  ),
                ),

                const SizedBox(height: 10),

                // Google Sign-In Button
                ElevatedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: Image.asset(
                    'images/google_icon.png', // Custom Google icon
                    height: 24,
                  ),
                  label: const Text(
                      'Sign In with Google',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // White background for Google button
                  ),
                ),

                const SizedBox(height: 20),

                const Text('By signing in, you agree to our terms and conditions.', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
              ),
        ),
      ),
    );
  }
}
