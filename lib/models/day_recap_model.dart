import 'package:gerai_lam_app/models/item_model.dart';

class DayRecapModel {
  DateTime? tanggal;
  num? totalProduk;
  num? totalTransaksi;
  List<ItemModel>? items;

  DayRecapModel({
    this.tanggal,
    this.totalProduk,
    this.totalTransaksi,
    this.items,
  });

  DayRecapModel.fromJson(Map<String, dynamic> json) {
    tanggal = json['tanggal'].toDate();
    totalProduk = num.parse(json['total_produk']);
    totalTransaksi = num.parse(json['total_transaksi']);
    items = json['items']
        .map<ItemModel>((item) => ItemModel.fromJson(item))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal.toString(),
      'total_produk': totalProduk,
      'total_transaksi': totalTransaksi,
      'items': items!.map((item) => item.toJson()).toList(),
    };
  }
}
