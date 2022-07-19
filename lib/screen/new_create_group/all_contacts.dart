import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../providers/user_group.dart';
import '../../services/database.dart';
import 'avatar_card.dart';
import 'contact_card.dart';
import 'group_profile.dart';

class AllContacts extends StatefulWidget {
  const AllContacts({Key key, this.allContacts}) : super(key: key);
  final List<UserData> allContacts;

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<AllContacts> {
  @override
  Widget build(BuildContext context) {
    final group = Provider.of<GroupUsers>(context);
    final int counter = group.selectedContacts.length;
    return StreamBuilder<List<UserData>>(
        stream: DatabaseService().getUsersList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserData> list = snapshot.data;
            list.length;

            return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF5A2E02),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "New Group",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${counter.toString()} of ${list.length} Contacts",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                  actions: [
                    IconButton(
                        icon: const Icon(
                          Icons.search,
                          size: 26,
                        ),
                        onPressed: () {}),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                    backgroundColor: const Color(0xFFd9b382),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const GroupProfile()));
                    },
                    child: const Icon(Icons.arrow_forward)),
                body: Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.all(15),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        group.selectedContacts.isNotEmpty
                            ? SizedBox(
                                height: 75,
                                child: Row(
                                  children: group.selectedContacts
                                      .map((user) => AvatarCard(user: user))
                                      .toList(),
                                ),
                              )
                            : null,
                        Column(
                          children: list
                              .map((user) => ContactCard(
                                    user: user,
                                  ))
                              .toList(),
                        )
                      ].where((element) => element != null).toList(),
                    )
                  ],
                ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
