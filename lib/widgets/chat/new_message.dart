import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = "";
  final _controller = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    _controller.clear();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection("users").document(user.uid).get();
    Firestore.instance.collection("chats").add({
      "text": _enteredMessage,
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "username": userData["username"],
      "userImage": userData["imageUrl"],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Send a message..."),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).iconTheme.color,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
