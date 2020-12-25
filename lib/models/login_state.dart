import 'package:test_quick/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Modelo para el uso de Provider
class LoginState with ChangeNotifier {
  //Variables de manejo local
  bool _loggedIn = false;
  bool _loading = false;
  User _user;

  //Variables de manejo publico
  bool get loggedIn => _loggedIn;
  bool get loading => _loading;
  User get user => _user;

  //Funcion para escuchar los cambios en el Provider
  void listenChanges() {
    //Se pregunta si se pudo retornar un usuario valido.
    if (_user != null) {
      //Se retorno un usuario y se incia sesión. Estos cambios se notifican por medio del notifyListeners().
      _loggedIn = true;
      notifyListeners();
    } else {
      //No se retorno un usuario y se regresa al login. Estos cambios se notifican por medio del notifyListeners().
      _loggedIn = false;
      notifyListeners();
    }
  }

  //Funcion para login del usuario con Google
  void loginGoogle(BuildContext context) async {
    //Se hace el cambio de LoginState.loading a true, antes de iniciar la autenticacion del usuario
    _loading = true;
    //Con el metodo notifyListeners() se le notifica al ChangeNotifier que escuche un cambio, en este caso, en las variable del Provider.
    notifyListeners();

    //Se inicia sesión con Google. Y se retorna la información del usuario.
    _user = await AuthFireBase().signInGoogle(context);
    //Se hace el cambio de LoginState.loading a false, al terminar la autenticación del usuario. Sea la autenticación exitosa o no.
    _loading = false;

    //Escuhar cambios
    listenChanges();
  }

  //Funcion para crear usuario con contraseña y correo
  void createUserEmailPassword(String name, String lastname, String email,
      String password, BuildContext context) async {
    _loading = true;
    notifyListeners();

    _user = await AuthFireBase()
        .creteUser(name, lastname, email, password, context);
    _loading = false;

    //Escuhar cambios
    listenChanges();
  }

  //Funcion para iniciar sesión con correo y contraseña
  void signInUserEmailPassword(
      String email, String password, BuildContext context) async {
    _loading = true;
    notifyListeners();

    _user =
        await AuthFireBase().signInUserEmailPassword(email, password, context);
    _loading = false;

    //Escuhar cambios
    listenChanges();
  }

  //Cerrar sesión y borrar datos del usuario anterior.
  void logout() {
    _loading = true;
    notifyListeners();

    AuthFireBase().signOut();
    _loggedIn = false;
    _user = null;
    _loading = false;
    notifyListeners();
  }
}
