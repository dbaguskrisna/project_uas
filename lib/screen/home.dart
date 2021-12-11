import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/popMovie.dart';
import 'package:flutter_application_1/screen/favorite.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

List<PopMovie> PMs = [];

class _MyAppState extends State<Home> {
  String _temp = 'waiting API respond…';
  String _email = "";

  Future<String> fetchData() async {
    final response = await http
        .post(Uri.parse("https://ubaya.fun/flutter/160718049/villa.php"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    PMs.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      print("home: " + json['data'].toString());
      for (var mov in json['data']) {
        PopMovie pm = PopMovie.fromJson(mov);
        PMs.add(pm);
      }
      setState(() {
        _temp = PMs[2].description;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget DaftarPopMovie(PopMovs) {
    if (PopMovs != null) {
      return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: PopMovs.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                elevation: 4.0,
                child: Column(children: [
                  ListTile(
                    title: Text(PMs[index].name.toString()),
                    subtitle: Text(PMs[index].price.toString()),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.favorite_border_outlined,
                      ),
                      splashColor: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    height: 150.0,
                    child: Ink.image(
                      image: NetworkImage(PMs[index].image.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                  ButtonBar(
                    children: [
                      TextButton(
                        child: const Text('VIEW DETAIL'),
                        onPressed: () {},
                      ),
                    ],
                  )
                ]));
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Looking for a Villa in Bali ?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: DaftarPopMovie(PMs),
          )
        ],
      ),
    );
  }
}
