import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_quick/models/database.dart';
import 'package:test_quick/models/login_state.dart';

class Chats extends StatefulWidget {
  final String email;

  final String name;

  final String linkPhoto;

  Chats({Key key, this.name, this.email, this.linkPhoto}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  TextEditingController message = TextEditingController();
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
              child: Stack(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(
                              'julioalfonso8003@gmail.com_julioalfono@gmail.com')
                          .collection('chat')
                          .orderBy('time', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshat) {
                        print(snapshat.data.docs);
                        List message = snapshat.data.docs.map((e) {
                          return e['message'];
                        }).toList();
                        return ListView.builder(
                          itemCount: snapshat.data.docs.length,
                          itemBuilder: (context, index) {
                            return Text(message[index]);
                          },
                        );
                      }),
                  Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: message,
                                //onChanged: (value) {},
                                decoration: new InputDecoration(
                                    labelText: 'Escribe...'),
                                autocorrect: true,
                              ),
                            ),
                            MaterialButton(
                                minWidth: 0,
                                padding: EdgeInsets.all(1.0),
                                onPressed: () {},
                                child: Icon(Icons.image, size: 30)),
                            MaterialButton(
                                padding: EdgeInsets.all(1.0),
                                minWidth: 0,
                                onPressed: () {
                                  DatabaseMethods().sendMessage(
                                      message.text,
                                      Provider.of<LoginState>(context,
                                              listen: false)
                                          .user
                                          .email,
                                      widget.email);
                                  message.clear();
                                },
                                child: Icon(Icons.send_rounded, size: 30)),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
