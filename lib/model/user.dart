class Users {
  final String uid;

  Users({this.uid});
}

class UserData {
  final String uid;
  final String phone;
  String name;
  String status;
  String onlineStatus;
  String image;
  bool isGroup = false;
  bool select = false;

  String time;
  String currentMessage;

  UserData(
      {this.uid,
      this.phone,
      this.image,
      this.name,
      this.status,
      this.onlineStatus,
      this.isGroup,
      this.time,
      this.currentMessage,
      this.select = false});

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "phone": phone,
      "name": name,
      "status": status,
      "onlineStatus": onlineStatus,
      "image": image,
      "select": select,
      "isGroup": isGroup,
      "currentMessage": currentMessage,
      "time": time,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
        uid: data["uid"],
        phone: data["phone"],
        name: data["name"],
        status: data["status"],
        onlineStatus: data["onlineStatus"],
        image: data["image"],
        isGroup: data["isGroup"] ?? false,
        currentMessage: data["currentMessage"],
        time: data["time"],
        select: (data["select"]) ?? false);
  }
}
