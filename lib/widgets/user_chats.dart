import 'package:cloud_firestore/cloud_firestore.dart';

class UserFiles {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMessageToUserChat(
      String userId, String message, bool isUserMessage) async {
    await _firestore.collection('users').doc(userId).collection('chats').add({
      'message': message,
      'timestamp': Timestamp.now(),
      'isUserMessage': isUserMessage,
    });
  }

  Stream<QuerySnapshot> getUserChats(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
