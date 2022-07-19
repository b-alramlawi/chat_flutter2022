class GroupObject {
  final String userId;
  String groupTitle;
  String groupImage;

  final List<dynamic> usersList;

  GroupObject({this.userId, this.groupTitle, this.groupImage, this.usersList});

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "groupTitle": groupTitle,
      "groupImage": groupImage,
      "usersList": usersList,
    };
  }

  factory GroupObject.fromMap(Map<String, dynamic> data) {
    return GroupObject(
        userId: data["userId"],
        groupTitle: data["groupTitle"],
        groupImage: data["groupImage"],
        usersList: data["usersList"]);
  }
}
