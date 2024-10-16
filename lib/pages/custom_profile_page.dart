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

class CustomProfilePage extends StatefulWidget {
  @override
  _CustomProfilePageState createState() => _CustomProfilePageState();
}

class _CustomProfilePageState extends State<CustomProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isUpdating = false; // To indicate if an update is in progress
  bool _showEdit = false;
  String _statusMessage = ''; // To display success or error messages

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      body: Center(
        child: user != null
            ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                  setState(() {
                    _showEdit = !_showEdit;
                  });
                },
                child: Text(
                  _showEdit ? "Close Edit" : "Edit Password",
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
                  ),
                ),
              ),
              // Email update field
              _showEdit ? Column(
                children: [
                  SizedBox(height: 20,),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Password update field
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm New Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 12),

                  _isUpdating
                      ? CircularProgressIndicator() // Show a loader during update
                      : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _updateProfile,
                        child: Text(
                            'Update Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: Colors.black
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    _statusMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ) : Column(),

              SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await _auth.signOut();
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
                  ),
                ),
              ),
            ],
          ),
        )
            : Text('No user logged in.'),
      ),
    );
  }

  Future<void> _updateProfile() async {
    User? user = _auth.currentUser;

    if (user != null) {
      setState(() {
        _isUpdating = true;
        _statusMessage = ''; // Reset status message before each update
      });

      try {
        // Update password if the password field is not empty
        if (_passwordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty) {
          if(_passwordController.text != _confirmPasswordController.text){
            setState(() {
              _statusMessage = "New password must match confirm password.";
            });
          }
          else {
            await user.updatePassword(_passwordController.text);
            // Success message
            setState(() {
              _statusMessage = 'Profile updated successfully!';
              _confirmPasswordController.text = "";
              _passwordController.text = "";
            });
          }
        }


      } on FirebaseAuthException catch (e) {
        // Handle errors
        setState(() {
          _statusMessage = 'Error: ${e.message}';
        });
      } finally {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

