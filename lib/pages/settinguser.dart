import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_quick/models/login_state.dart';
import 'package:test_quick/services/database.dart';

class SettingUser extends StatefulWidget {
  SettingUser({Key key, this.uid}) : super(key: key);
  final String uid;
  @override
  _SettingUserState createState() => _SettingUserState();
}

class _SettingUserState extends State<SettingUser> {
  TextEditingController _name = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  String imageURL = '';
  String _image = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('user')
                .doc(widget.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshat) {
              if (snapshat.hasData) {
                String name = snapshat.data.data()['displayName'];
                String linkPhoto = snapshat.data.data()['photoURL'];
                String lastName = snapshat.data.data()['lastName'];
                print(name);

                return _item(context, linkPhoto, name, lastName);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }

  Widget _item(
      BuildContext context, String linkPhoto, String name, String lastName) {
    return StatefulBuilder(builder: (context, setState) {
      _name.text = name;
      _lastName.text = lastName;
      return Column(
        children: <Widget>[
          MaterialButton(
            onPressed: () async {
              await getImage();
            },
            child: CircleAvatar(
              radius: 100,
              backgroundImage: _image == ''
                  ? NetworkImage(linkPhoto)
                  : FileImage(File(_image)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _name,
                  ),
                  TextFormField(
                    controller: _lastName,
                  )
                ],
              ),
            ),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('CANCELAR'),
                onPressed: () {},
              ),
              FlatButton(
                child: Text('GUARDAR'),
                onPressed: () async {
                  if (_image != '') {
                    await updateImage();
                    Map<String, dynamic> mapUser = {
                      //'displayName': _name.text.toLowerCase(),
                      //'lastName': _lastName.text,
                      'photoURL': imageURL,
                      // 'email': 'user.email'
                    };
                    await DatabaseMethods().uploadUserInfo(widget.uid, mapUser);
                  }
                  Map<String, dynamic> mapUser = {
                    'displayName': _name.text.toLowerCase(),
                    'lastName': _lastName.text,
                    //'photoURL': imageURL,
                    // 'email': 'user.email'
                  };
                  await DatabaseMethods().uploadUserInfo(widget.uid, mapUser);
                },
              )
            ],
          )
        ],
      );
    });
  }

  Future getImage() async {
    await ImagePicker().getImage(source: ImageSource.gallery).then((value) {
      setState(() {
        _image = value.path.toString();
        print('Imagen: $_image');
      });
    });
  }

  Future updateImage() async {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('image/${_image.split('/').last}');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(_image));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    await taskSnapshot.ref.getDownloadURL().then((value) {
      setState(() {
        imageURL = value;
      });
    });
  }
}
