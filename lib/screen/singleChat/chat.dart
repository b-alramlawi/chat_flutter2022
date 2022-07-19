import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user.dart';
import '../../providers/images.dart';
import '../../services/database.dart';
import 'bottomSendNavigation.dart';
import 'userChats.dart';

class Chat extends StatefulWidget {
  const Chat({Key key, @required this.currentUser, @required this.otherUser})
      : super(key: key);
  final UserData currentUser;
  final UserData otherUser;

  @override
  _Chat createState() => _Chat();
}

class _Chat extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String messageText;
  String onlineStatus = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      onlineStatus = widget.otherUser.onlineStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final images = Provider.of<ImagesProvider>(context);
    //FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    final userId = widget.otherUser.uid;

    bool show = false;
    FocusNode focusNode = FocusNode();
    bool sendButton = false;
    final TextEditingController _controller = TextEditingController();
    final ScrollController _scrollController = ScrollController();

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: _auth.currentUser.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

          return Stack(
            children: [
              Image.asset(
                "assets/chatBackground.png",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: AppBar(
                    backgroundColor: const Color(0xFF5A2E02),
                    leadingWidth: 70,
                    titleSpacing: 0,
                    leading: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            size: 24,
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blueGrey,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(27.5),
                              child: (widget.otherUser.image != null)
                                  ? Image.network(widget.otherUser.image)
                                  : Image.asset('assets/profileAvatar.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    title: InkWell(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.otherUser.name ?? widget.otherUser.phone,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              onlineStatus,
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                          icon: const Icon(Icons.videocam),
                          onPressed: () {
                            print(widget.otherUser.uid);
                          }),
                      IconButton(
                          icon: const Icon(Icons.call), onPressed: () {}),
                      PopupMenuButton<String>(
                        padding: const EdgeInsets.all(0),
                        onSelected: (value) {
                          value;
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              child: Text("View Contact"),
                              value: "View Contact",
                            ),
                            const PopupMenuItem(
                              child: Text("Media, links, and docs"),
                              value: "Media, links, and docs",
                            ),
                            const PopupMenuItem(
                              child: Text("Whatsapp Web"),
                              value: "Whatsapp Web",
                            ),
                            const PopupMenuItem(
                              child: Text("Search"),
                              value: "Search",
                            ),
                            const PopupMenuItem(
                              child: Text("Mute Notification"),
                              value: "Mute Notification",
                            ),
                            const PopupMenuItem(
                              child: Text("Wallpaper"),
                              value: "Wallpaper",
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
                body: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: WillPopScope(
                    child: Column(
                      children: [
                        Expanded(
                          child: UserChat(
                            currentUser: widget.currentUser,
                            otherUser: widget.otherUser,
                          ),
                        ),
                        BottomSendNavigation(
                          currentUser: widget.currentUser,
                          otherUser: widget.otherUser,
                        ),
                      ],
                    ),
                    onWillPop: () {
                      if (show) {
                        setState(() {
                          show = false;
                        });
                      } else {
                        Navigator.pop(context);
                      }
                      return Future.value(false);
                    },
                  ),
                ),
              ),
            ],
          );
        });
  }
}
