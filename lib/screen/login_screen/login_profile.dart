import 'dart:io';

import 'package:chat_flutter2022/components/progressBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../../components/loading.dart';
import '../../model/user.dart';
import '../../services/database.dart';

class LoginProfile extends StatefulWidget {
  const LoginProfile({Key key}) : super(key: key);

  @override
  _LoginProfileState createState() => _LoginProfileState();
}

class _LoginProfileState extends State<LoginProfile>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //form values
  String _currentName;
  String _currentStatus;

  File _image; // Used only if you need a single picture

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: _auth.currentUser.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: Column(
                      children: [
                        // Top Bar
                        const SizedBox(
                          height: 20.0,
                        ),

                        // User DP
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
                                                      : userData.image != null
                                                          ? Image.network(
                                                              userData.image)
                                                          : Image.asset(
                                                              'assets/profileAvatar.png'),
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
                                              size: 30,
                                              color: Color(0xFFd9b382))),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const Text('Name',
                                              style: TextStyle(
                                                  color: Colors.black87)),
                                          SizedBox(
                                            width: 250,
                                            child: TextFormField(
                                                initialValue: userData.name,
                                                onTap: () {
                                                  userData.name;
                                                },
                                                validator: (val) => val.isEmpty
                                                    ? "Please enter name"
                                                    : null,
                                                onChanged: (val) => setState(
                                                    () => _currentName = val),
                                                style: const TextStyle(
                                                    color: Color(0xff808080),
                                                    fontSize: 18.0),
                                                decoration:
                                                    const InputDecoration(
                                                  suffixIcon: Icon(
                                                      LineAwesomeIcons.pencil,
                                                      color: Color(0xFF5A2E02),
                                                      size: 15.0),
                                                )),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ])),
                          ].where((element) => element != null).toList(),
                        ),
                        Container(
                            padding: const EdgeInsets.all(15.0),
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            // decoration: BoxDecoration(border: Border.all()),
                            child: Column(children: [
                              Row(
                                children: <Widget>[
                                  Container(
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      child: const Icon(Icons.info,
                                          size: 30, color: Color(0xFFd9b382))),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text('Status',
                                          style:
                                              TextStyle(color: Colors.black87)),
                                      SizedBox(
                                        width: 250,
                                        child: TextFormField(
                                            initialValue: userData.status,
                                            validator: (val) => val.isEmpty
                                                ? "Please enter Status"
                                                : null,
                                            onChanged: (val) => setState(
                                                () => _currentStatus = val),
                                            style: const TextStyle(
                                                color: Color(0xff808080)),
                                            decoration: const InputDecoration(
                                              //contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),

                                              suffixIcon: Icon(
                                                  LineAwesomeIcons.pencil,
                                                  color: Color(0xFF5A2E02),
                                                  size: 15.0),
                                            )),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ])),
                        Container(
                            padding: const EdgeInsets.all(15.0),
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(children: [
                              Row(
                                children: <Widget>[
                                  Container(
                                      margin:
                                          const EdgeInsets.only(right: 10.0),
                                      child: const Icon(Icons.phone,
                                          size: 30, color: Color(0xFFd9b382))),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text('Phone',
                                          style:
                                              TextStyle(color: Colors.black87)),
                                      Text(userData.phone,
                                          style: const TextStyle(
                                              color: Color(0xff808080),
                                              fontSize: 18)),
                                    ],
                                  ),
                                ],
                              )
                            ])),

                        const SizedBox(height: 30),

                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await DatabaseService(uid: _auth.currentUser.uid)
                                  .updateUserData(
                                _currentName ?? userData.name,
                                _currentStatus ?? userData.status,
                              );
                            }
                            setState(() => _loading = true);
                            await DatabaseService().saveImages(_image);
                            setState(() => _loading = false);
                          },
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
                                    horizontal: 50.0, vertical: 15.0)),
                          ),
                          child: _loading ? const ProgressBar() :const Text("Update"),
                        ),
                      ],
                    )),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
