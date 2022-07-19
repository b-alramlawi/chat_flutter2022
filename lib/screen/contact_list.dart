
import 'package:chat_flutter2022/screen/singleChat/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

import '../model/user.dart';
import '../services/database.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key key, this.user}) : super(key: key);
  final UserData user;

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        String id = FirebaseAuth.instance.currentUser.uid;
        UserData currentUser = await DatabaseService().getUserByID(id);
        log("Container clicked");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Chat(
                  currentUser: currentUser,
                  otherUser: widget.user,
                )));
      },
      leading: SizedBox(
        width: 50,
        height: 53,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 23,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(27.5),
                child: (widget.user.image != null)
                    ? Image.network(widget.user.image)
                    : Image.asset('assets/profileAvatar.png'),
              ),
              backgroundColor: Colors.blueGrey[200],
            )
          ],
        ),
      ),
      title: Text(
        widget.user.name ?? widget.user.phone,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        widget.user.status ?? ("Hey there! I am using ChatApp").toString(),
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}
