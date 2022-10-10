import 'package:gerai_lam_app/models/item_model.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';

class AnnualTransModel {
  String? id;
  int? tahun;
  int? bulan;
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

  AnnualTransModel({
    this.id,
    this.tahun,
    this.bulan,
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

  AnnualTransModel.fromTrans(TransactionModel trans) {
    this.tahun = trans.date?.year;
    this.bulan = trans.date?.month;
    //this.idCostumer = trans.idCustomer;
    //this.address = trans.idCustomer;
    this.items = trans.items;
    this.totalProducts = trans.totalProducts;
    this.pay = trans.pay;
    this.totalTransaction = trans.totalTransaction;
    //this.idCashier = trans.idCustomer;
    //this.payment = trans.idCustomer;
    this.ongkir = trans.ongkir;
    //this.status = trans.idCustomer;
    //this.keterangan = trans.idCustomer;
    //this.resi = trans.idCustomer;
  }

  AnnualTransModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tahun = json['tahun'];
    bulan = json['bulan'];
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
      'tahun': tahun,
      'bulan': bulan,
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

  void addTrans(TransactionModel tr) {
    // merge totalProducts
    var _totalProducts =
        this.totalProducts == null ? 0 : this.totalProducts!.toInt();
    _totalProducts += tr.totalProducts == null ? 0 : tr.totalProducts!;
    this.totalProducts = _totalProducts;

    // merge pay
    var _pay = this.pay == null ? 0 : this.pay!.toInt();
    _pay += tr.pay == null ? 0 : tr.pay!;
    this.pay = _pay;

    // merge totalTransaction
    var _totalTransaction =
        this.totalTransaction == null ? 0 : this.totalTransaction!.toInt();
    _totalTransaction += tr.totalTransaction == null ? 0 : tr.totalTransaction!;
    this.totalTransaction = _totalTransaction;

    // merge ongkir
    var _ongkir = this.ongkir == null ? 0 : this.ongkir!.toInt();
    _ongkir += tr.ongkir == null ? 0 : tr.ongkir!;
    this.ongkir = _ongkir;

    var currentItems = tr.items == null ? <ItemModel>[] : tr.items!;
    //currentItems = currentItems == null ? <ItemModel>[] : currentItems;
    var allItems = this.items == null ? <ItemModel>[] : this.items!;
    //allItems = allItems == null ? <ItemModel>[] : allItems;

    // Merge items
    for (int i = 0; i < currentItems.length; i++) {
      int index = -1;
      if (allItems.length > 0) {
        index = (allItems
            .indexWhere((o) => o.idProduk == currentItems[i].idProduk));
      }

      if (index < 0) {
        allItems.add(currentItems[i]);
      } else {
        var qty = allItems[index].quantity!;
        var qty2 = currentItems[i].quantity!;
        qty = qty + qty2;
        allItems[index].quantity = qty;
        var tt1 = allItems[index].total!;
        var tt2 = currentItems[i].total!;
        tt1 += tt2;
        allItems[index].total = tt1;
      }
    }
  }
}
