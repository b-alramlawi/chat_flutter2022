
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import '../../components/camera_screen/camera_screen.dart';
import '../../components/emoji_select.dart';
import '../../components/progressBar.dart';
import '../../model/message.dart';
import '../../model/user.dart';
import '../../providers/images.dart';
import '../../services/database.dart';

class BottomSendNavigation extends StatefulWidget {
  const BottomSendNavigation({this.currentUser, this.otherUser, this.message});

  final UserData currentUser;
  final UserData otherUser;
  final MessageObject message;

  @override
  _BottomSendNavigationState createState() => _BottomSendNavigationState();
}

class _BottomSendNavigationState extends State<BottomSendNavigation>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String messageText;

  bool _loading = false;
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<MessageObject> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final messageTextController = TextEditingController();
  final myId = FirebaseAuth.instance.currentUser.uid;

  final TextEditingController _sendMessageController = TextEditingController();

  /// Save Image to Firebase
  Future saveImage(List<Asset> asset) async {
    UploadTask uploadTask;
    List<String> linkImage = [];
    for (var value in asset) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
          FirebaseStorage.instance.ref().child('Chat_Images/$fileName');
      ByteData byteData = await value.requestOriginal(quality: 70);
      var imageData = byteData.buffer.asUint8List();
      uploadTask = ref.putData(imageData);
      String imageUrl;
      await (await uploadTask).ref.getDownloadURL().then((onValue) {
        imageUrl = onValue;
      });
      linkImage.add(imageUrl);
    }
    return linkImage;
  }

  Future<void> loadAssets(ImagesProvider imagesProvider) async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: imagesProvider.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#000000",
          actionBarTitle: "Pick Product Image",
          allViewTitle: "All Photos",
          useDetailsView: true,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
    imagesProvider.setImages = resultList;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final images = Provider.of<ImagesProvider>(context);
    //FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    final userId = widget.otherUser.uid;
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: _auth.currentUser.uid).userData,
        //stream: _fireStore.collection('chat').doc(myId).collection("contacts").doc(userId).collection("messages").snapshots(),
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          return Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        child: Card(
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextFormField(
                            controller: _controller,
                            focusNode: focusNode,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            minLines: 1,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  sendButton = true;
                                  messageText = value;
                                });
                              } else {
                                setState(() {
                                  sendButton = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a message...",
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: IconButton(
                                icon: Icon(
                                    show
                                        ? Icons.keyboard
                                        : Icons.emoji_emotions_outlined,
                                    color: const Color(0xFFc19153)),
                                onPressed: () {
                                  if (!show) {
                                    focusNode.unfocus();
                                    focusNode.canRequestFocus = false;
                                  }
                                  setState(() {
                                    show = !show;
                                  });
                                },
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.attach_file,
                                        color: Color(0xFFc19153)),
                                    onPressed: () {
                                      loadAssets(images);
                                      // print(userId);
                                      // print(myId);
                                      // showModalBottomSheet(
                                      //     backgroundColor: Colors.transparent,
                                      //     context: context,
                                      //     builder: (builder) =>
                                      //         const ButtonAttachFileSheet());
                                    },
                                  ),
                               IconButton(
                                    icon: const Icon(Icons.camera_alt,
                                        color: Color(0xFFc19153)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  const CameraScreen()));
                                    },
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.all(5),
                            ),

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8,
                          right: 2,
                          left: 2,
                        ),
                        child: CircleAvatar(

                          radius: 25,
                          backgroundColor: const Color(0xFF5A2E02),
                          child:_loading ? const ProgressBar() : IconButton(
                            icon: const Icon(
                              Icons.send,
                              // sendButton ? Icons.send : Icons.mic,
                              color: Colors.white,
                            ),
                            onPressed: () async {

                              if (images.images.isNotEmpty) {
                                setState(() => _loading = true);
                                List<String> listImages =
                                    await saveImage(images.images);
                                setState(() => _loading = false);
                                images.setImages = [];
                                messageTextController.clear();
                                String messageId = _firestore
                                    .collection('chat')
                                    .doc(myId)
                                    .collection("contacts")
                                    .doc(userId)
                                    .collection("messages")
                                    .doc(DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString())
                                    .id;
                                await _firestore
                                    .collection('chat')
                                    .doc(myId)
                                    .collection("contacts")
                                    .doc(userId)
                                    .collection("messages")
                                    .doc(messageId)
                                    .set({
                                  'sender': myId,
                                  'receiver': userId,
                                  'image': listImages,
                                  'time': DateTime.now().toString().substring(10, 16),
                                });
                                //DateTime.now().toString().substring(10, 16)
                                await _firestore
                                    .collection('chat')
                                    .doc(userId)
                                    .collection("contacts")
                                    .doc(myId)
                                    .collection("messages")
                                    .doc(messageId)
                                    .set({
                                  'sender': myId,
                                  'receiver': userId,
                                  'image': listImages,
                                  'time': DateTime.now().toString().substring(10, 16),
                                }).whenComplete(() => {
                                          messageId = _firestore
                                              .collection('chat')
                                              .doc(myId)
                                              .collection("contacts")
                                              .doc(userId)
                                              .collection("messages")
                                              .doc(DateTime.now()
                                                  .microsecondsSinceEpoch
                                                  .toString())
                                              .id
                                        });
                                _sendMessageController.clear();
                                _controller.clear();
                              } else {
                                String messageId = _firestore
                                    .collection('chat')
                                    .doc(myId)
                                    .collection("contacts")
                                    .doc(userId)
                                    .collection("messages")
                                    .doc(DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString())
                                    .id;
                                _firestore
                                    .collection('chat')
                                    .doc(myId)
                                    .collection("contacts")
                                    .doc(userId)
                                    .collection("messages")
                                    .doc(messageId)
                                    .set({
                                  'text': messageText,
                                  'sender': myId,
                                  'receiver': userId,
                                  'image': [],
                                  'time': DateTime.now().toString().substring(10, 16),
                                }).whenComplete(() => {
                                          _firestore
                                              .collection('chat')
                                              .doc(userId)
                                              .collection("contacts")
                                              .doc(myId)
                                              .collection("messages")
                                              .doc(messageId)
                                              .set({
                                            'text': messageText,
                                            'sender': myId,
                                            'receiver': userId,
                                            'image': [],
                                            'time': DateTime.now().toString().substring(10, 16),
                                          }).whenComplete(() => {
                                                    messageId = _firestore
                                                        .collection('chat')
                                                        .doc(myId)
                                                        .collection("contacts")
                                                        .doc(userId)
                                                        .collection("messages")
                                                        .doc(DateTime.now()
                                                            .microsecondsSinceEpoch
                                                            .toString())
                                                        .id
                                                  })
                                        });
                                _sendMessageController.clear();
                              }

                              await _firestore
                                  // .collection('Contacts').orderBy('timestamp', descending: true)
                                  // .snapshots();
                                  .collection('Contacts')
                                  .doc(myId)
                                  .collection("my_contacts")
                                  .doc(userId)
                                  .set({
                                'id': userId,
                                'title': widget.otherUser.name,
                                'image': widget.otherUser.image,
                                'time': DateTime.now().toString().substring(10, 16),
                                //'type': userId,
                                'lastMessage':
                                    (messageText != null) ? messageText : '',
                              });

                              await _firestore
                                  .collection('Contacts')
                                  .doc(userId)
                                  .collection("my_contacts")
                                  .doc(myId)
                                  .set({
                                'id': myId,
                                'title': userData.name,
                                'image': userData.image,

                                'time': DateTime.now().toString().substring(10, 16),
                                //'type': userId,
                                'lastMessage':
                                    (messageText != null) ? messageText : '',
                              });
                            },
                          ),

                          // if (sendButton) {
                          //   _scrollController.animateTo(
                          //       _scrollController
                          //           .position.maxScrollExtent,
                          //       duration: const Duration(
                          //           milliseconds: 300),
                          //       curve: Curves.easeOut);
                          //   sendMessage(
                          //       _controller.text,
                          //       widget.currentUser.uid,
                          //       widget.otherUser.uid);
                          //   _controller.clear();
                          //   setState(() {
                          //     sendButton = false;
                          //   });
                          // }
                        ),
                      ),
                    ],
                  ),
                  show ? const EmojiSelect() : Container(),
                ],
              ),
            ),
          );
        });
  }
}
