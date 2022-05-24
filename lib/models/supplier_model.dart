class SupplierModel {
  int? id;
  String? email;
  String? name;
  String? phone;
  String? imageUrl;
  String? zone;

  SupplierModel({
    this.id,
    this.email,
    this.imageUrl,
    this.name,
    this.phone,
    this.zone,
  });

  SupplierModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    name = json['name'];
    phone = json['phone'];
    zone = json['zone'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'imageUrl': imageUrl,
      'name': name,
      'phone': phone,
      'zone': zone,
    };
  }
}

List<SupplierModel> mockSupplier = [
  SupplierModel(
    id: 1,
    name: 'Bambang Suparman',
    email: 'xxxxxxxxx@gmail.com',
    imageUrl:
        'https://www.hbs.edu/about/PublishingImages/school-leadership/patrick-mullane-2021.jpg',
    phone: '0819xxxxxxx',
    zone: 'Pekxxxxxxx',
  ),
  SupplierModel(
    id: 2,
    name: 'Rey Misterio',
    email: 'xxxxxxxxx@gmail.com',
    imageUrl:
        'https://www.hbs.edu/about/PublishingImages/school-leadership/patrick-mullane-2021.jpg',
    phone: '0819xxxxxxx',
    zone: 'Pekxxxxxxx',
  ),
  SupplierModel(
    id: 3,
    name: 'Rendy',
    email: 'xxxxxxxxx@gmail.com',
    imageUrl:
        'https://www.hbs.edu/about/PublishingImages/school-leadership/patrick-mullane-2021.jpg',
    phone: '0819xxxxxxx',
    zone: 'Pekxxxxxxx',
  ),
  SupplierModel(
    id: 999,
    name: 'Nama Lengkap',
    email: 'xxxxxxxxx@gmail.com',
    imageUrl:
        'https://www.hbs.edu/about/PublishingImages/school-leadership/patrick-mullane-2021.jpg',
    phone: '0819xxxxxxx',
    zone: 'Pekxxxxxxx',
  ),
];
