import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_quick/models/login_state.dart';
import 'package:test_quick/pages/home.dart';
import 'package:test_quick/pages/login.dart';

//Al contener el metodo "await" es necesario volver a la funcion, una funcion "async".
Future<void> main() async {
  //Para hacer uso de FireBase es necesario iniciar los servicios de este, por medio de Firebase.initializeApp().
  WidgetsFlutterBinding
      .ensureInitialized(); //Permite que la app no inicie ase ejecute hasta que todos los servicios se inicializen.
  await Firebase
      .initializeApp(); //Se vuelve un metodo "await" puesto que es necesario espera a que finalice de inicializar FireBase.
  //Una vez inicializado FireBase, se empieza a ejecutar la app.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Este widget es la raiz de la app.
  @override
  Widget build(BuildContext context) {
    //Por medio de este Widgetse crea el entorno donde vivira el Provider LoginState.
    //El cual se encarga de escuchar los ajustes en la autenticacion y los usuarios.
    return ChangeNotifierProvider<LoginState>(
        //Le indico que le pase el contexto del Widget build al LoginState()
        create: (context) => LoginState(),
        //Empieza a ejecutar la app por medio del Widget MaterialApp.
        child: MaterialApp(
          //Escondo la etiqueta de debug
          debugShowCheckedModeBanner: false,
          //Titulo general de la app.
          title: 'TestQuick S.A.S',
          //Escojo el color por defecto de todos mis componentes en la ventana inicial.
          theme: ThemeData(accentColor: Colors.white),
          //Creo la ruta de navegación de la app
          routes: {
            //La ruta '/' que es la ruta inicial. Puede direccionar a la ventana de LoginPage si no hay un ususario auntentiado.
            //O ir a la pestaña HomePage() si el usuario ya se ha auntenticado
            '/': (BuildContext context) {
              //Se empieza a escuchar el Povider LoginState y se almacena su valor en la variable state.
              var state = Provider.of<LoginState>(context,
                  listen:
                      true); //La variable state almacena el estado de autenticacion del usuario, junto con su información.
              //Al preguntar por el parametro state.loggedIn se sabe si redireccionar a la LoginPage o a la HomePage.
              if (state.loggedIn) {
                //Retorna la pagina principal.
                return HomePage();
              } else {
                //Retorna la pagina de login.
                return LoginPage();
              }
            },
          },
        ));
  }
}
