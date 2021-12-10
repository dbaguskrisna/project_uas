import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/addplace.dart';
import 'package:flutter_application_1/screen/favorite.dart';
import 'package:flutter_application_1/screen/home.dart';
import 'package:flutter_application_1/screen/profile.dart';

void main() {
  runApp(MyApp());
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
      routes: {'addPlace': (context) => AddPlace()},
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

  Widget navigationDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
          ListTile(
            title: new Text("Add Place"),
            leading: new Icon(Icons.add, size: 30),
            onTap: () {
              Navigator.popAndPushNamed(context, 'addPlace');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: navigationDrawer(),
        body: _screens[_currentIndex],
        bottomNavigationBar: bottomNavigation());
  }
}
