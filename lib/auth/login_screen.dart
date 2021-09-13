import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phrase_recorder/auth/google_button.dart';
import 'package:phrase_recorder/store.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.userChanges().listen((user) {
      setUser(user);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TODO: insert logo here
                    // Flexible(
                    //   flex: 1,
                    //   child: Image.asset(
                    //     'assets/firebase_logo.png',
                    //     height: 160,
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    Text(
                      'Tatar',
                      style: TextStyle(fontSize: 40),
                    ),
                    Text(
                      'Authentication',
                      style: TextStyle(fontSize: 40),
                    ),
                    GoogleSignInButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
