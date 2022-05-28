import 'package:gerai_lam_app/models/supplier_model.dart';

class ItemModel {
  int? id;
  String? name;
  int? capital;
  int? nett;
  int? price;
  int? quantity;
  int? total;
  int? idSupplier;
  String? zone;

  ItemModel({
    this.id,
    this.name,
    this.capital,
    this.nett,
    this.price,
    this.quantity,
    this.total,
    this.idSupplier,
    this.zone,
  });

  ItemModel.formJson(Map<String, dynamic> json) {
    id = json['id_produk'];
    name = json['nama_produk'];
    capital = json['harga_modal'];
    nett = json['nett'];
    price = json['harga_jual'];
    quantity = json['jumlah'];
    total = json['total'];
    idSupplier = json['id_supplier'];
    zone = json['daerah'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id_produk': id,
      'nama_produk': name,
      'harga_modal': capital,
      'nett': nett,
      'harga_jual': price,
      'jumlah': quantity,
      'total': total,
      'id_supplier': idSupplier,
      'daerah': zone,
    };
  }
}
