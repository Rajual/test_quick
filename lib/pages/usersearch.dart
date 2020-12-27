import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_quick/models/database.dart';
import 'package:test_quick/models/login_state.dart';
import 'package:test_quick/pages/chats.dart';

class UserSearch extends StatefulWidget {
  UserSearch({Key key}) : super(key: key);

  @override
  _UserSearchState createState() => _UserSearchState();
}

num _number = 0;
Stream<QuerySnapshot> _query;

class _UserSearchState extends State<UserSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //Stack me permite apilar Widget sobre Widget de esta forma coloco el fondo y el logo
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              child: TextField(
                onChanged: (value) {
                  print(value);
                  setState(() {
                    _number = value.length;

                    _query = FirebaseFirestore.instance
                        .collection('user')
                        .where('displayName',
                            isGreaterThanOrEqualTo: value.toLowerCase())
                        .snapshots();
                  });
                },
                decoration: new InputDecoration(
                    icon: Icon(Icons.search), labelText: 'Usuario a buscar'),
                autocorrect: false,
              ),
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _query,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshat) {
                    if (snapshat.hasData) {
                      DatabaseMethods().getUsers();
                      List names = snapshat.data.docs.map((e) {
                        return e['displayName'];
                      }).toList();
                      List linkPhoto = snapshat.data.docs.map((e) {
                        return e['photoURL'];
                      }).toList();
                      List email = snapshat.data.docs.map((e) {
                        return e['email'];
                      }).toList();
                      print(linkPhoto.toList());
                      return ListView.separated(
                        itemCount: snapshat.data.size,
                        itemBuilder: (context, index) => Card(
                          child: _item(
                            linkPhoto[index],
                            names[index],
                            email[index],
                          ),
                        ),
                        /*_item(Icons.phone_android, 'Shopping', 14, 145.12)*/
                        separatorBuilder: /*(BuildContext context, int index) => Divider(),*/
                            (context, index) {
                          return Container(
                            color: Colors.blueAccent.withOpacity(0.15),
                            height: 1,
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }))
        ],
      ),
    );
  }

  Widget _item(String linkPhoto, String name, String email) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ListTile(
        leading: StatefulBuilder(
          builder: (context, setState) {
            return MaterialButton(
              onPressed: () {
                setState(() {
                  DatabaseMethods().createChat(
                      Provider.of<LoginState>(context, listen: false)
                          .user
                          .email,
                      email);
                  DatabaseMethods().searchChat(
                      Provider.of<LoginState>(context, listen: false)
                          .user
                          .email,
                      email);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contest) => Chats(
                                name: name,
                                email: email,
                                linkPhoto: linkPhoto,
                              )));
                });
              },
              minWidth: 0,
              child: CircleAvatar(
                  radius: 25.0,
                  backgroundImage:
                      linkPhoto != '' ? NetworkImage(linkPhoto) : null),
            );
          },
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          email,
          style: TextStyle(fontSize: 10.0, color: Colors.blueGrey),
        ),
        trailing: Padding(
          padding: const EdgeInsets.all(1),
          child: Icon(Icons.send),
        ),
      ),
    );
  }
}
