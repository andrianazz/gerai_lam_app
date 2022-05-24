class EmployeeModel {
  int? id;
  String? email;
  String? name;
  String? phone;
  String? role;
  String? status;

  EmployeeModel({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.role,
    this.status,
  });

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    role = json['role'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'status': status,
    };
  }
}

List<EmployeeModel> mockEmployee = [
  EmployeeModel(
    id: 1,
    email: 'Email Pengguna',
    name: 'gerai admin',
    phone: '0812xxxxxxxx',
    role: 'hak akses',
    status: 'status',
  ),
  EmployeeModel(
    id: 2,
    email: 'Email Pengguna',
    name: 'kasir1',
    phone: '0812xxxxxxxx',
    role: 'hak akses',
    status: 'status',
  ),
  EmployeeModel(
    id: 3,
    email: 'Email Pengguna',
    name: 'kasir2',
    phone: '0812xxxxxxxx',
    role: 'hak akses',
    status: 'status',
  ),
];
