// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:smarttutor/main.dart';
import 'package:smarttutor/models/cart.dart';
import 'package:smarttutor/screens/login.dart';
import 'package:smarttutor/screens/subjects.dart';
import 'package:smarttutor/screens/mainscreen.dart';
import 'package:smarttutor/screens/register.dart';
import 'package:smarttutor/constants.dart';
import 'package:smarttutor/models/subject.dart';
import 'package:smarttutor/models/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}