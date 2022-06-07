import 'package:gerai_lam_app/models/asal_model.dart';

class CostumerModel {
  AsalModel? asal;
  String? email;
  String? id;
  String? imageUrl;
  String? name;
  String? phone;
  String? status;

  CostumerModel({
    this.asal,
    this.email,
    this.id,
    this.imageUrl,
    this.name,
    this.phone,
    this.status,
  });

  CostumerModel.fromJson(Map<String, dynamic> json) {
    asal = AsalModel.fromJson(json['asal']);
    email = json['email'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    phone = json['phone'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'asal': asal!.toJson(),
      'email': email,
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'phone': phone,
      'status': status,
    };
  }
}
