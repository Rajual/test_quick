import 'package:flutter/material.dart';

class UserSearch extends StatefulWidget {
  UserSearch({Key key}) : super(key: key);

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextFormField(
                validator: (val) {
                  if (val.length < 2) {
                    return 'Nombre muy corto.\nUse minimo 2 caracteres';
                  }
                  if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                      .hasMatch(val)) {
                    return 'Use solo letras';
                  }
                  return null;
                },
                //controller: name,
                decoration: new InputDecoration(
                    icon: Icon(Icons.person), labelText: 'Nombre'),
                autocorrect: false,
              ),
              MaterialButton(
                child: Icon(Icons.search),
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}
