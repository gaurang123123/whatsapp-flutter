class ChatroomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? fromid;
  String? toid;
  String? lastmessage;
  ChatroomModel({this.chatroomid, this.participants, this.lastmessage});

  ChatroomModel.fromJson(Map<String, dynamic> Json) {
    chatroomid = Json['chatroomid'];
    participants = Json['paricipants'];
    lastmessage = Json['lastmessage'];
    // fromid = Json['fromid'];
    // toid = Json['toid'];
  }

  Map<String, dynamic> toJson() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastmessage
    };
  }
}
