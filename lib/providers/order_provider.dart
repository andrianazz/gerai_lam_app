import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';
import 'package:uuid/uuid.dart';

import '../models/item_model.dart';

class OrderProvider with ChangeNotifier {
  List<TransactionModel> _table = [];
  List<TransactionModel> get table => _table;

  List<TransactionModel> _vip = [];
  List<TransactionModel> get vip => _vip;

  List<TransactionModel> _gojek = [];
  List<TransactionModel> get gojek => _gojek;

  //FOR TABLE
  set table(List<TransactionModel> table) {
    _table = table;
    notifyListeners();
  }

  addTable(List<ItemModel> carts) {
    _table.add(TransactionModel(
      id: Uuid().v1(),
      date: DateTime.now(),
      totalProducts: carts.length,
    ));
    _table[_table.length - 1].items = carts;
    _table[_table.length - 1]
        .items!
        .map((e) => print('${e.name} ${e.price}'))
        .toList();
    _table[_table.length - 1].totalTransaction =
        getTotalTable(_table.length - 1);
    notifyListeners();
  }

  deleteTable(String id) {
    _table.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  getTotalTable(int index) {
    int total = 0;
    _table[index].items?.forEach((element) {
      total = total + int.parse(element.total.toString());
    });
    return total;
  }

  //FOR VIP
  set vip(List<TransactionModel> vip) {
    _vip = vip;
    notifyListeners();
  }

  addVip(List<ItemModel> carts) {
    _vip.add(TransactionModel(
      id: Uuid().v1(),
      date: DateTime.now(),
      totalProducts: carts.length,
    ));
    _vip[_vip.length - 1].items = carts;
    _vip[_vip.length - 1]
        .items!
        .map((e) => print('${e.name} ${e.price}'))
        .toList();
    _vip[_vip.length - 1].totalTransaction = getTotalVip(_vip.length - 1);
    notifyListeners();
  }

  deleteVip(String id) {
    _vip.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  getTotalVip(int index) {
    int total = 0;
    _vip[index].items?.forEach((element) {
      total = total + int.parse(element.total.toString());
    });
    return total;
  }

  //FOR GOJEK
  set gojek(List<TransactionModel> gojek) {
    _gojek = gojek;
    notifyListeners();
  }

  addGojek(List<ItemModel> carts) {
    _gojek.add(TransactionModel(
      id: Uuid().v1(),
      date: DateTime.now(),
      totalProducts: carts.length,
    ));
    _gojek[_gojek.length - 1].items = carts;
    _gojek[_gojek.length - 1]
        .items!
        .map((e) => print('${e.name} ${e.price}'))
        .toList();
    _gojek[_gojek.length - 1].totalTransaction =
        getTotalGojek(_gojek.length - 1);
    notifyListeners();
  }

  deleteGojek(String id) {
    _gojek.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  getTotalGojek(int index) {
    int total = 0;
    _gojek[index].items?.forEach((element) {
      total = total + int.parse(element.total.toString());
    });
    return total;
  }
}
