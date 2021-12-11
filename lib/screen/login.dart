import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/editprofile.dart';
import 'package:flutter_application_1/screen/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

String _user_id;
String _user_password;
String error_login;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  void doLogin() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718049/uas_login.php"),
        body: {'email': _user_id, 'password': _user_password});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);

      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("email", json['email']);
        main();
      } else {
        setState(() {
          error_login = "User id atau password error";
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          height: 320,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 0),
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 10)]),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
                onChanged: (v) {
                  _user_id = v;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                onChanged: (v) {
                  _user_password = v;
                },
              ),
            ),
            if (error_login != null)
              Text(error_login, style: TextStyle(color: Colors.red)),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      doLogin();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                )),
            Container(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterProfile()),
                  );
                },
                child: new Padding(
                  padding: new EdgeInsets.all(10.0),
                  child: new Text("Don't have an account ? register here"),
                ),
              ),
            )
          ]),
        ));
  }
}
