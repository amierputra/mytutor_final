// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:smarttutor/constants.dart';
import 'package:smarttutor/models/user.dart';
import 'package:smarttutor/main.dart';
import 'package:smarttutor/screens/favourites.dart';
import 'package:smarttutor/screens/login.dart';
import 'package:smarttutor/screens/profile.dart';
import 'package:smarttutor/screens/subjects.dart';
import 'package:smarttutor/screens/subscribes.dart';
import 'package:smarttutor/screens/tutors.dart';

class MainScreen extends StatefulWidget {
  final Users user;
  const MainScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  late List<Widget> _pages;
  late Widget _page1, _page2, _page3, _page4, _page5;
  late Widget _currentPage;
  String text = '';
  String text1 = "Subjects";
  String text2 = "Tutors";
  String text3 = "Subscribe";
  String text4 = "Favourite";
  String text5 = "Profile";

  @override
  void initState() {
    super.initState();

    _page1 = SubjectPage();
    _page2 = TutorPage();
    _page3 = SubscribePage();
    _page4 = FavouritePage();
    _page5 = ProfilePage(
      user: widget.user,
    );
    _pages = [_page1, _page2, _page3, _page4, _page5];
    _selectedIndex = 0;
    _currentPage = _page1;
    text = text1;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentPage = _pages[index];

      switch (index) {
        case 0:
          text = text1;
          break;

        case 1:
          text = text2;
          break;

        case 2:
          text = text3;
          break;

        case 3:
          text = text4;
          break;

        case 4:
          text = text5;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SmartTutor',style: TextStyle(fontWeight: FontWeight.bold)
        ),
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.library_books,
                ),
                label: "Subjects"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.co_present,
                ),
                label: "Tutors"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.assignment_turned_in,
                ),
                label: "Subscribe"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                ),
                label: "Favourites"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                ),
                label: "Profile"),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            _onItemTapped(index);
          }),
    );
  }
}
