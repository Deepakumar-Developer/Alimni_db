import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'colors.dart';

bool obscureText = true;
bool mode = true;
bool logIn = true;
bool data = true;
bool showPage = false;
bool header = false;
bool paddingAnime = false;
bool showLoader = false;
String collegeName = '';
String departmentName = '';
String logoUrl = '';
String dataBaseName = '';
String dataBasePassword = '';
List<String> tableValue = [];
List<String> finalData = [];

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

void customStatusBar(var statusBarColor, systemNavigationBarColor,
    statusBarIconBrightness, systemNavigationBarIconBrightness) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: statusBarColor,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: statusBarIconBrightness,
    systemNavigationBarColor: systemNavigationBarColor,
    systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
  ));
}

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, password) async {
    try {
      var userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password) async {
    try {
      var userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<void> setProfile(String college, dept, profileUrl) async {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('dataAnalysis');
    if (FirebaseAuth.instance.currentUser != null) {
      profile = profile
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('other');

      await profile.doc('profileData').set({
        'college': college,
        'department': dept,
        'url': profileUrl,
      });
    }
  }

  Future<void> setDatabaseDetails(String dataBaseName, dataBasePassword) async {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('dataAnalysis');
    if (FirebaseAuth.instance.currentUser != null) {
      profile = profile
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('other');

      await profile.doc('databaseDetails').set({
        'dataBaseName': dataBaseName,
        'dataBasePassword': dataBasePassword,
      });
    }
  }

  Future<void> setData(String details) async {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('dataAnalysis');
    if (FirebaseAuth.instance.currentUser != null) {
      profile = profile
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(dataBaseName);

      await profile.doc().set({
        // 'id': id,
        'details': details,
      });
    }
  }

  Future<void> getProfileData() async {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('dataAnalysis');
    if (FirebaseAuth.instance.currentUser != null) {
      profile = profile
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('other');

      final docSnapshotAge = await profile.doc('profileData').get()
          as DocumentSnapshot<Map<String, dynamic>>;

      if (!docSnapshotAge.exists) {
        return;
      }

      final data = docSnapshotAge.data();
      if (data != null) {
        collegeName = data['college'];
        departmentName = data['department'];
        logoUrl = data['url'];
      }
    }
  }
}

class Controller {
  Future<void> getExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        for (var table in excel.tables.keys) {
          List<dynamic> headerValue = [];
          for (var row in excel.tables[table]!.rows) {
            String cellValue = '';
            int index = 0;

            for (var cell in row) {
              final value = cell?.value;
              print(cell?.value);
              if ('${cell?.value}'
                      .toLowerCase()
                      .replaceAll(RegExp(r"\s"), "")
                      .trim() ==
                  's.no') {
                header = true;
              }
              if (header) {
                headerValue.add('${cell?.value}');
              }
              print(cellValue);
              if (headerValue.length >= row.length - (row.length * 0.5)) {
                cellValue =
                    '$cellValue ${headerValue[index]} : ${cell?.value}\n';
                index += 1;
              }
            }
            header = false;
            AuthServices().setData(cellValue);
            cellValue = '';
            index = 0;
          }
        }

        showToast('Data\'s updates successfully');
      }
    } catch (error) {
      print('error \n\n $error\n\n');
      showToast('Error Try Again');
    }
  }
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: colorOther.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0);
}
