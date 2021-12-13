import 'dart:convert';
import 'package:image_picker/image_picker.dart';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/class/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

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
  String urlImage = "";
  File _image = null;
  File _imageProses = null;

  TextEditingController _emailCont = new TextEditingController();
  TextEditingController _fullnameCont = new TextEditingController();
  TextEditingController _birthDate = new TextEditingController();

  String _user = "";

  @override
  void initState() {
    super.initState();

    bacaDataEdit();
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
  void bacaDataEdit() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      print(json);
      pm = User.fromJson(json['data']);
      setState(() {
        _emailCont.text = pm.email;
        _fullnameCont.text = pm.fullname;
        _birthDate.text = pm.date;
        urlImage = pm.image;
      });
    });
  }

  void submit() async {
    print("halo" + pm.fullname);
    print("tanggal" + pm.date.toString());
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160718049/update_user.php"),
        body: {
          'fullname': pm.fullname,
          'birth_date': _birthDate.text.toString(),
          'email': widget.email.toString(),
        });
    if (response.statusCode == 200) {
      print(response.body);

      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses mengubah Data')));
      }
      List<int> imageBytes = _image.readAsBytesSync();
      print(imageBytes);
      String base64Image = base64Encode(imageBytes);
      final response2 = await http.post(
          Uri.parse(
            'https://ubaya.fun/flutter/160718049/upload_image2.php',
          ),
          body: {
            'id': pm.iduser.toString(),
            'image': base64Image,
          });
      if (response2.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response2.body)));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  void prosesFoto() {
    Future<Directory> extDir = getExternalStorageDirectory();
    extDir.then((value) {
      String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = value.path + '/${_timestamp()}.jpg';
      _imageProses = File(filePath);
      img.Image temp = img.readJpg(_image.readAsBytesSync());
      img.Image temp2 = img.copyResize(temp, width: 200, height: 200);
      setState(() {
        _imageProses.writeAsBytesSync(img.writeJpg(temp2));
      });
    });
  }

  _imgGaleri() async {
    final picker = ImagePicker();
    final image = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 200,
        maxWidth: 200);
    setState(() {
      _image = File(image.path);
      prosesFoto();
    });
  }

  _imgKamera() async {
    final picker = ImagePicker();
    final image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 20);
    setState(() {
      _image = File(image.path);
      prosesFoto();
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      tileColor: Colors.white,
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeri'),
                      onTap: () {
                        _imgGaleri();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Kamera'),
                    onTap: () {
                      _imgKamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
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
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(20),
                  child: _imageProses != null
                      ? Image.file(_imageProses)
                      : Image.network(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                  height: 200,
                  width: 200,
                ),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Text(
                        "Change Image",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )),
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
                                    _birthDate.text =
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
                      if (!_formKey.currentState.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Harap Isian diperbaiki')));
                      } else {
                        submit();
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
