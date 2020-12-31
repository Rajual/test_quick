import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  uploadUserInfo(String _uid, Map _data) {
    FirebaseFirestore.instance.collection('user').doc(_uid).update(_data);
  }

  setUserInfo(String _uid, Map _data) {
    FirebaseFirestore.instance.collection('user').doc(_uid).set(_data);
  }

  sendMessage(String message, String send, String chatID,
      [String imageURL = '']) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID)
        .collection('chat')
        .add({
      'message': message,
      'imageURL': imageURL,
      'sendBy': send,
      'time': Timestamp.now()
    });
  }

  createChat(String send, String receives) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(send + '_' + receives)
        .set({
      'chatRoomID': send + '_' + receives,
      'users': [send, receives]
    });
  }

  searchChat(String userUno, String userTwo) {
    FirebaseFirestore.instance
        .collection('chats')
        .where('users', isEqualTo: [userUno, userTwo])
        .get()
        .then((value) {
          return (value.docs.map((e) {
            return e['chatRoomID'];
          }));
        });
  }

  getUsers() {
    print(FirebaseFirestore.instance.collection('user').get().then((value) {
      print(value.docs);
    }));
  }

  Future getUser(String uid) async {
    return await Future.value(FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get()
        .then((value) {
      return value.data();
    }));
  }
}
