// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'package:smarttutor/constants.dart';
import 'package:smarttutor/models/user.dart';
import 'package:smarttutor/screens/mainscreen.dart';
import 'package:smarttutor/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double screenHeight, screenWidth, ctrwidth;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: screenHeight,
            width: ctrwidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.lime,width: 4.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                          child: Form(
                            key: _formKey,
                            child: Column(children: [
                              const Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      prefixIcon:
                                          const Icon(Icons.email_rounded),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0))),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter valid email';
                                    }
                                    bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value);

                                    if (!emailValid) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      prefixIcon:
                                          const Icon(Icons.password_sharp),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0))),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return "Password must be at least 6 characters";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                ),
                              ),
                              const SizedBox(height: 10), //gap
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: screenWidth,
                                  height: 50,
                                  child: ElevatedButton(
                                    child: const Text("LOGIN"),
                                    style: ButtonStyle(
                                        textStyle: MaterialStateProperty.all(
                                            const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        padding: MaterialStateProperty.all<
                                                EdgeInsets>(
                                            const EdgeInsets.all(16.0)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14.0),
                                        ))),
                                    onPressed: _loginUser,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10), //gap
                              const Text("Don't have an account yet?"),
                              const SizedBox(height: 10), //gap
                              SizedBox(
                                width: screenWidth / 4,
                                height: 40,
                                child: ElevatedButton(
                                  child: const Text("REGISTER"),
                                  style: ButtonStyle(
                                      textStyle: MaterialStateProperty.all(
                                          const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.all(8)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.pink),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ))),
                                  onPressed: () {
                                    _navigateToNextScreen(context);
                                  },
                                ),
                              ),
                            ]),
                          ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  void _loginUser() {
    String _email = emailController.text;
    String _password = passwordController.text;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      http.post(
          Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/login_user.php"),
          body: {"email": _email, "password": _password}).then((response) {
        print(response.body);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          Users user = Users.fromJson(data['data']);
          // String name = data['data']['name'];
          // String email = data['data']['email'];
          // String id = data['data']['id'];
          // String datereg = data['data']['datereg'];
          // String role = data['data']['role'];
          // Admin admin = Admin(
          //     name: name, email: email, id: id, role: role, datereg: datereg);

          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => MainScreen(
                        user: user,
                      )));
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      });
    }
  }
  
}
