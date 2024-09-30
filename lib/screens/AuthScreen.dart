import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../function.dart';
import 'MyMainPage.dart';

class AuthScreens extends StatefulWidget {
  const AuthScreens({super.key});

  @override
  State<AuthScreens> createState() => _AuthScreensState();
}

class _AuthScreensState extends State<AuthScreens> {
  final _authKey = GlobalKey<FormState>();
  final _dataKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _collegeController = TextEditingController();
  final _departmentController = TextEditingController();
  final _logoController = TextEditingController();
  var colorBackGround =
      mode ? const Color(0xffFFF7FC) : const Color(0xff3f3d56);
  var color_30 = const Color(0xff5755FE);
  var color_10 = const Color(0xff8B93FF);
  var colorOther = mode ? const Color(0xff3f3d56) : const Color(0xffFFF7FC);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      showLoader = false;
    });
    disposeVariable();
  }

  void disposeVariable() {
    setState(() {
      _logoController.clear();
      _departmentController.clear();
      _collegeController.clear();
      _passwordController.clear();
      _emailController.clear();
      showLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackGround,
      body: Center(
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(
                  height: height(context) * 0.1,
                ),
                SizedBox(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            mode = !mode;
                          });
                        },
                        child: SizedBox(
                          child: SvgPicture.asset(
                            'assets/images/hello.svg',
                            width: width(context) * 0.75,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height(context) * 0.03,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            bottom: 20.0, top: 2.50, left: 2.50, right: 2.50),
                        decoration: BoxDecoration(
                          color: color_30.withOpacity(0.95),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(15),
                              top: Radius.circular(2.5)),
                        ),
                        width: width(context) * 0.85,
                        child: data
                            ? Stack(
                                children: [
                                  Form(
                                    key: _authKey,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height(context) * 0.1,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          padding: const EdgeInsets.only(
                                              bottom: 1.0, right: 10, left: 15),
                                          decoration: BoxDecoration(
                                            color: color_10.withOpacity(0.2727),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                          ),
                                          child: TextFormField(
                                            controller: _emailController,
                                            cursorColor: colorBackGround,
                                            autocorrect: false,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: colorBackGround
                                                    .withOpacity(0.95)),
                                            decoration: InputDecoration(
                                              labelText: 'E-mail',
                                              labelStyle: TextStyle(
                                                  color: colorBackGround),
                                              hintText: '',
                                              border: InputBorder.none,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Enter E-mail';
                                              } else if (!(EmailValidator
                                                  .validate(value))) {
                                                return 'Enter valid E-mail ';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          padding: const EdgeInsets.only(
                                              bottom: 1.0, right: 10, left: 15),
                                          decoration: BoxDecoration(
                                            color: color_10.withOpacity(0.2727),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                          ),
                                          child: TextFormField(
                                            controller: _passwordController,
                                            cursorColor: colorBackGround,
                                            autocorrect: false,
                                            textAlign: TextAlign.start,
                                            obscureText: obscureText,
                                            obscuringCharacter: '*',
                                            style: TextStyle(
                                                color: colorBackGround
                                                    .withOpacity(0.95)),
                                            decoration: InputDecoration(
                                              labelText: 'Password',
                                              labelStyle: TextStyle(
                                                  color: colorBackGround),
                                              hintText: '',
                                              border: InputBorder.none,
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    obscureText = !obscureText;
                                                  });
                                                },
                                                child: const Icon(Icons
                                                    .remove_red_eye_rounded),
                                              ),
                                              suffixIconColor: obscureText
                                                  ? Colors.white
                                                      .withOpacity(0.45)
                                                  : Colors.white,
                                            ),
                                            validator: (value) {
                                              if (value!.length < 8) {
                                                return 'Password must contain 8 char';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: height(context) * 0.02,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (_authKey.currentState!
                                                    .validate() &&
                                                logIn) {
                                              setState(() {
                                                showLoader = true;
                                              });
                                              login(
                                                  context,
                                                  _emailController.text,
                                                  _passwordController.text);
                                              // Navigator.pushReplacement(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const MyMainPage()),
                                              // );
                                            } else if (_authKey.currentState!
                                                    .validate() &&
                                                !logIn) {
                                              setState(() {
                                                showLoader = true;
                                              });
                                              signup(
                                                  context,
                                                  _emailController.text,
                                                  _passwordController.text);
                                              // Navigator.pushReplacement(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const MyMainPage()),
                                              // );
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 25),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(7.5)),
                                                color: color_10),
                                            child: Text(
                                              logIn ? 'Login' : 'SignUp',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: colorBackGround,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -50,
                                    left: -20,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          logIn = !logIn;
                                        });
                                      },
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        opacity: logIn ? 1 : 0.675,
                                        child: Container(
                                          alignment: const Alignment(0, 0.5),
                                          height: height(context) * 0.15,
                                          width: width(context) * 0.575,
                                          decoration: BoxDecoration(
                                            color: colorBackGround,
                                            borderRadius: BorderRadius.all(
                                                Radius.elliptical(
                                                    width(context) * 0.575,
                                                    height(context) * 0.15)),
                                          ),
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: color_30.withOpacity(0.95),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -50,
                                    right: -20,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          logIn = !logIn;
                                        });
                                      },
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        opacity: !logIn ? 1 : 0.675,
                                        child: Container(
                                          alignment: const Alignment(0, 0.5),
                                          height: height(context) * 0.16,
                                          width: width(context) * 0.5,
                                          decoration: BoxDecoration(
                                            color: colorBackGround,
                                            borderRadius: BorderRadius.all(
                                                Radius.elliptical(
                                                    width(context) * 0.5,
                                                    height(context) * 0.16)),
                                          ),
                                          child: Text(
                                            'SignUp',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: color_30.withOpacity(0.95),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : SizedBox(
                                height: height(context) * 0.5,
                                width: width(context) * 0.85,
                                child: Form(
                                  key: _dataKey,
                                  child: ListView(
                                    children: [
                                      SizedBox(
                                        height: height(context) * 0.01,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Additional Details',
                                          style: TextStyle(
                                              color: colorBackGround,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height(context) * 0.015,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        padding: const EdgeInsets.only(
                                            bottom: 1.0, right: 10, left: 15),
                                        decoration: BoxDecoration(
                                          color:
                                              colorBackGround.withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: TextFormField(
                                          controller: _collegeController,
                                          cursorColor: colorBackGround,
                                          autocorrect: false,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: colorBackGround
                                                  .withOpacity(0.95)),
                                          decoration: InputDecoration(
                                            labelText: 'College Name ',
                                            labelStyle: TextStyle(
                                                color: colorBackGround),
                                            hintText: '',
                                            border: InputBorder.none,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Enter the college name...';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        padding: const EdgeInsets.only(
                                            bottom: 1.0, right: 10, left: 15),
                                        decoration: BoxDecoration(
                                          color:
                                              colorBackGround.withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: TextFormField(
                                          controller: _departmentController,
                                          cursorColor: colorBackGround,
                                          autocorrect: false,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: colorBackGround
                                                  .withOpacity(0.95)),
                                          decoration: InputDecoration(
                                            labelText: 'Department Name',
                                            labelStyle: TextStyle(
                                                color: colorBackGround),
                                            hintText: '',
                                            border: InputBorder.none,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Enter the dept name...';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        padding: const EdgeInsets.only(
                                            bottom: 1.0, right: 10, left: 15),
                                        decoration: BoxDecoration(
                                          color:
                                              colorBackGround.withOpacity(0.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: TextFormField(
                                          controller: _logoController,
                                          cursorColor: colorBackGround,
                                          autocorrect: false,
                                          textAlign: TextAlign.start,
                                          keyboardType: TextInputType.none,
                                          style: TextStyle(
                                              color: colorBackGround
                                                  .withOpacity(0.95)),
                                          decoration: InputDecoration(
                                            labelText: 'profile Url...',
                                            labelStyle: TextStyle(
                                                color: colorBackGround),
                                            hintText:
                                                ' Take it for internet source',
                                            hintStyle: TextStyle(
                                              color: colorBackGround
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'profile url from internet';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (_dataKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              showLoader = true;
                                            });
                                            AuthServices().setProfile(
                                                _collegeController.text,
                                                _departmentController.text,
                                                _logoController.text);
                                          }

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyMainPage()),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: width(context) * 0.3,
                                              vertical: 20),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(7.5)),
                                            color: colorBackGround
                                                .withOpacity(0.45),
                                          ),
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                              fontSize: 22.5,
                                              color: colorBackGround,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: showLoader,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width(context) * 0.71 - 100,
                    vertical: height(context) * 0.6 - 100),
                height: height(context),
                width: width(context),
                color: color_10.withOpacity(0.5),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    color: color_30,
                    backgroundColor: colorBackGround.withOpacity(0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void login(BuildContext context, String email, password) async {
    final authServices = AuthServices();

    try {
      await authServices.signInWithEmailAndPassword(email, password);
      setState(() {
        showLoader = false;
        authServices.getProfileData();
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyMainPage()),
      );
    } catch (e) {
      setState(() {
        showLoader = false;
      });
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                icon: const Icon(
                  Icons.network_check_rounded,
                  size: 30,
                ),
                iconColor: Colors.redAccent,
                title: Text(
                  '$e',
                  style: TextStyle(
                      color: color_30,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ));
    }
  }

  void signup(BuildContext context, String email, password) async {
    final authServices = AuthServices();

    try {
      await authServices.signUpWithEmailAndPassword(email, password);
      setState(() {
        showLoader = false;
        data = false;
        authServices.getProfileData();
      });

    } catch (e) {
      setState(() {
        showLoader = false;
      });
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                icon: const Icon(
                  Icons.network_check_rounded,
                  size: 30,
                ),
                iconColor: Colors.redAccent,
                title: Text(
                  '$e',
                  style: TextStyle(
                      color: color_30,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ));
    }
  }
}
