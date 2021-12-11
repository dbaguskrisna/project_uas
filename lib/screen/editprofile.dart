import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  String email;
  EditProfile({Key key, @required this.email}) : super(key: key);
  @override
  EditPopMovieState createState() {
    return EditPopMovieState();
  }
}

class EditPopMovieState extends State<EditProfile> {
  String _email = "";
  String _password = "";
  String _name = "";
  final _controllerdate = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailCont = new TextEditingController();
  TextEditingController _fullnameCont = new TextEditingController();
  TextEditingController _birthDate = new TextEditingController();

  String _user = "";

  @override
  void initState() {
    super.initState();

    bacaData();
  }

  Future<String> fetchData() async {
    print(_user.toString());
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718049/edit_user.php"),
        body: {'email': widget.email.toString()});

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  User pm;
  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      print(json);
      pm = User.fromJson(json['data']);
      setState(() {
        _emailCont.text = pm.email;
        _fullnameCont.text = pm.fullname;
        _birthDate.text = pm.date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      onChanged: (value) {
                        pm.email = value;
                      },
                      controller: _emailCont,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'email can not be empty';
                        }
                        return null;
                      },
                    )),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Your Fullname',
                      ),
                      onChanged: (value) {
                        pm.fullname = value;
                      },
                      controller: _fullnameCont,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'fullname can not be empty';
                        }
                        return null;
                      },
                    )),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Enter Your Birth Date',
                            ),
                            controller: _birthDate,
                          )),
                          ElevatedButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2200))
                                    .then((value) {
                                  setState(() {
                                    _controllerdate.text =
                                        value.toString().substring(0, 10);
                                  });
                                });
                              },
                              child: Icon(
                                Icons.calendar_today_sharp,
                                color: Colors.white,
                                size: 24.0,
                              ))
                        ])),
                Align(
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (!_formKey.currentState.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please check your')),
                        );
                      }
                    },
                    child: const Text('Update Data'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(_user),
                )
              ],
            )));
  }
}
