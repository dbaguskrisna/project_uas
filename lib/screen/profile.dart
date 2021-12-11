import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<Profile> {
  final _controllerdate = TextEditingController();

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          width: double.infinity,
          child: Text('Settings',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, "editProfile");
            },
            child: new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Text("Edit Profile"),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: InkWell(
            onTap: () {
              doLogout();
            },
            child: new Padding(
              padding: new EdgeInsets.all(10.0),
              child: new Text("Sign Out"),
            ),
          ),
        ),
      ],
    );
  }
}
