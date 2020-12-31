import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_quick/services/database.dart';
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

  String imageURL = '';
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
                          List imageURL = snapshat.data.docs.map((e) {
                            return e['imageURL'];
                          }).toList();
                          return Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: snapshat.data.docs.length,
                              itemBuilder: (context, index) {
                                return stileMessage(message[index],
                                    sendBy[index], imageURL[index]);
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
                            //Prueba de superposición de imagen.
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: _image == ''
                                          ? null
                                          : MaterialButton(
                                              onPressed: () {
                                                setState(() {
                                                  _image = '';
                                                });
                                              },
                                              child: Icon(Icons.close)),
                                    ),
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
                                      onPressed: () async {
                                        setState(() {});
                                        if (_image != '') {
                                          await updateImage();
                                        }
                                        DatabaseMethods().sendMessage(
                                            message.text,
                                            Provider.of<LoginState>(context,
                                                    listen: false)
                                                .user
                                                .email,
                                            widget.chatID,
                                            imageURL);
                                        message.clear();
                                        _scrollController.jumpTo(
                                            _scrollController
                                                    .position.maxScrollExtent +
                                                156);
                                        _image = '';
                                        imageURL = '';
                                        print(imageURL);
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

  ///

  Widget stileMessage(String message, String sendBy, [String imageURL = '']) {
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
        child: Column(
          children: [
            imageURL == ''
                ? Text(
                    message,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  )
                : Column(
                    children: [
                      Container(child: Image.network(imageURL)),
                      Text(
                        message,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      )
                    ],
                  ),
          ],
        ),
      ),
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
