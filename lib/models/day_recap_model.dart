import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerai_lam_app/models/item_model.dart';

class DayRecapModel {
  DateTime? tanggal;
  int? totalProduk;
  num? totalTransaksi;
  List<ItemModel>? items;

  DayRecapModel({
    this.tanggal,
    this.totalProduk,
    this.totalTransaksi,
    this.items,
  });

  DayRecapModel.fromJson(Map<String, dynamic> json) {
    tanggal = (json['tanggal'] as Timestamp).toDate();
    totalProduk = json['total_produk'];
    totalTransaksi = json['total_transaksi'];
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
