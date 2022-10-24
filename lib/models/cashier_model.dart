class CashierModel {
  String? id;
  String? name;

  CashierModel({this.id, this.name});

  CashierModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
