
import 'package:firebase_auth/firebase_auth.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

import '../model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user Obj based on FirebaseUser.
  Users _userFromFirebaseUser(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  //auth change user stream.
  Stream<Users> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
    //.map((User user)=>_userFromFirebaseUser(user));
  }

// sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
