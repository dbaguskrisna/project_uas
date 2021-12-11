import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_1/class/popMovie.dart';
import 'package:http/http.dart' as http;

class Favorite extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

List<PopMovie> PMs = [];

class _MyAppState extends State<Favorite> {
  String _temp = 'waiting API respond…';
  String _txtcari = "";

  Future<String> fetchData() async {
    final response = await http
        .post(Uri.parse("https://ubaya.fun/flutter/160718049/hello.php"));
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
          itemCount: PopMovs.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                elevation: 4.0,
                child: Column(children: [
                  ListTile(
                    title: Text(PopMovs[index].title),
                    subtitle: Text("subheading"),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.disabled_by_default_outlined,
                      ),
                      splashColor: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    height: 150.0,
                    child: Ink.image(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1582719508461-905c673771fd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1025&q=80"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(PopMovs[index].overview),
                  ),
                  ButtonBar(
                    children: [
                      TextButton(
                        child: const Text('DETAIL'),
                        onPressed: () {/* ... */},
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
              "Your Favorite",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 230,
            child: DaftarPopMovie(PMs),
          )
        ],
      ),
    );
  }
}
