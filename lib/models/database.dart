import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  uploadUserInfo(String _uid, Map _data) {
    FirebaseFirestore.instance.collection('user').doc(_uid).set(_data);
  }
}
