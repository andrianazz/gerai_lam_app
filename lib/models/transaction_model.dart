import 'package:cloud_firestore/cloud_firestore.dart';

import 'item_model.dart';

class TransactionModel {
  String? id;
  DateTime? date;
  DateTime? payDate;
  String? idCostumer;
  String? address;
  List<ItemModel>? items;
  int? totalProducts;
  int? ppn;
  int? ppl;
  int? subtotal;
  int? pay;
  int? totalTransaction;
  String? idCashier;
  String? payment;
  int? ongkir;
  String? status;
  bool? setOngkir;
  String? keterangan;
  String? resi;

  TransactionModel({
    this.id,
    this.date,
    this.payDate,
    this.idCostumer,
    this.address,
    this.items,
    this.totalProducts,
    this.ppn,
    this.ppl,
    this.subtotal,
    this.pay,
    this.totalTransaction,
    this.idCashier,
    this.payment,
    this.ongkir,
    this.status,
    this.setOngkir,
    this.keterangan,
    this.resi,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // date = json['tanggal'].toDate();
    // payDate = json['tgl_bayar'].toDate();
    date = (json['tanggal'] as Timestamp).toDate();
    payDate = json["tgl_bayar"] == null
        ? (json['tanggal'] as Timestamp).toDate()
        : (json['tgl_bayar'] as Timestamp).toDate();
    idCostumer = json['id_customer'];
    address = json['address'] ?? "";
    items = json['items']
        .map<ItemModel>((item) => ItemModel.fromJson(item))
        .toList();
    totalProducts = json['total_produk'];
    ppn = json['ppn'];
    ppl = json['ppl'];
    subtotal = json['subtotal'];
    pay = json['bayar'];
    totalTransaction = json['total_transaksi'];
    idCashier = json['id_kasir'];
    payment = json['payment'];
    ongkir = json['ongkir'];
    status = json['status'];
    setOngkir = json['setOngkir'] ?? false;
    keterangan = json['keterangan'];
    resi = json['resi'] ?? '';
  }

  TransactionModel.fromJsonWithoutPayDate(Map<String, dynamic> json) {
    id = json['id'];
    date = json['tanggal'].toDate();
    // payDate = json['tgl_bayar'].toDate();
    idCostumer = json['id_customer'];
    address = json['address'] ?? "";
    items = json['items']
        .map<ItemModel>((item) => ItemModel.fromJson(item))
        .toList();
    totalProducts = json['total_produk'];
    ppn = json['ppn'];
    ppl = json['ppl'];
    subtotal = json['subtotal'];
    pay = json['bayar'];
    totalTransaction = json['total_transaksi'];
    idCashier = json['id_kasir'];
    payment = json['payment'];
    ongkir = json['ongkir'];
    status = json['status'];
    setOngkir = json['setOngkir'] ?? false;
    keterangan = json['keterangan'];
    resi = json['resi'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': date.toString(),
      'tgl_bayar': payDate.toString(),
      'id_customer': idCostumer,
      'address': address,
      'items': items!.map((item) => item.toJson()).toList(),
      'total_produk': totalProducts,
      'ppn': ppn,
      'ppl': ppl,
      'subtotal': subtotal,
      'bayar': pay,
      'total_transaksi': totalTransaction,
      'id_kasir': idCashier,
      'payment': payment,
      'ongkir': ongkir,
      'status': status,
      'setOngkir': setOngkir,
      'keterangan': keterangan,
      'resi': resi,
    };
  }
}
