// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:flutter/material.dart';
//
// class CustomProfilePage extends StatefulWidget {
//   const CustomProfilePage({super.key});
//
//   @override
//   State<CustomProfilePage> createState() => _CustomProfilePageState();
// }
//
// class _CustomProfilePageState extends State<CustomProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return ProfileScreen(
//       actions: [
//         SignedOutAction((context) {
//           Navigator.popUntil(context, ModalRoute.withName('/'));
//         })
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './custom_signIn_page.dart';

class CustomProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Logged in as:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user.email ?? '',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  user.photoURL != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user.photoURL!),
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue,
                          child: Text(
                            user.email!.substring(0, 1).toUpperCase(),
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      _auth.signOut();
                    },
                    child: Text(
                      "Sign-out",
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
                ],
              )
            : Text('No user logged in.'),
      ),
    );
  }
}
