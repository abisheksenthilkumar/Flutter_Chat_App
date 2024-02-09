import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imessage/model/message.dart';

class ChatService extends ChangeNotifier{

  // get instance od auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SEND MESSAGE
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info 
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentuserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentuserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    //construct chat room id form current user id and receiver id (sorted to ensur  uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("-");

    // add new message to database
    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }
  //GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
  List<String> ids = [userId, otherUserId];
  ids.sort();
  String chatRoomId = ids.join("-");

  return _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp', descending: false).snapshots();
}
}