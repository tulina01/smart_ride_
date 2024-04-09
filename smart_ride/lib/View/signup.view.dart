import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_ride/View/widgets/text.form.global.dart';

import '../components/flutter_toast.dart';
import '../utils/global.colors.dart';
import 'login.view.dart';
import 'menu.dart';

class SignupView extends StatelessWidget {
  SignupView({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<User?> _createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle any authentication exceptions (e.g., email already in use)
      AppToastmsg.appToastMeassage('Failed to create user: ${e.message}');
      return null;
    }
  }

  Future<void> _uploadUsernameToFirestore(
    User user,
    String username,
    String email,
    String address,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'username': username, 'email': email, 'address': address});
    } catch (e) {
      // Handle any Firestore upload exceptions
      AppToastmsg.appToastMeassage('Failed to upload username: $e');
    }
  }

  void _registerUserWithEmailAndPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, save form fields
      _formKey.currentState!.save();

      String email = _emailController.text;
      String password = _passwordController.text;
      String username = _usernameController.text;
      String address = _addressController.text;

      User? user = await _createUserWithEmailAndPassword(email, password);
      if (user != null) {
        await _uploadUsernameToFirestore(user, username, email, address);
        AppToastmsg.appToastMeassage('User registered successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Menu()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Smart Ride',
                      style: TextStyle(
                        color: GlobalColor.mainColor,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ATTACK',
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Sign up for an account',
                    style: TextStyle(
                        color: GlobalColor.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  // Email Input
                  TextFormGlobal(
                    controller: _emailController,
                    text: 'Email',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  // username Input
                  TextFormGlobal(
                    controller: _usernameController,
                    text: 'User Name',
                    obscure: false,
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  // address Input
                  TextFormGlobal(
                    controller: _addressController,
                    text: 'Address',
                    obscure: false,
                    textInputType: TextInputType.streetAddress,
                  ),
                  const SizedBox(height: 20),
                  // Password input
                  TextFormGlobal(
                    controller: _passwordController,
                    text: 'Password',
                    textInputType: TextInputType.visiblePassword,
                    obscure: true,
                  ),
                  const SizedBox(height: 20),
                  // Confirm Password input
                  TextFormGlobal(
                    controller: _confirmPasswordController,
                    text: 'Confirm Password',
                    textInputType: TextInputType.visiblePassword,
                    obscure: true,
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      // ignore: avoid_print
                      _registerUserWithEmailAndPassword(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 55,
                      decoration: BoxDecoration(
                        color: GlobalColor.mainColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // const SocialSignup(),
                  const SizedBox(height: 50),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginView()), // Navigate to the LoginView
                        );
                      },
                      child: const Text(
                        "Already have an account? Sign in",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}