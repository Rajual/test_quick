import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  uploadUserInfo(String _uid, Map _data) {
    FirebaseFirestore.instance.collection('user').doc(_uid).set(_data);
  }

  sendMessage(String message, String send, String receives) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(send + '_' + receives)
        .collection('chat')
        .add({'message': message, 'sendBy': send});
  }

  createChat(String send, String receives) {
    FirebaseFirestore.instance
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
}
