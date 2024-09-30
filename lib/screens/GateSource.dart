import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'AuthScreen.dart';
import 'MyMainPage.dart';

class GateSource extends StatelessWidget {
  const GateSource({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return const AuthScreens();
    }
    return const MyMainPage();
  }
}
