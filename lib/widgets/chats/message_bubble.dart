import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.key, this.message, this.isMe, this.username ,this.imgurl);
  final String message;
  final bool isMe;
  final Key key;
  final String username;
  final String imgurl;

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            
            Row(
        mainAxisAlignment:
            !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.redAccent : Colors.deepPurpleAccent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight: isMe ? Radius.circular(0) : Radius.circular(12)),
              ),
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 13, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                  Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              )),
        ],
      ),
      Positioned(
        top: -10,
        left: isMe ? null : 120,
        right: isMe ? 120 : null,
        child: CircleAvatar(
          backgroundImage: NetworkImage(imgurl),
        )
        )
        
      ],
      overflow: Overflow.visible,
    );
  }
}
