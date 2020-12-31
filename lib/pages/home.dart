import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:test_quick/models/login_state.dart';
//import 'package:test_quick/pages/login.dart';

import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_quick/pages/settinguser.dart';
import 'package:test_quick/pages/usersearch.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Controler PageView
  PageController _controller;
  int currentPage = 3;
  Stream<QuerySnapshot> _query;
  DatabaseReference dBRef = FirebaseDatabase.instance.reference().child('/');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller =
        PageController(initialPage: currentPage, viewportFraction: 0.4);

    print('Flutter Web');

    _query = FirebaseFirestore.instance
        .collection('devices')
        .where('adminsUsers', arrayContains: 'users/wSWPvgNo3fbHpoEDnOjd')
        .snapshots();
  }

  /*Future<DocumentSnapshot> getData() async {
    CollectionReference user = FirebaseFirestore.instance.collection('Consumo');

    return await user.doc('g0S31jOVLbpjriGTwODs').get();
  }*/

  Widget _bottomAction(IconData icon, Function callback) {
    return InkWell(
      child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(icon)),
      onTap: callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
          child: SettingUser(
              uid: Provider.of<LoginState>(context, listen: false).user.uid)),
      drawer: Drawer(
        child: UserSearch(),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //_bottomAction(null, () {}),
            //_bottomAction(null, () {}),
            _bottomAction(Icons.arrow_back, () {
              Provider.of<LoginState>(context, listen: false).logout();
            }),
            SizedBox(
              width: 90.0,
            ),
            _bottomAction(Icons.settings, () {
              _scaffoldKey.currentState.openEndDrawer();
            }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          }),
      body: _body(),
    );
  }

  num indiceFactor = 1;
  Map<num, num> fCoste = {0: 1, 1: 1};
  Map<num, String> UnidadEnergy = {0: '\$', 1: 'KWH'};
  Map<num, String> UnidadPower = {0: '\$/H', 1: 'KW'};
  Widget _body() {
    return SafeArea(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(1),
          child: ListTile(
            leading: StatefulBuilder(
              builder: (context, setState) {
                return MaterialButton(
                  onPressed: () {
                    setState(() {});
                  },
                  minWidth: 0,
                  child: CircleAvatar(radius: 25.0, backgroundImage: null
                      /* linkPhoto != '' ? NetworkImage(linkPhoto) : null*/),
                );
              },
            ),
            title: Text(
              'GrupChat',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(
              '${1000}' + ' ',
              style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
            ),
            trailing: Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  '${1000}' + ' ',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ),
          ),
        ),
        /* StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshat) {
              print(snapshat.hasData);
              if (snapshat.hasData) {
                print('snapshat.data');
                print(snapshat.data.docs.first['adminsUsers']);
                print('snapshat.data');
/*                 var resq = snapshat.data.snapshot;

                Map<dynamic, dynamic> values = resq.value;
                print('values');
                print(values['Coste']);
                fCoste[0] = values['Coste'];
                return ViewWidget(
                  data: values['Groups'],
                  factor: fCoste[indiceFactor],
                  unidadEnergy: UnidadEnergy[indiceFactor],
                  unidadPower: UnidadPower[indiceFactor],
                ); */
//                print(widget.user);
//                print(snapshat.data.data());
//                 var resq = snapshat.data.data();
/*
                Map<dynamic, dynamic> values = snapshat.data.data();
                print('values');
                print(values['Coste']);
                fCoste[0] = values['Coste'];
                return ViewWidget(
                  data: values,
                  factor: fCoste[indiceFactor],
                  unidadEnergy: UnidadEnergy[indiceFactor],
                  unidadPower: UnidadPower[indiceFactor],
                );*/
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            })*/
      ],
    ));
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            currentPage = newPage;
            print(currentPage);
            switch (currentPage) {
              case 0:
//                print();
                indiceFactor = 0;
                break;
              case 1:
//                print();
                indiceFactor = 1;
                break;
              default:
            }
          });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem('Vista Pesos', 0),
          _pageItem('Vista KWH', 1),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    var _alignmet;

    final selected = TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey);

    final unselected = TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.blueGrey.withOpacity(0.4));

    if (position == currentPage) {
      _alignmet = Alignment.center;
    } else if (position > currentPage) {
      _alignmet = Alignment.centerRight;
    } else {
      _alignmet = Alignment.centerLeft;
    }

    return Align(
      child: Text(
        name,
        style: position == currentPage ? selected : unselected,
      ),
      alignment: _alignmet,
    );
  }
}
