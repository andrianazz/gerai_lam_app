class NotificationModel {
  String? name;
  String? token;
  String? email;

  NotificationModel({this.name, this.token, this.email});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
