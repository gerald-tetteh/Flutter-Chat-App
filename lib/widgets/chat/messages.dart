/*
  * Author: Gerald Addo - Tetteh
  * Chat App
  * Messages
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection("chats")
                .orderBy("createdAt", descending: true)
                .snapshots(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final List<DocumentSnapshot> chatDocuments =
                  chatSnapshot.data.documents;
              return ListView.builder(
                reverse: true,
                itemBuilder: (context, index) => MessageBubble(
                  chatDocuments[index]["text"],
                  chatDocuments[index]["userId"] == futureSnapshot.data.uid,
                  chatDocuments[index]["username"],
                  chatDocuments[index]["userImage"],
                  key: ValueKey(chatDocuments[index].documentID),
                ),
                itemCount: chatDocuments.length,
              );
            });
      },
    );
  }
}
