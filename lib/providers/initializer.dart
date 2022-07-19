import 'package:flutter/material.dart';

import '../model/user.dart';

class Initializer with ChangeNotifier {
  int homePageIndex = 0;
  bool topBar = true;
  bool statusBar = true;
  bool searchBar = false;
  String chatUserName;
  bool chatUserStatus;

  List<UserData> selectedContacts() {
    return allContacts.where((contact) => contact.select).toList();
  }

  List<UserData> allContacts;

  void setChatUser(name, status) {
    chatUserName = name;
    chatUserStatus = status;
    notifyListeners();
  }


  void setHomePageIndex(index) {
    homePageIndex = index;
    notifyListeners();
  }



  void toogleSearchBar() {
    searchBar = !searchBar;
    if (!searchBar) {
      toogleTopBar();
      toogleStatusBar();
    }
    notifyListeners();
  }

  void toogleTopBar() {
    topBar = !topBar;
    notifyListeners();
  }

  void toogleStatusBar() {
    statusBar = !statusBar;
    notifyListeners();
  }
}
