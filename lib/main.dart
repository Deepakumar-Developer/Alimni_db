import 'package:alimni_db/screens/GateSource.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'firebase_options.dart';
import 'function.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    customStatusBar(
        Colors.transparent,
        colorBackGround,
        mode ? Brightness.dark : Brightness.light,
        mode ? Brightness.dark : Brightness.light);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Data Analysis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: color_30),
        useMaterial3: true,
      ),
      home: const GateSource(),
    );
  }
}
