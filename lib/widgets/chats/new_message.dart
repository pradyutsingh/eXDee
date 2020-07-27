import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredmessage = '';
  final _controller = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context)
        .unfocus(); // to close the keyboard by changing the focus
    final user = await FirebaseAuth.instance.currentUser();
    final userData = await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'text': _enteredmessage,
      'sendTime': DateTime.now(),
      'userId': user.uid,
      'username' : userData['username'],
      'userimage' : userData['image_url']
    });
    _controller.clear();
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
              decoration: InputDecoration(labelText: 'Send a message'),
              onChanged: (value) {
                setState(() {
                  _enteredmessage = value;
                });
              },
            )),
            IconButton(
              icon: Icon(Icons.send),
              color: Colors.redAccent,
              onPressed: _enteredmessage.isEmpty ? null : _sendMessage,
            )
          ],
        ));
  }
}
