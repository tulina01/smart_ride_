import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_ride/View/widgets/text.form.global.dart';
import '../components/flutter_toast.dart';
import '../utils/global.colors.dart';
import 'signup.view.dart';

// ignore: must_be_immutable
class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isRememberMe = false;

  Future login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AppToastmsg.appToastMeassage('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        AppToastmsg.appToastMeassage('Wrong password provided for that user.');
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
                    'Login to your account',
                    style: TextStyle(
                        color: GlobalColor.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 45),
                  // Email Input
                  TextFormGlobal(
                    controller: emailController,
                    text: 'Email',
                    obscure: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  // password input
                  TextFormGlobal(
                      controller: passwordController,
                      text: 'Password',
                      textInputType: TextInputType.text,
                      obscure: true),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
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
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // const SocialLogin(),
                  const SizedBox(height: 220),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SignupView()), // Navigate to the SignupView
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign up here",
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