import 'package:flutter/material.dart';

class AddPlace extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<AddPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Halaman Add Place'),
      ),
    );
  }
}
