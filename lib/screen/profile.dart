import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          width: double.infinity,
          child: Text('Your Profile',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Email ',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Name ',
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 8.0),
          child: ElevatedButton(
            onPressed: () {
              
            },
            child: Text(
              'Update Profile',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        )
      ],
    );
  }
}
