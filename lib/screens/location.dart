import 'package:country_state_city_picker_2/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../colors.dart';
import '../function.dart';
import 'AuthScreen.dart';
import 'MyHomePage.dart';

class MyLocationSearch extends StatefulWidget {
  const MyLocationSearch({super.key});

  @override
  State<MyLocationSearch> createState() => _MyLocationSearchState();
}

class _MyLocationSearchState extends State<MyLocationSearch> {
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';
  List<String> cityTable = [];
  bool found = false, searchLoader = false;

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
      body: Container(
        width: width(context),
        height: height(context) * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(1),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                blurRadius: 5,
              ),
            ],
            color: mode ? const Color(0xffFFF7FC) : const Color(0xff3f3d56)),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    cityValue = '';
                    cityTable = [];
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                },
                color: mode ? const Color(0xff3f3d56) : const Color(0xffFFF7FC),
                icon: const Icon(Icons.clear),
              ),
            ),
            SelectState(
              spacing: 20,
              dropdownColor:
                  mode ? const Color(0xffFFF7FC) : const Color(0xff3f3d56),
              decoration: InputDecoration(
                fillColor:
                    mode ? const Color(0xffFFF7FC) : const Color(0xff3f3d56),
              ),
              style: TextStyle(
                  backgroundColor:
                      !mode ? const Color(0xffFFF7FC) : const Color(0xff3f3d56),
                  color:
                      mode ? const Color(0xff3f3d56) : const Color(0xffFFF7FC)),
              onCountryChanged: (value) {
                setState(() {
                  countryValue = value;
                });
              },
              onStateChanged: (value) {
                setState(() {
                  stateValue = value;
                });
              },
              onCityChanged: (value) {
                setState(() {
                  cityValue = value;
                });
              },
            ),
            GestureDetector(
              onTap: () {
                if (cityValue.isEmpty) {
                  showToast('Set the location');
                } else {
                  setState(() {
                    searchLoader = true;
                  });
                  cityTable = [];
                  for (var sentance in tableValue) {
                    if (sentance.toString().toLowerCase().contains(
                        cityValue.split(' ')[0].toString().toLowerCase())) {
                      setState(() {
                        found = true;
                        setState(() {
                          cityTable.add(sentance);

                          searchLoader = false;
                        });
                      });
                    }
                  }
                  if (!found) {
                    showToast('Candidate not founded');
                    searchLoader = false;
                  }
                  showToast(
                      '${cityTable.length} candidate founded in $cityValue');
                }
              },
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 20, horizontal: width(context) * 0.25),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(7.5)),
                      color: color_30),
                  child: const Text(
                    'search',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width(context),
              height: height(context) * 0.445,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  cityTable.isEmpty
                      ? Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/images/search.svg',
                            height: 125,
                          ),
                        )
                      : Container(
                          width: width(context),
                          height: height(context) * 0.445,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: color_10.withOpacity(0.35),
                          ),
                          child: ListView.builder(
                            itemCount: cityTable.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Text(
                                    cityTable[index],
                                    style: TextStyle(
                                        color: mode
                                            ? const Color(0xff3f3d56)
                                            : const Color(0xffFFF7FC)),
                                  ),
                                  Divider(
                                    color: color_30.withOpacity(0.5),
                                    thickness: 2,
                                  )
                                ],
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
              ),
            ),
            // SizedBox(
            //   width: width(context),
            //   height: height(context) * 0.45,
            //   child: ListView.builder(
            //       itemCount: cityTable.isEmpty ? 1 : cityTable.length,
            //       itemBuilder: (context, index) {
            //         return Column(
            //           children: [
            //             if (cityTable.isNotEmpty)
            //               Align(
            //                 alignment: Alignment.center,
            //                 child: SvgPicture.asset(
            //                   'assets/images/location.svg',
            //                   height: 125,
            //                 ),
            //               ),
            //             Text(
            //               '${cityTable[1]}',
            //               style: TextStyle(
            //                   color: mode
            //                       ? const Color(0xff3f3d56)
            //                       : const Color(0xffFFF7FC)),
            //             ),
            //             Divider(
            //               color: mode
            //                   ? const Color(0xff3f3d56)
            //                   : const Color(0xffFFF7FC),
            //               thickness: 5,
            //             )
            //           ],
            //         );
            //       }),
            // )
          ],
        ),
      ),
    );
  }
}
