import 'package:Exdee/widgets/chats/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futuresnap) {
        if (futuresnap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('sendTime', descending: true)
                .snapshots(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final chatdocs = chatSnapshot.data.documents;
              return ListView.builder(
                  reverse: true,
                  itemCount: chatdocs.length,
                  itemBuilder: (context, index) => MessageBubble(
                      ValueKey(chatdocs[index].documentID),
                      chatdocs[index]['text'],
                      chatdocs[index]['userId'] == futuresnap.data.uid,
                      chatdocs[index]['username'],
                      chatdocs[index]['userimage'],

                      ));
            });
      },
    );
  }
}
