import 'item_model.dart';

class TransactionModel {
  String? id;
  DateTime? date;
  String? idCostumer;
  String? address;
  List<ItemModel>? items;
  int? totalProducts;
  int? pay;
  int? totalTransaction;
  String? idCashier;
  String? payment;
  int? ongkir;
  String? status;
  String? keterangan;
  String? resi;

  TransactionModel({
    this.id,
    this.date,
    this.idCostumer,
    this.address,
    this.items,
    this.totalProducts,
    this.pay,
    this.totalTransaction,
    this.idCashier,
    this.payment,
    this.ongkir,
    this.status,
    this.keterangan,
    this.resi,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['tanggal'].toDate();
    idCostumer = json['id_customer'];
    address = json['address'];
    items = json['items']
        .map<ItemModel>((item) => ItemModel.fromJson(item))
        .toList();
    totalProducts = json['total_produk'];
    pay = json['bayar'];
    totalTransaction = json['total_transaksi'];
    idCashier = json['id_kasir'];
    payment = json['payment'];
    ongkir = json['ongkir'];
    status = json['status'];
    keterangan = json['keterangan'];
    resi = json['resi'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': date.toString(),
      'id_customer': idCostumer,
      'address': address,
      'items': items!.map((item) => item.toJson()).toList(),
      'total_produk': totalProducts,
      'bayar': pay,
      'total_transaksi': totalTransaction,
      'id_kasir': idCashier,
      'payment': payment,
      'ongkir': ongkir,
      'status': status,
      'keterangan': keterangan,
      'resi': resi,
    };
  }
}
