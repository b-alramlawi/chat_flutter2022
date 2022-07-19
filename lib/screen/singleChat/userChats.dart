
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/message.dart';
import '../../model/user.dart';
import '../../providers/images.dart';
import 'messageBox.dart';

class UserChat extends StatefulWidget {
  const UserChat({@required this.currentUser, @required this.otherUser});

  final UserData currentUser;
  final UserData otherUser;

  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  @override
  Widget build(BuildContext context) {
    final images = Provider.of<ImagesProvider>(context);
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    final myId = FirebaseAuth.instance.currentUser.uid;
    final userId = widget.otherUser.uid;
    print("Other User : $userId");
    print("Curent User : $myId");
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _fireStore
              .collection('chat')
              .doc(myId)
              .collection("contacts")
              .doc(userId)
              .collection("messages")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.brown,
                ),
              );
            }
            final messages = snapshot.data.docs;
            List<MessageObject> messageBubbles = [];
            for (var message in messages) {
              final messageText = message.data()['text'];
              final messageSender = message.data()["sender"];
              final messageTime = message.data()["time"];
              List<String> imagesUrl = List.from(message.data()["image"]);
              final currentUser = myId;
              final messageBubble = MessageObject(
                sender: messageSender,
                text: (messageText != null) ? messageText : '',
                time: messageTime,
                context: context,
                imagesList: imagesUrl ?? [],
                onDeleteMessage: () {
                  FirebaseFirestore.instance
                      .collection('chat')
                      .doc(myId)
                      .collection("contacts")
                      .doc(userId)
                      .collection("messages")
                      .doc(message.id)
                      .delete();
                  setState(() {});
                },
                isMe: currentUser == messageSender,
              );
              messageBubbles.add(messageBubble);
              print(messageBubbles.length);
            }
            return ListView(
              children: messageBubbles
                  .map((msgObject) => MessageBubble(message: msgObject))
                  .toList(),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 175,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: List.generate(images.images.length, (index) {
                Asset asset = images.images[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Stack(
                      children: <Widget>[
                        AssetThumb(
                          asset: asset,
                          width: 300,
                          height: 300,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              images.images.removeAt(index);
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: Colors.white,
                              ),
                              child: const Icon(Icons.close,
                                  color: Colors.black, size: 18)),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
