import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_quick/models/database.dart';

class AuthFireBase {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  void showExceptio(BuildContext context, FirebaseException _ex) {
    String menssege = _ex.message;
    if (_ex.code == 'unknown') {
      menssege = 'Verifica tu conexión';
    }
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Notificación"),
              content: new Text(menssege),
              actions: <Widget>[
                FlatButton(
                  child: Text('De acuerdo!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future<User> signInGoogle(BuildContext context) async {
    var _ex;
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      final User user = userCredential.user;
//////////////
      Map<String, dynamic> mapUser = {
        'displayName': user.displayName.toLowerCase(),
        'lastName': '',
        'photoURL': user.photoURL,
        'email': user.email
      };

      DatabaseMethods().uploadUserInfo(user.uid, mapUser);
      ////////////////
      return user;
    } catch (e) {
      _ex = e;
      print(_ex.code);
    }
    String menssege = _ex.message;
    if (_ex.code == 'network_error') {
      menssege = 'Verifica tu conexión';
    }
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Notificación"),
              content: new Text(menssege),
              actions: <Widget>[
                FlatButton(
                  child: Text('De acuerdo!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
    return null;
  }

  Future<User> signInUserEmailPassword(
      String email, String password, BuildContext context) async {
    var _ex;
    try {
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user;
    } on FirebaseAuthException catch (e) {
      _ex = e;
    } on FirebaseException catch (e) {
      _ex = e;
    }
    showExceptio(context, _ex);
    return null;
  }

  Future<User> creteUser(String name, String lastname, String email,
      String password, BuildContext context) async {
    var _ex;
    try {
      UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      //////////////
      Map<String, dynamic> mapUser = {
        'displayName': name.toLowerCase(),
        'lastName': lastname.toLowerCase(),
        'photoURL': user.user.photoURL == null ? '' : user.user.photoURL,
        'email': email
      };

      DatabaseMethods().uploadUserInfo(user.user.uid, mapUser);
      ////////////////
      return user.user;
    } on FirebaseAuthException catch (e) {
      _ex = e;
    } on FirebaseException catch (e) {
      _ex = e;
    }

    showExceptio(context, _ex);
    return null;
  }

/*
  Future<String> currentUser() async {
    try {
      FirebaseUser user = await firebaseAuth.currentUser();
      return user.uid;
    } catch (e) {
      print('Exception: ' + e.toString());
      return null;
    }

    //return user != null ? user.uid : null;
  }
*/
  Future<void> signOut() async {
    try {
      firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }

    try {
      _googleSignIn.disconnect().then((value) => print(value));
    } catch (e) {
      print(e);
    }
  }
}
