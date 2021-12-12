import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/addplace.dart';
import 'package:flutter_application_1/screen/editprofile.dart';
import 'package:flutter_application_1/screen/favorite.dart';
import 'package:flutter_application_1/screen/home.dart';
import 'package:flutter_application_1/screen/login.dart';
import 'package:flutter_application_1/screen/profile.dart';
import 'package:flutter_application_1/screen/register.dart';
import 'package:flutter_application_1/screen/viewdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("email") ?? '';
  return user_id;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'HaloBook'),
      routes: {
        'addPlace': (context) => AddPlace(),
        'editProfile': (context) => EditProfile(
              email: active_user,
            ),
        'register': (context) => RegisterProfile(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  List<Widget> _screens = [Home(), Favorite(), Profile()];
  List<String> _title = ['Home', 'Screen', 'History'];

  Widget bottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      fixedColor: Colors.teal,
      items: [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(
            Icons.home,
            color: Colors.blue,
          ),
        ),
        BottomNavigationBarItem(
          label: "Favorite",
          icon: Icon(
            Icons.favorite,
            color: Colors.blue,
          ),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: Icon(
            Icons.person,
            color: Colors.blue,
          ),
        ),
      ],
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: bottomNavigation());
  }
}
