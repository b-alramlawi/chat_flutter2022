import 'package:flutter/material.dart';

import '../model/user.dart';
import '../screen/contact_list.dart';
import '../services/database.dart';

class DataSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<UserData>>(
        stream: DatabaseService().getUsersList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserData> list = snapshot.data;
            List filterNames =
                list.where((element) => element.name.contains(query)).toList();
            return ListView.builder(
                itemCount: query == "" ? list.length : filterNames.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        query = query == "" ? list[index] : filterNames[index];
                        showResults(context);
                      },
                      child: ContactList(
                        user: list[index],
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
