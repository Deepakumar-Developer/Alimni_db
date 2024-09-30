import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../function.dart';

class MyHeroPage extends StatefulWidget {
  const MyHeroPage({super.key});

  @override
  State<MyHeroPage> createState() => _MyHeroPageState();
}

class _MyHeroPageState extends State<MyHeroPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      showLoader = false;
      data = true;
      getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackGround,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (logoUrl.isEmpty)
              ClipRRect(
                child: Image.asset(
                  'assets/images/university.png',
                  height: 200,
                ),
              ),
            if (logoUrl.isNotEmpty)
              Image.network(
                logoUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Image is loaded
                  }
                  return ClipRRect(
                    child: Image.asset(
                      'assets/images/university.png',
                      height: 200,
                    ),
                  );
                },
                errorBuilder: (context, child, loadingProgress) {
                  return Image.asset(
                    'assets/images/university.png',
                    height: 200,
                  );
                },
                height: 200,
              ),
            Column(
              children: [
                Text(
                  collegeName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: colorOther,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  departmentName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: colorOther,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              width: width(context) * 0.8,
              child: LinearProgressIndicator(
                backgroundColor: color_10.withOpacity(0.2),
                color: color_30,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getProfileData() async {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('dataAnalysis');
    if (FirebaseAuth.instance.currentUser != null) {
      profile = profile
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('other');
    }

    final docSnapshotAge = await profile.doc('profileData').get()
        as DocumentSnapshot<Map<String, dynamic>>;

    if (!docSnapshotAge.exists) {
      print('Document does not exist!');
      return;
    }

    // Extract the data
    final data = docSnapshotAge.data();
    if (data != null) {
      setState(() {
        collegeName = data['college'];
        departmentName = data['department'];
        logoUrl = data['url'];
      });
    }
  }
}
