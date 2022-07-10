// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:smarttutor/main.dart';
import 'package:smarttutor/screens/cartscreen.dart';
import 'package:smarttutor/screens/login.dart';
import 'package:smarttutor/screens/mainscreen.dart';
import 'package:smarttutor/constants.dart';
import 'package:smarttutor/models/subject.dart';
import 'package:smarttutor/models/user.dart';
import 'package:smarttutor/screens/register.dart';

class SubjectPage extends StatefulWidget {
  final Users user;
  const SubjectPage({Key? key, required this.user}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Subject> subjectList = <Subject>[];
  var titlecenter = "Loading Subjects..";
  int _currentIndex = 0;
  String maintitle = "Subjects";
  late double screenHeight, screenWidth, resWidth;

  TextEditingController searchController = TextEditingController();
  String search = "";
  @override
  void initState() {
    super.initState();
    _loadSubjects(search);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartTutor',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          TextButton.icon(
            onPressed: () async {
              if (widget.user.useremail == "guest@amputra.com") {
                _loadOptions();
              } else {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CartScreen(
                              user: widget.user,
                            )));
                _loadSubjects(search);
                _loadMyCart();
              }
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            label: Text(widget.user.cart.toString(),
                style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: subjectList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            )
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 18, 0, 10),
                  child: Text("Subject",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: GestureDetector(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (1 / 1.25),
                      children: List.generate(subjectList.length, (index) {
                        return Card(
                            child: Column(
                          children: [
                            Flexible(
                              flex: 6,
                              child: CachedNetworkImage(
                                imageUrl: CONSTANTS.server +
                                    "/mytutor/mobile/assets/courses/" +
                                    subjectList[index].subject_id.toString() +
                                    ".png",
                                fit: BoxFit.cover,
                                width: screenWidth,
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Flexible(
                              flex: 6,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          subjectList[index]
                                              .subject_name
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: resWidth * 0.045,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("RM " +
                                            double.parse(subjectList[index]
                                                    .subject_price
                                                    .toString())
                                                .toStringAsFixed(2)),
                                        Text("Rating: " +
                                            subjectList[index]
                                                .subject_rating
                                                .toString()),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: IconButton(
                                          onPressed: () {
                                            _addtocartDialog(index);
                                          },
                                          icon:
                                              const Icon(Icons.shopping_cart))),
                                ],
                              ),
                            ),
                          ],
                        ));
                      }),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Subjects";
      }
      if (_currentIndex == 1) {
        maintitle = "Tutors";
      }
      if (_currentIndex == 2) {
        maintitle = "Subscribe";
      }
      if (_currentIndex == 3) {
        maintitle = "Favourites";
      }
      if (_currentIndex == 4) {
        maintitle = "Profile";
      }
    });
  }

  void _loadSubjects(String _search) {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/loadsubject.php"),
        body: {
          'search': _search,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['subjects'] != null) {
          subjectList = <Subject>[];
          extractdata['subjects'].forEach((v) {
            subjectList.add(Subject.fromJson(v));
          });
          titlecenter = subjectList.length.toString() + " Subjects Available";
        } else {
          titlecenter = "No Subject Available";
          subjectList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Subject Available";
        subjectList.clear();
        setState(() {});
      }
    });
  }

  void _loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            title: const Text(
              "Search",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter the name of subject',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: searchController.clear,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadSubjects(search);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text("Search"),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _addtocartDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            insetPadding: const EdgeInsets.all(70),
            buttonPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Center(
              child: Text(
                "Add to Cart",
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Add item to cart?'),
              ],
            ),
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.limeAccent),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _addtoCart(index);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.lime,
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: const Text(
                            "No",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.lime,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  _loadOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Please select",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: _onLogin, child: const Text("Login")),
                ElevatedButton(
                    onPressed: _onRegister, child: const Text("Register")),
              ],
            ),
          );
        });
  }

  void _onLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginPage()));
  }

  void _onRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const RegisterPage()));
  }

  void _addtoCart(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/insert_cart.php"),
        body: {
          "email": widget.user.useremail.toString(),
          "subjectid": subjectList[index].subject_id.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _loadMyCart() {
    if (widget.user.useremail != "guest@slumberjer.com") {
      http.post(
          Uri.parse(
              CONSTANTS.server + "/mytutor/mobile/php/load_mycartqty.php"),
          body: {
            "email": widget.user.useremail.toString(),
          }).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      ).then((response) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (response.statusCode == 200 && jsondata['status'] == 'success') {
          print(jsondata['data']['carttotal'].toString());
          setState(() {
            widget.user.cart = jsondata['data']['carttotal'].toString();
          });
        }
      });
    }
  }
}
