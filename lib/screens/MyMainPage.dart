import 'package:flutter/material.dart';

import '../function.dart';
import 'MyHeropage.dart';
import 'MyHomePage.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  @override
  void initState() {
    super.initState();

    // TODO: implement initState
    Future.delayed(const Duration(milliseconds: 1), () {
      setState(() {
        AuthServices().getProfileData();
      });
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          showPage = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showPage) {
      return const MyHomePage();
    }
    return const MyHeroPage();
  }
}
