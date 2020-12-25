import 'package:test_quick/models/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_quick/pages/splashscreen.dart';

//Dirección del loogo del Google.
final String logoGoogle = 'assets/logo/Google.png';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

bool user = true;

class _LoginPageState extends State<LoginPage> {
  //Controladores de los campos de ingreso en el Form del login.
  var password = TextEditingController();
  var email = TextEditingController();
  var name = TextEditingController();
  var lastname = TextEditingController();
  var form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    //Uso la plantilla que nos brinda el Widget Scaffold como lienzo para la pantalla de LoginPage().
    return Scaffold(
      //Creo una AppBar de color ambar con el titulo "Bienvenido...".
      appBar: new AppBar(
        backgroundColor: Colors.amber,
        title: Center(
          child: new Text('Bienvenido...'),
        ),
      ),
      //En el body por medio de el Widget Center construyo el cuerpo de la ventana.
      body: Center(
        //Utilizo un Consumer<LoginState> que escucha los cambios en LoginState.
        child: Consumer<LoginState>(
          //Al constructor 'builder' le paso como variables de entrada los parametros:
          //-context, que le indica al builder que va ejecutarse en el ambiente de la pagina LoginPage().
          //-valuer, es la variable que almacena el valor del LoginState perteneciente a la clase ChangeNotifier.
          //-child, almacena el Widget hijo que se asigna en el Consumer<LoginState> (en este caso un SingleChildScrollView(), con todo el formulario de Login)
          builder: (context, value, child) {
            //value.loading toma el valor true mientras se esta autenticando el usuario.
            if (value.loading) {
              //retorna SplashScreen()
              return SplashScreen(
                  title: 'TestQuick S.A.S',
                  color: Color(0xFFFCD404),
                  imagen: AssetImage('assets/logo/Quick.png'),
                  subtitle: 'Bienvenido :)');
            } else {
              //Retorna el SingleChildScrollView() con el formulario de Login.
              return child;
            }
          },
          //Formulario de Login y Registro
          child: SingleChildScrollView(
            //La estructura de la columna del Login es:
            //-Logo de la empresa.
            //-El formLogin con los campos de entrada del usuario
            //-Botones para indicar, si ya eres usuario o no; y el boton de login con Google.
            child: Column(
              children: [
                //Logo de la empresa.
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image(
                    height: 60,
                    width: 60,
                    image: AssetImage('assets/logo/Quick.png'),
                  ),
                ),
                //Campos de entrada
                Padding(
                  padding: EdgeInsets.all(20),
                  child: formLogin(context, user),
                ),
                //Boton de tipo de usuario nuevo o registrado
                //Boton de login con Google
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Usuario nuevo o reistrado
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            user = !user;
                          });
                        },
                        child: bottom(user),
                        color: Color(0xFFFCD404).withOpacity(0.2),
                      ),
                      //Login con Google
                      FlatButton(
                        color: Color(0xFFFCD404).withOpacity(0.2),
                        child: Row(
                          children: <Widget>[
                            Image(
                              height: 20,
                              width: 20,
                              image: AssetImage(logoGoogle),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text('Login Google'),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Provider.of<LoginState>(context, listen: false)
                              .loginGoogle(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Boton de tipo de usuario
  //Cambia de etiqueta ('Soy usuario' o 'Quiero registrarme') y de funcionalidad (Crear o Loguear)
  Widget bottom(bool user) {
    switch (user) {
      //Para usuarios registrado
      case true:
        return Text('Soy usuario');
      //Para usuarios nuevos
      case false:
        return Text('Quiero registrarme');
      default:
        return null;
    }
  }

  //Formulario de registro y login
  Widget formLogin(BuildContext context, bool user) {
    //Se asigna el valor de _textBotton depediendo si es usuario o no.
    String _textBotton = user ? 'Registrarme' : 'Ingresar';
    //Formulario de login.
    return Form(
        child: Container(
      decoration: BoxDecoration(
          color: Color(0xFFFCD404).withOpacity(0.9),
          borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: form,
              child: Column(
                children: <Widget>[
                  user
                      ? Column(
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
                              controller: name,
                              decoration: new InputDecoration(
                                  icon: Icon(Icons.person),
                                  labelText: 'Nombre'),
                              autocorrect: false,
                            ),
                            TextFormField(
                              validator: (val) {
                                if (val.length < 2) {
                                  return 'Apellido muy corto.\nUse minimo 2 caracteres';
                                }
                                if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                    .hasMatch(val)) {
                                  return 'Use solo letras';
                                }
                                return null;
                              },
                              controller: lastname,
                              decoration: new InputDecoration(
                                  icon: Icon(Icons.perm_identity),
                                  labelText: 'Apellido'),
                              autocorrect: false,
                            )
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.all(0),
                        ),
                  TextFormField(
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                              .hasMatch(val)
                          ? null
                          : 'Correo invalido';
                    },
                    controller: email,
                    decoration: new InputDecoration(
                        icon: Icon(Icons.email), labelText: 'Correo'),
                    autocorrect: false,
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val) {
                      return val.length > 6 ? null : 'Contraseña muy corta';
                    },
                    controller: password,
                    decoration: new InputDecoration(
                        icon: Icon(Icons.lock), labelText: 'Contraseña'),
                    autocorrect: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: FlatButton(
                color: Colors.white,
                child: Text(_textBotton),
                onPressed: () {
                  //Se valida si los campos de correo y contraseña, estan diliguenciados.
                  if (form.currentState.validate()) {
                    //Dependiendo si es o no usuario, se ejecuta la funcion para crear o iniciar sesión.
                    if (user) {
                      //Create useuario
                      Provider.of<LoginState>(context, listen: false)
                          .createUserEmailPassword(name.text, lastname.text,
                              email.text, password.text, context);
                    } else {
                      //Iniciar sesión.
                      Provider.of<LoginState>(context, listen: false)
                          .signInUserEmailPassword(
                              email.text, password.text, context);
                    }
                  } else {
                    //showDialog para notificar que alguno de los campos del formulario, no fueron diligenciados.
                    /* showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                              title: new Text("Notificación"),
                              content:
                                  new Text('Tienes campos sin diliguencias'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('De acuerdo!'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ));
                  */
                  }
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
