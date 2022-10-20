import 'package:gerai_lam_app/models/annual_trans_model.dart';
import 'package:gerai_lam_app/models/item_model.dart';
import 'package:gerai_lam_app/models/monthly_transaction_model.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';

class DailyTransactionModel {
  String? id;
  int? tahun;
  int? bulan;
  int? tanggal;
  List<ItemModel>? items;
  int? totalProducts;
  int? pay;
  int? totalTransaction;
  String? idCashier;
  int? ongkir;

  DailyTransactionModel({
    this.id,
    this.tahun,
    this.bulan,
    this.tanggal,
    this.items,
    this.totalProducts,
    this.pay,
    this.totalTransaction,
    this.idCashier,
    this.ongkir,
  });

  DailyTransactionModel.fromTrans(TransactionModel trans) {
    this.tahun = trans.date?.year;
    this.bulan = trans.date?.month;
    this.tanggal = trans.date?.day;
    this.items = trans.items;
    this.totalProducts = trans.totalProducts;
    this.pay = trans.pay;
    this.totalTransaction = trans.totalTransaction;
    this.idCashier = trans.idCashier;
    this.ongkir = trans.ongkir;
  }

  DailyTransactionModel.fromMonthly(MonthlyTransactionModel trans) {
    this.tahun = trans.tahun;
    this.bulan = trans.bulan;
    this.items = trans.items;
    this.totalProducts = trans.totalProducts;
    this.pay = trans.pay;
    this.totalTransaction = trans.totalTransaction;
    this.idCashier = trans.idCashier;
    this.ongkir = trans.ongkir;
  }

  DailyTransactionModel.fromAnnual(AnnualTransModel trans) {
    this.tahun = trans.tahun;
    this.bulan = trans.bulan;
    this.items = trans.items;
    this.totalProducts = trans.totalProducts;
    this.pay = trans.pay;
    this.totalTransaction = trans.totalTransaction;
    this.idCashier = trans.idCashier;
    this.ongkir = trans.ongkir;
  }

  DailyTransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tahun = json['tahun'];
    bulan = json['bulan'];
    tanggal = json['tanggal'];

    items = json['items']
        .map<ItemModel>((item) => ItemModel.fromJson(item))
        .toList();
    totalProducts = json['total_produk'];
    pay = json['bayar'];
    totalTransaction = json['total_transaksi'];
    idCashier = json['id_kasir'];
    ongkir = json['ongkir'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tahun': tahun,
      'bulan': bulan,
      'tanggal': tanggal,
      'items': items!.map((item) => item.toJson()).toList(),
      'total_produk': totalProducts,
      'bayar': pay,
      'total_transaksi': totalTransaction,
      'id_kasir': idCashier,
      'ongkir': ongkir,
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
