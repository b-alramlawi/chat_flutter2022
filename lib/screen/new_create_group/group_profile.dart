import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../components/loading.dart';
import '../../model/group_object.dart';
import '../../model/user.dart';
import '../../providers/user_group.dart';
import '../../services/group_database.dart';
import 'avatar_card.dart';

class GroupProfile extends StatefulWidget {
  const GroupProfile({Key key, this.user}) : super(key: key);

  final UserData user;

  @override
  _GroupProfileState createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _currentName;
  List userSelect;
  File _image;

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    } else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        'No image selected.';
      }
    });
  }

  final bool _loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<GroupUsers>(context);
    return StreamBuilder<GroupObject>(
        stream: GroupDatabaseServices(groupID: _auth.currentUser.uid).userData,
        builder: (context, snapshot) {
          GroupObject groupData = snapshot.data;
          return Scaffold(
              body: ListView(
            children: [
              Form(
                key: _formKey,
                child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        // Top Bar
                        const SizedBox(
                          height: 100.0,
                        ),

                        SizedBox(
                            height: 150.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(15.0),
                                  width: 150,
                                  height: 150,
                                  margin: const EdgeInsets.only(right: 10.0),
                                  decoration: const BoxDecoration(
                                      // border: Border.all(),
                                      ),
                                  child: Stack(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Center(
                                                    child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  child: _image != null
                                                      ? Image.file(_image)
                                                      : Image.asset(
                                                          'assets/groupAvatar.png'),
                                                )))
                                          ]),
                                      Positioned(
                                          bottom: 10,
                                          right: 0,
                                          width: 50,
                                          height: 50,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  // border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                  color: Colors.white),
                                              child: IconButton(
                                                  color: Colors.green,
                                                  onPressed: () {
                                                    getImage(true);
                                                  },
                                                  icon: const Icon(
                                                      Icons.camera_alt,
                                                      size: 22,
                                                      color:
                                                          Color(0xff35A897)))))
                                    ],
                                  ),
                                )
                              ],
                            )),
                        Stack(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(15.0),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(children: [
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          child: const Icon(Icons.person,
                                              size: 25.0,
                                              color: Color(0xFFd9b382))),
                                      Column(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 250,
                                                child: TextFormField(
                                                    //initialValue: userData.name,
                                                    onTap: () {
                                                      //print(userData.name);
                                                    },
                                                    validator: (val) => val
                                                            .isEmpty
                                                        ? "Please enter name"
                                                        : null,
                                                    onChanged: (val) =>
                                                        setState(() =>
                                                            _currentName = val),
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xff808080),
                                                        fontSize: 18.0),
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          "Input Group Name",
                                                      hintStyle: TextStyle(
                                                          fontSize: 15.0,
                                                          color: Colors.grey),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ])),
                            _loading ? const Loading() : null
                          ].where((element) => element != null).toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: group.selectedContacts
                              .map(
                                (user) => AvatarCard(
                                  user: user,
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(
                          height: 70,
                        ),

                        ElevatedButton(
                          child: const Text("Create New Group"),

                          // onPressed: () async {
                          //   group;
                          //   int index =0;
                          //   setState(() {
                          //     if (contacts[index - 1].select == true) {
                          //       groupmember.remove(contacts[index - 1]);
                          //       contacts[index - 1].select = false;
                          //     } else {
                          //       groupmember.add(contacts[index - 1]);
                          //       contacts[index - 1].select = true;
                          //     }
                          //   });
                          //
                          // },

                          // onPressed: () async {
                          //   // group;
                          //   // if (_formKey.currentState.validate()) {
                          //   //   await GroupDatabaseServices(
                          //   //           groupID: _auth.currentUser.uid)
                          //   //       .setGroupUserData(
                          //   //     _currentName ?? groupData.groupTitle,
                          //   //     _image ?? groupData.groupImage,
                          //   //     group.selectedContacts,
                          //   //   );
                          //   // }
                          // },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return const Color(0xFFd9b382);
                                }
                                return const Color(0xFF5A2E02);
                              },
                            ),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 70.0, vertical: 15.0)),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    )),
              ),
            ],
          ));
        });
  }
}
