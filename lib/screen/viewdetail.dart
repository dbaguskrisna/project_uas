import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/popMovie.dart';
import 'package:flutter_application_1/screen/review.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailPop extends StatefulWidget {
  final int idhotel;
  final String email;

  DetailPop({Key key, @required this.idhotel, @required this.email})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DetailPopState();
  }
}

class _DetailPopState extends State<DetailPop> {
  HotelList pm;
  String _user;

  @override
  void initState() {
    super.initState();
    bacaData();
    _loadUser();
  }

  void delete(delete) async {
    print("idreview" + delete);
    print("idhotel" + widget.idhotel.toString());
    print("user " + _user);
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718049/delete_review.php"),
        body: {
          'idreview': delete.toString(),
          'idhotel': widget.idhotel.toString(),
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses menghapus review')));
        setState(() {
          bacaData();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tidak dapat menghapus review')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718049/detail_villa.php"),
        body: {'id': widget.idhotel.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future onGoBack(dynamic value) {
    print("masuk goback");
    setState(() {
      bacaData();
    });
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      pm = HotelList.fromJson(json['data']);

      setState(() {});
    });
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
          title: const Text('Detail of Popular Movie'),
        ),
        body: ListView(children: <Widget>[tampilData()]));
  }

  Widget tampilData() {
    if (pm != null) {
      return Card(
          elevation: 10,
          margin: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Text(pm.name.toString(), style: TextStyle(fontSize: 25)),
            Text(pm.price, style: TextStyle(fontSize: 20)),
            Image.network(pm.image),
            Padding(
                padding: EdgeInsets.all(10),
                child: Text(pm.description, style: TextStyle(fontSize: 15))),
            Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: pm.review.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Card(
                      child: Column(children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.person_outline_rounded),
                          title: Text(pm.review[index]['user'] +
                              "\n" +
                              pm.review[index]['reviewcol']),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.close,
                            ),
                            splashColor: Colors.red,
                            onPressed: () {
                              if (pm.review[index]['user'] == _user) {
                                delete(pm.review[index]['idreview'].toString());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Cannot delete review')));
                              }
                            },
                          ),
                        ),
                      ]),
                      elevation: 8,
                    );
                  },
                )),
            Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, onPrimary: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddReview(
                          email: widget.email,
                          idhotel: widget.idhotel.toString(),
                        ),
                      ),
                    ).then(onGoBack);
                  },
                  child: Text('Add Review'),
                ))
          ]));
    } else {
      return CircularProgressIndicator();
    }
  }
}
