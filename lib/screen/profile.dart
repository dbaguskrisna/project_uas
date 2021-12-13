import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  final String email;
  Profile({Key key, @required this.email}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<Profile> {
  User pm;
  String _temp = 'waiting API respond…';

  final _controllerdate = TextEditingController();

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718049/edit_user.php"),
        body: {'email': widget.email.toString()});

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      pm = User.fromJson(json['data']);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
    main();
  }

  Future onGoBack(dynamic value) {
    print("masuk goback");
    setState(() {
      bacaData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          width: double.infinity,
          child: Text('Profile',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
        ),
        Align(
          alignment: Alignment.center,
          child: Image.network("https://ubaya.fun/flutter/160718049/images/" +
              pm.iduser.toString() +
              ".jpg"),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              pm.fullname,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              pm.date,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: new EdgeInsets.all(10.0),
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.pushNamed(context, "editProfile").then(onGoBack);
                },
                child:
                    Text("Edit Profile", style: TextStyle(color: Colors.white)),
              ),
            ),
            Padding(
              padding: new EdgeInsets.all(10.0),
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  doLogout();
                },
                child: Text("Sign Out", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
