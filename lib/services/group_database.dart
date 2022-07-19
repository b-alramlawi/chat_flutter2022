import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../model/group_object.dart';
import '../model/user.dart';

class GroupDatabaseServices {
  final String groupID;

  GroupDatabaseServices({this.groupID});

  //Collection Reference
  CollectionReference groupUsers =
      FirebaseFirestore.instance.collection("GroupUsers");

  Future setGroupUserData(
      String name, File _image, List<UserData> usersList) async {
    final String groupID = const Uuid().v4();
    String imageURL = await uploadGroupFile(_image, groupID);

    await groupUsers.doc(groupID).set({
      'groupTitle': name,
      'groupImage': "",
      "users": usersList.map((e) => e.toMap()).toList(),
    });
    await groupUsers.doc(groupID).update({"groupImage": imageURL});
  }

  Stream<List<GroupObject>> getAllUsers() {
    return groupUsers.snapshots().map((event) =>
        event.docs.map((doc) => GroupObject.fromMap(doc.data())).toList());
  }

  //get user doc stream
  Stream<GroupObject> get userData {
    return groupUsers
        .doc(groupID)
        .snapshots()
        .map((event) => GroupObject.fromMap(event.data()));
  }

  Future<String> uploadGroupFile(File _image, String currentUID) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('groupImagesRef/$currentUID');
      await storageReference.putFile(_image);
      String url = await storageReference.getDownloadURL();
      return url;
    } catch (e) {
      "Error Uploading Image : ${e.toString()}";
      return null;
    }
  }
}
