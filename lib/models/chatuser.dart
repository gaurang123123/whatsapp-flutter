class ChatUser {
  ChatUser(
      {required this.image,
      required this.createdat,
      required this.name,
      required this.about,
      required this.pushtoken,
      required this.idonline,
      required this.id,
      required this.email,
      required this.lastactive,
      required this.phoneno});
  late String image;
  late String createdat;
  late String name;
  late String about;
  late String pushtoken;
  late bool idonline;
  late String id;
  late String email;
  late String lastactive;
  late String phoneno;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    createdat = json['createdat'] ?? "";
    name = json['name'] ?? "";
    about = json['about'] ?? "";
    pushtoken = json['pushtoken'] ?? "";
    idonline = json['idonline'] ?? "";
    id = json['id'] ?? "";
    email = json['email'] ?? "";
    lastactive = json['lastactive'] ?? "";
    phoneno = json['phoneno'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['createdat'] = createdat;
    data['name'] = name;
    data['about'] = about;
    data['pushtoken'] = pushtoken;
    data['idonline'] = idonline;
    data['id'] = id;
    data['email'] = email;
    data['lastactive'] = lastactive;
    data['phoneno'] = phoneno;
    return data;
  }
}
