import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddReview extends StatefulWidget {
  String email;
  String idhotel;

  AddReview({Key key, @required this.email, @required this.idhotel})
      : super(key: key);
  @override
  EditPopMovieState createState() {
    return EditPopMovieState();
  }
}

class EditPopMovieState extends State<AddReview> {
  String _user = "";
  String _review = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void submit() async {
    print("review: " + _review);
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718049/add_review.php"),
        body: {
          'email': _user,
          'review': _review,
          'villa_idhotel': widget.idhotel,
        });
    print("review: " + _review);
    print("email: " + _user);

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = (prefs.getString('email') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Review"),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(" Your Account : " + _user)),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Your Review',
                      ),
                      onChanged: (value) {
                        _review = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'fullname can not be empty';
                        }
                        return null;
                      },
                    )),
                Align(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Harap Isian diperbaiki')));
                      } else {
                        submit();
                      }
                    },
                    child: const Text('Add Review'),
                  ),
                ),
              ],
            )));
  }
}
