//SplashScreen reutilizable

/*return SplashScreen(
                    title: 'TestQuick S.A.S',
                    color: Color(0xFFFCD404),
                    imagen: AssetImage('assets/icon/Quick.png'),
                    subtitle: 'Bienvenido :)');*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title, this.color, this.imagen, this.subtitle})
      : super(key: key);

  final String title;
  final Color color;
  final AssetImage imagen;
  final String subtitle;

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Stack me permite apilar Widget sobre Widget de esta forma coloco el fondo y el logo
      body: Stack(
        //Al cargar la propiedad fit con StackFit.expand, los Widget con tamaño no definido se expanden al maximo tamaño posible
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: widget.color),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 65.0,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(image: widget.imagen)),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      Padding(padding: EdgeInsets.only(top: 10.0)),
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
