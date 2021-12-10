import 'package:flutter/material.dart';

class RegisterProfile extends StatelessWidget {
  const RegisterProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Register';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  String _email = "";
  String _password = "";
  String _name = "";

  final _controllerdate = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(15),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your Fullname',
                ),
                onChanged: (value) {
                  _name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'fullname can not be empty';
                  }
                  return null;
                },
              )),
          Padding(
              padding: EdgeInsets.all(15),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Expanded(
                    child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Birth Date',
                  ),
                  controller: _controllerdate,
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
          Padding(
              padding: EdgeInsets.all(15),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: (value) {
                  _email = value;
                },
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
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                onChanged: (value) {
                  _password = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'password can not be empty';
                  }
                  return null;
                },
              )),
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
              child: const Text('Register Data'),
            ),
          ),
        ],
      ),
    );
  }
}
