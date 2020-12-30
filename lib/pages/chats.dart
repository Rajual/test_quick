import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_quick/models/database.dart';
import 'package:test_quick/models/login_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Chats extends StatefulWidget {
  final String email;

  final String name;

  final String linkPhoto;

  final String chatID;

  Chats({Key key, this.name, this.email, this.linkPhoto, this.chatID})
      : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  TextEditingController message = TextEditingController();
  ScrollController _scrollController = ScrollController();

  String _image = '';

  String m = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(1),
              child: ListTile(
                leading: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: widget.linkPhoto != ''
                        ? NetworkImage(widget.linkPhoto)
                        : null),
                title: Text(
                  widget.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text(
                  widget.email,
                  style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(widget.chatID)
                          .collection('chat')
                          .orderBy('time', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshat) {
                        if (snapshat.hasData) {
                          print(snapshat.data);
                          List message = snapshat.data.docs.map((e) {
                            return e['message'];
                          }).toList();
                          List sendBy = snapshat.data.docs.map((e) {
                            return e['sendBy'];
                          }).toList();
                          return Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: snapshat.data.docs.length,
                              itemBuilder: (context, index) {
                                return stileMessage(
                                    message[index], sendBy[index]);
                              },
                            ),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                  Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: StatefulBuilder(builder: (context, setStat) {
                          return Column(
                            //Prueba de superposicción de imagen.
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            _image = '';
                                          });
                                        },
                                        child: Container(
                                            child: _image == ''
                                                ? null
                                                : Icon(Icons.close))),
                                    Container(
                                      child: _image != ''
                                          ? Image.file(
                                              File(_image),
                                              height: 100,
                                            )
                                          : null,
                                    )
                                  ],
                                ),
                              ),
                              //Icon(Icons.ac_unit),
                              //Text(m),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: message,
                                      onChanged: (value) {},
                                      decoration: new InputDecoration(
                                          labelText: 'Escribe...'),
                                      autocorrect: true,
                                    ),
                                  ),
                                  MaterialButton(
                                      minWidth: 0,
                                      padding: EdgeInsets.all(1.0),
                                      onPressed: () async {
                                        await getImage();
                                      },
                                      child: Icon(Icons.image, size: 30)),
                                  MaterialButton(
                                      padding: EdgeInsets.all(1.0),
                                      minWidth: 0,
                                      onPressed: () {
                                        setState(() {});
                                        DatabaseMethods().sendMessage(
                                            message.text,
                                            Provider.of<LoginState>(context,
                                                    listen: false)
                                                .user
                                                .email,
                                            widget.chatID);
                                        message.clear();
                                        _scrollController.jumpTo(
                                            _scrollController
                                                    .position.maxScrollExtent +
                                                156);
                                        updateImage();
                                      },
                                      child:
                                          Icon(Icons.send_rounded, size: 30)),
                                ],
                              ),
                            ],
                          );
                        }),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////
  Future getImage() async {
    await ImagePicker().getImage(source: ImageSource.gallery).then((value) {
      setState(() {
        _image = value.path.toString();
        print('Imagen: $_image');
      });
    });
  }

  updateImage() async {
    /*basename();
    print(_image);
    if (_image != '') {
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('update/imagen');
      UploadTask uploadTask = firebaseStorageRef.putFile(File(_image));

      print('Resultado: $uploadTask');
    }*/
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(_image);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(File(_image));
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print(taskSnapshot);
  }

  ///

  Widget stileMessage(String message, String sendBy) {
    bool isMyMessage =
        (Provider.of<LoginState>(context, listen: false).user.email == sendBy);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: isMyMessage
          ? EdgeInsets.only(left: 40, right: 1)
          : EdgeInsets.only(left: 1, right: 40),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.2),
            borderRadius: isMyMessage
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
//              bottomRight: Radius.circular(23),
                    topRight: Radius.circular(23),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
//              bottomLeft: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                    topRight: Radius.circular(23),
                  )),
        child: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ),
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
