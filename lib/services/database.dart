import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //Collection Reference
  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  Future updateUserData(String name, String status) async {
    return await users.doc(uid).update({
      'name': name,
      'status': status,
    });
  }

  /// get all users from firebase
  Stream<List<UserData>> getAllUsers() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    String currentUID = _auth.currentUser.uid;
    return users.snapshots().map((event) => event.docs
        .where((element) => element.id != currentUID)
        .map((doc) => UserData.fromMap(doc.data()))
        .toList());
  }

  //get user doc stream
  Stream<UserData> get userData {
    return users
        .doc(uid)
        .snapshots()
        .map((event) => UserData.fromMap(event.data()));
  }

  Future<void> createUserData(phone) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid.toString();
    UserData userData = UserData(phone: phone, uid: uid);
    users.doc(uid).set(userData.toMap());
    return;
  }

  Future<List<UserData>> usersAsFuture() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String uid = auth.currentUser.uid.toString();
      return await users.get().then((value) => value.docs
          .where((element) => element.id != uid)
          .map((doc) => UserData.fromMap(doc.data()))
          .toList());
    } catch (e) {
      e.toString();
      return null;
    }
  }

  Stream<List<UserData>> getUsersList() {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      String currentUID = _auth.currentUser.uid;
      return users.snapshots().map((event) => event.docs
          .where((element) => element.id != currentUID)
          .map((doc) => UserData.fromMap(doc.data()))
          .toList());
    } catch (e) {
      e.toString();
      return null;
    }
  }

  Future<UserData> getUserByID(String userID) async {
    try {
      return await users
          .doc(userID)
          .get()
          .then((value) => UserData.fromMap(value.data()));
    } catch (e) {
      log("ERROR getting user data : ${e.toString()}");
      return null;
    }
  }


  Future<UserData> getOtherUserByID(String userID) async {
    try {
      return await users
          .doc(userID)
          .get()
          .then((value) => UserData.fromMap(value.data()));
    } catch (e) {
      log("ERROR getting user data : ${e.toString()}");
      return null;
    }
  }


  Future<void> saveImages(File _image) async {
    String currentUID = FirebaseAuth.instance.currentUser.uid;
    String imageURL = await uploadFile(_image, currentUID);
    await users.doc(currentUID).update({"image": imageURL});
  }

  Future<String> uploadFile(File _image, String currentUID) async {
    try {
      Reference storageReference =
      FirebaseStorage.instance.ref().child('imagesRef/$currentUID');
      await storageReference.putFile(_image);
      String url = await storageReference.getDownloadURL();
      await users.doc(currentUID).update({"image": url});
      'File Uploaded';
      return url;
    } catch (e) {
      "Error Uploading Image : ${e.toString()}";
      return null;
    }
  }
}

// class DataServices {
//   final String uid;
//
//   DataServices({this.uid});
//
//   CollectionReference message =
//   FirebaseFirestore.instance.collection("Contacts");
//
//   Stream<List<Contact>> getAllMessages() {
//     return message.snapshots().map((event) =>
//         event.docs.map((doc) => Contact.fromMap(doc.data())).toList());
//   }
//
//   //get user doc stream
//   Stream<List<Contact>> get messageData {
//     return message.doc(uid).collection("my_contacts").snapshots().map(
//             (event) => event.docs.map((e) => Contact.fromMap(e.data())).toList());
//   }
// }
