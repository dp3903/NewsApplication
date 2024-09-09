import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart'; // new
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomSignInScreen extends StatelessWidget {
  const CustomSignInScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      styles: {
        EmailFormStyle(
          signInButtonVariant: ButtonVariant.filled,
        ),
      },
      showPasswordVisibilityToggle: true,
      providers: [
        EmailAuthProvider(),
        GoogleProvider(clientId: dotenv.env["WEB_CLIENT_SECRET"] ?? "KEY_NOT_FOUND")
      ],
      headerBuilder: (context, constraints, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('images/img.png'),
          ),
        );
      },
      subtitleBuilder: (context, action) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: action == AuthAction.signIn
              ? const Text('Welcome to Any-News, please sign in!')
              : const Text('Welcome to Any-News, please sign up!'),
        );
      },
      footerBuilder: (context, action) {
        return const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            'By signing in, you agree to our terms and conditions.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      },
      sideBuilder: (context, shrinkOffset) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset('images/img.png'),
          ),
        );
      },
    );
  }
}