import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:while_app/view/home_screen.dart';
import 'package:while_app/view/auth/login_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    print(firebaseUser);
    // final googlesignin = context.read<FirebaseAuthMethods>().googleSignIn;
    print(firebaseUser == null);
    if (firebaseUser != null) {
      // print(googlesignin);
      return HomeScreen();
    } else {
      //return const MyPhone();
   
          return LoginScreen();

    }
  }
}
