import 'package:gerai_lam_app/models/address_model.dart';

enum Role { kasir, costumer, supplier }
enum Status { aktif, nonaktif, blokir }

class CostumerModel {
  int? id;
  String? email;
  String? imageUrl;
  String? name;
  String? phone;
  AddressModel? address;
  List<Role>? role;
  Status? status;

  CostumerModel({
    this.id,
    this.email,
    this.imageUrl,
    this.name,
    this.phone,
    this.address,
    this.role,
    this.status,
  });
}

List<CostumerModel> mockCostumer = [
  CostumerModel(
      id: 1,
      email: 'bagus@gmail.com',
      imageUrl: 'https://static.toiimg.com/photo/83890830/83890830.jpg',
      name: 'Bagus Prakarsa',
      phone: '0891277312313',
      address: AddressModel(
        alamat: 'Jl. Garuda Sakti',
        kecamatan: 'Rumbai',
        kelurahan: 'Sri meranti',
        kabupatenKota: 'Pekanbaru',
        provinsi: 'Riau',
      ),
      status: Status.aktif,
      role: [
        Role.supplier,
        Role.costumer,
      ]),
  CostumerModel(
      id: 2,
      email: 'doni@gmail.com',
      imageUrl:
          'https://images.pexels.com/photos/532220/pexels-photo-532220.jpeg',
      name: 'Doni Slamanan',
      phone: '081923881738123',
      address: AddressModel(
        alamat: 'Jl. Bangau',
        kecamatan: 'Panam',
        kelurahan: 'WhiteWolf',
        kabupatenKota: 'Kampar',
        provinsi: 'Riau',
      ),
      status: Status.aktif,
      role: [
        Role.costumer,
      ]),
  CostumerModel(
      id: 3,
      email: 'indra@gmail.com',
      imageUrl:
          'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_3.jpg',
      name: 'Indra Kenz',
      phone: '0866123761231',
      address: AddressModel(
        alamat: 'Jl. Merak Panda',
        kecamatan: 'Rao',
        kelurahan: 'Petapahan',
        kabupatenKota: 'Medan',
        provinsi: 'Sumatera Utara',
      ),
      status: Status.aktif,
      role: [
        Role.costumer,
      ]),
];
