import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../colors.dart';
import '../function.dart';
import 'AuthScreen.dart';
import 'location.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _dataKey = GlobalKey<FormState>();
  final _rollNumber = TextEditingController();
  final _baseName = TextEditingController();
  final _basePassword = TextEditingController();
  final _reference = TextEditingController();
  bool showDataTextField = false, getLocation = false, searchLoader = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      tableValue = [];
      getDatabaseDetails();
      finalData = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            mode ? const Color(0xffFFF7FC) : const Color(0xff3f3d56),
        foregroundColor:
            mode ? const Color(0xff3f3d56) : const Color(0xffFFF7FC),
        title: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width(context) * 0.7,
                height: height(context) * 0.04,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  reverse: false,
                  children: [
                    Text(
                      collegeName,
                      style: TextStyle(
                          color: mode
                              ? const Color(0xff3f3d56)
                              : const Color(0xffFFF7FC),
                          overflow: TextOverflow.ellipsis,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                  onTap: () {
                    AuthServices().signOut();
                    setState(() {
                      dataBaseName = '';
                      dataBasePassword = '';
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthScreens()),
                    );
                  },
                  child: const Icon(Icons.logout_rounded))
            ],
          ),
        ),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            setState(() {
              mode = !mode;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image.network(
              logoUrl,
              height: 25,
              errorBuilder: (context, child, loadingProgress) {
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(200)),
                  child: Image.asset(
                    'assets/images/university.png',
                    height: 200,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ColoredBox(
            color: mode ? const Color(0xffFFF7FC) : const Color(0xff3f3d56),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: height(context) - 86.0,
                width: width(context),
                child: Padding(
                  padding: const EdgeInsets.all(17.5),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: width(context),
                          height: height(context),
                          decoration: BoxDecoration(
                              color: mode
                                  ? const Color(0xffFFF7FC)
                                  : const Color(0xff3f3d56),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                  blurRadius: 5,
                                ),
                                BoxShadow(
                                  color:
                                      (!mode) ? Colors.white : Colors.white54,
                                  offset: const Offset(1, 1),
                                  blurRadius: 5,
                                ),
                              ]),
                          margin: const EdgeInsets.only(bottom: 8.75),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                padding: const EdgeInsets.only(
                                    bottom: 1.0, right: 10, left: 15),
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(1, 1),
                                        blurRadius: 40,
                                        spreadRadius: 5),
                                  ],
                                  color: color_30.withOpacity(0.1727),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: TextField(
                                  controller: _rollNumber,
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (value) {
                                    if (tableValue.isEmpty) {
                                      showToast('Data is empty');
                                      setState(() {
                                        getDocumentsFromCollection();
                                      });
                                    } else {
                                      setState(() {
                                        if (_rollNumber.text.isNotEmpty) {
                                          searchLoader = true;
                                          findData(_rollNumber.text);
                                          searchLoader = false;
                                        }
                                      });
                                    }
                                  },
                                  cursorColor: mode
                                      ? const Color(0xff3f3d56)
                                      : const Color(0xffFFF7FC),
                                  autocorrect: false,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: mode
                                          ? const Color(0xff3f3d56)
                                          : const Color(0xffFFF7FC)),
                                  decoration: InputDecoration(
                                      labelText: 'Search',
                                      labelStyle: TextStyle(
                                          color: mode
                                              ? const Color(0xff3f3d56)
                                              : const Color(0xffFFF7FC)),
                                      hintText: '',
                                      border: InputBorder.none,
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _rollNumber.clear();
                                            finalData = [];
                                            showToast('Delete Search History');
                                          });
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Icon(
                                              Icons.clear,
                                            )),
                                      ),
                                      suffixIconColor: !mode
                                          ? const Color(0xffFFF7FC)
                                          : const Color(0xff3f3d56)),
                                ),
                              ),
                              Expanded(
                                  child: Stack(
                                children: [
                                  finalData.isEmpty
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/images/search_logo.svg',
                                            height: 125,
                                          ),
                                        )
                                      : Container(
                                          margin: const EdgeInsets.all(10),
                                          height: height(context),
                                          width: width(context),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            color: color_10.withOpacity(0.35),
                                          ),
                                          child: ListView.builder(
                                            itemCount: finalData.length,
                                            itemBuilder: (context, index) {
                                              return Text(
                                                finalData[index],
                                                style: TextStyle(
                                                    color: mode
                                                        ? const Color(
                                                            0xff3f3d56)
                                                        : const Color(
                                                            0xffFFF7FC)),
                                              );
                                            },
                                          ),
                                        ),
                                  if (searchLoader)
                                    Align(
                                      alignment: const Alignment(0, 0.5),
                                      child: CircularProgressIndicator(
                                        color: color_30,
                                      ),
                                    ),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showDataTextField = true;
                                    setState(() {
                                      getDatabaseDetails();
                                      _baseName.text = dataBaseName;
                                    });
                                  });
                                },
                                child: Container(
                                  width: width(context),
                                  height: height(context),
                                  decoration: BoxDecoration(
                                      color: mode
                                          ? const Color(0xffFFF7FC)
                                          : const Color(0xff3f3d56),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        topLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                      boxShadow: [
                                        const BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 1),
                                          blurRadius: 5,
                                        ),
                                        BoxShadow(
                                          color: (!mode)
                                              ? Colors.white
                                              : Colors.white54,
                                          offset: const Offset(1, 1),
                                          blurRadius: 5,
                                        ),
                                      ]),
                                  margin: const EdgeInsets.only(right: 8.75),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/upload.svg',
                                        height: 75,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Upload',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: mode
                                              ? const Color(0xff3f3d56)
                                              : const Color(0xffFFF7FC),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (tableValue.isEmpty) {
                                    showToast('Data is empty');
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyLocationSearch()),
                                    );
                                  }
                                },
                                child: Container(
                                  width: width(context),
                                  height: height(context),
                                  decoration: BoxDecoration(
                                      color: mode
                                          ? const Color(0xffFFF7FC)
                                          : const Color(0xff3f3d56),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        topLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                      boxShadow: [
                                        const BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 1),
                                          blurRadius: 5,
                                        ),
                                        BoxShadow(
                                          color: (!mode)
                                              ? Colors.white
                                              : Colors.white54,
                                          offset: const Offset(1, 1),
                                          blurRadius: 5,
                                        ),
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/location.svg',
                                        height: 75,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Location',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: mode
                                              ? const Color(0xff3f3d56)
                                              : const Color(0xffFFF7FC),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (showDataTextField)
            GestureDetector(
              onTap: () {
                setState(() {
                  _basePassword.clear();
                  _reference.clear();
                  showDataTextField = false;
                });
              },
              child: Container(
                color:
                    (mode ? const Color(0xff3f3d56) : const Color(0xffFFF7FC))
                        .withOpacity(0.4),
                width: width(context),
                height: height(context),
              ),
            ),
          if (showDataTextField) _dbDetails(),
        ],
      ),
    );
  }

  Widget _dbDetails() {
    return Container(
        width: width(context) * 0.8,
        height: height(context) * 0.45,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 5,
              ),
            ],
            color: mode ? const Color(0xffFFF7FC) : const Color(0xff3f3d56)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                (dataBaseName.isNotEmpty && dataBasePassword.isNotEmpty)
                    ? 'Database Details'
                    : 'Create DataBase',
                style: TextStyle(
                    color: mode
                        ? const Color(0xff3f3d56)
                        : const Color(0xffFFF7FC),
                    fontWeight: FontWeight.w900,
                    fontSize: 23),
              ),
            ),
            Form(
              key: _dataKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: width(context),
                    height: height(context) * 0.260,
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 15, top: 20),
                          padding: const EdgeInsets.only(
                              bottom: 1.0, right: 10, left: 15),
                          decoration: BoxDecoration(
                            color: (mode
                                    ? const Color(0xff3f3d56)
                                    : const Color(0xffFFF7FC))
                                .withOpacity(0.1727),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: TextFormField(
                            controller: _baseName,
                            cursorColor: mode
                                ? const Color(0xff3f3d56)
                                : const Color(0xffFFF7FC),
                            autocorrect: false,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: mode
                                    ? const Color(0xff3f3d56)
                                    : const Color(0xffFFF7FC)),
                            decoration: InputDecoration(
                              labelText: 'DataBase Name',
                              labelStyle: TextStyle(
                                  color: mode
                                      ? const Color(0xff3f3d56)
                                      : const Color(0xffFFF7FC),
                                  fontSize: 15),
                              hintText: '',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Set the database name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              bottom: 1.0, right: 10, left: 15),
                          decoration: BoxDecoration(
                            color: (mode
                                    ? const Color(0xff3f3d56)
                                    : const Color(0xffFFF7FC))
                                .withOpacity(0.1727),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: TextFormField(
                            controller: _basePassword,
                            cursorColor: mode
                                ? const Color(0xff3f3d56)
                                : const Color(0xffFFF7FC),
                            autocorrect: false,
                            textAlign: TextAlign.start,
                            obscureText: obscureText,
                            obscuringCharacter: '*',
                            style: TextStyle(
                                color: (mode
                                        ? const Color(0xff3f3d56)
                                        : const Color(0xffFFF7FC))
                                    .withOpacity(0.95)),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: mode
                                      ? const Color(0xff3f3d56)
                                      : const Color(0xffFFF7FC),
                                  fontSize: 15),
                              hintText: '',
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon(obscureText
                                    ? Icons.remove_red_eye_rounded
                                    : Icons.remove_red_eye_outlined),
                              ),
                              suffixIconColor: mode
                                  ? const Color(0xff3f3d56)
                                  : const Color(0xffFFF7FC),
                            ),
                            validator: (value) {
                              if (value!.length < 8) {
                                return 'Password must contain 8 char';
                              } else if (value != dataBasePassword &&
                                  _baseName.text == dataBaseName) {
                                return 'Password Incorrect';
                              }
                              return null;
                            },
                          ),
                        ),
                        // if (dataBaseName.isNotEmpty)
                        //   Container(
                        //     margin: const EdgeInsets.only(top: 15),
                        //     padding: const EdgeInsets.only(
                        //         bottom: 1.0, right: 10, left: 15),
                        //     decoration: BoxDecoration(
                        //       color: (mode
                        //               ? const Color(0xff3f3d56)
                        //               : const Color(0xffFFF7FC))
                        //           .withOpacity(0.1727),
                        //       borderRadius:
                        //           const BorderRadius.all(Radius.circular(10)),
                        //     ),
                        //     child: TextFormField(
                        //       controller: _reference,
                        //       cursorColor: mode
                        //           ? const Color(0xff3f3d56)
                        //           : const Color(0xffFFF7FC),
                        //       keyboardType: TextInputType.number,
                        //       autocorrect: false,
                        //       textAlign: TextAlign.start,
                        //       style: TextStyle(
                        //           color: mode
                        //               ? const Color(0xff3f3d56)
                        //               : const Color(0xffFFF7FC)),
                        //       decoration: InputDecoration(
                        //         labelText: 'Reference',
                        //         labelStyle: TextStyle(
                        //             color: mode
                        //                 ? const Color(0xff3f3d56)
                        //                 : const Color(0xffFFF7FC),
                        //             fontSize: 15),
                        //         hintText: 'Give sample register number',
                        //         hintStyle: TextStyle(
                        //             color: mode
                        //                 ? const Color(0xff3f3d56)
                        //                 : const Color(0xffFFF7FC)
                        //                     .withOpacity(0.7),
                        //             fontSize: 12.5),
                        //         border: InputBorder.none,
                        //       ),
                        //       validator: (value) {
                        //         if (value == null || value.isEmpty) {
                        //           return 'reference*';
                        //         }
                        //         return null;
                        //       },
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_dataKey.currentState!.validate()) {
                        if (dataBaseName.isEmpty || dataBasePassword.isEmpty) {
                          AuthServices().setDatabaseDetails(
                              _baseName.text, _basePassword.text);
                          setState(() {
                            getDatabaseDetails();
                            _baseName.text = dataBaseName;
                          });
                        } else {
                          final controller = Controller();
                          controller.getExcelFile();
                          setState(() {
                            getDocumentsFromCollection();
                          });
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width(context) * 0.1,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7.5)),
                          color: color_30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            (dataBaseName.isNotEmpty &&
                                    dataBasePassword.isNotEmpty)
                                ? Icons.file_open
                                : Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            (dataBaseName.isNotEmpty &&
                                    dataBasePassword.isNotEmpty)
                                ? 'Upload files'
                                : 'Create Database',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> getDatabaseDetails() async {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('dataAnalysis');
    if (FirebaseAuth.instance.currentUser != null) {
      profile = profile
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('other');

      final docSnapshotAge = await profile.doc('databaseDetails').get()
          as DocumentSnapshot<Map<String, dynamic>>;

      if (!docSnapshotAge.exists) {
        showToast('Document does not exist!');
        return;
      }

      // Extract the data
      final data = docSnapshotAge.data();
      if (data != null) {
        setState(() {
          dataBaseName = data['dataBaseName'];
          dataBasePassword = data['dataBasePassword'];
        });
      }
    }
    if (tableValue.isEmpty) {
      getDocumentsFromCollection();
    }
  }

  Future<void> getDocumentsFromCollection() async {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('dataAnalysis');
    if (FirebaseAuth.instance.currentUser != null) {
      profile = profile
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(dataBaseName);

      final snapshot = await profile.get();
      if (snapshot.docs.isEmpty) {
        setState(() {
          tableValue = [];
        });
      }

      final dataList = snapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['details'] as String)
          .toList();

      setState(() {
        tableValue = dataList;
      });
    }
    // final idList = snapshot.docs
    //     .map((doc) => (doc.data() as Map<String, dynamic>)['id'] as String)
    //     .toList();
    //
    // setState(() {
    //   idValue = idList;
    // });

    showToast('successfully get all data');
  }

  void findData(String rollNumber) {
    bool found = false;
    List<String> storage = finalData;
    if (finalData.isEmpty) {
      storage = tableValue;
    }
    finalData = [];
    for (var row in storage) {
      if (row.toLowerCase().contains(rollNumber.toLowerCase())) {
        setState(() {
          finalData.add(row);
          searchLoader = false;
          found = true;
        });
      }
    }
    if (!found) {
      showToast('Candidate not founded');
    }
    setState(() {
      searchLoader = false;
    });
    showToast('${finalData.length} found related to $rollNumber');
  }
}
