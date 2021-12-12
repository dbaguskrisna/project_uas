import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/popMovie.dart';
import 'package:http/http.dart' as http;

class DetailPop extends StatefulWidget {
  final int idhotel;
  DetailPop({Key key, @required this.idhotel}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DetailPopState();
  }
}

class _DetailPopState extends State<DetailPop> {
  PopMovie pm;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  void delete() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718049/delete.php"),
        body: {'id': widget.idhotel.toString()});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menghapus Data')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal Menghapus Data')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718049/detailvilla.php"),
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
      pm = PopMovie.fromJson(json['data']);
      setState(() {});
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, onPrimary: Colors.white),
                  onPressed: () {},
                  child: Text('Add Review'),
                ))
          ]));
    } else {
      return CircularProgressIndicator();
    }
  }
}
