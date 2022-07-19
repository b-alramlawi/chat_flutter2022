import 'package:flutter/material.dart';

import '../components/searchDelegate.dart';
import '../custom_ui/button_card.dart';
import '../model/user.dart';
import '../services/database.dart';
import 'contact_list.dart';
import 'new_create_group/all_contacts.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({Key key, this.allContacts}) : super(key: key);

  final List<UserData> allContacts;

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserData>>(
        stream: DatabaseService().getUsersList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserData> list = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF5A2E02),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Contact",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${list.length} ${list.length == 1 ? "Contact" : "Contacts"}',
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                  actions: [
                    ///////////////////////////////////////
                    IconButton(
                        icon: const Icon(
                          Icons.search,
                          size: 26,
                        ),
                        onPressed: () {
                          showSearch(context: context, delegate: DataSearch());
                        }),
                    PopupMenuButton<String>(
                      padding: const EdgeInsets.all(0),
                      onSelected: (value) {
                        value;
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            child: Text("Invite a friend"),
                            value: "Invite a friend",
                          ),
                          const PopupMenuItem(
                            child: Text("Contacts"),
                            value: "Contacts",
                          ),
                          const PopupMenuItem(
                            child: Text("Refresh"),
                            value: "Refresh",
                          ),
                          const PopupMenuItem(
                            child: Text("Help"),
                            value: "Help",
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListView.builder(
                      itemCount: list.length + 2,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const AllContacts()));
                            },
                            child: const ButtonCard(
                              icon: Icons.group,
                              name: "New group",
                            ),
                          );
                        } else if (index == 1) {
                          return const ButtonCard(
                            icon: Icons.person_add,
                            name: "New contact",
                          );
                        }
                        return ContactList(
                          user: list[index - 2],
                        );
                      }),
                ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

// class DataSearch extends SearchDelegate {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [IconButton(onPressed: () {
//       query = "";
//     }, icon: const Icon(Icons.close))];
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(onPressed: () {
//       close(context, null);
//     }, icon: const Icon(Icons.arrow_back));
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return null;
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return const Center(child: Text("Search Content"));
//   }
// }
