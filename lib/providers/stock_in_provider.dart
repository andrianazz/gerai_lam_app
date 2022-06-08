import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/models/stock_in_model.dart';

class StockInProvider with ChangeNotifier {
  List<StockInModel> _stockIns = [];

  List<StockInModel> get stockIns => _stockIns;

  set stockIns(List<StockInModel> stockIns) {
    _stockIns = stockIns;
    notifyListeners();
  }

  addStockIn(ProductModel product, int qty) {
    _stockIns.add(StockInModel(
      id: _stockIns.length,
      harga: product.harga_modal,
      kode: product.kode,
      nama: product.nama,
      stok: qty,
      total: product.harga_modal! * qty,
    ));

    print(_stockIns);
  }

  removeStockIn(int index) {
    _stockIns.removeAt(index);
    notifyListeners();
  }

  addQuantity(int id, int qty) {
    _stockIns[id].stok = (_stockIns[id].stok! + qty);
    _stockIns[id].total = (_stockIns[id].harga! * _stockIns[id].stok!);
    notifyListeners();
  }

  removeQuantity(int id, int qty) {
    if (_stockIns[id].stok != 1) {
      _stockIns[id].stok = (_stockIns[id].stok! - qty);
      _stockIns[id].total = _stockIns[id].total! - _stockIns[id].harga!;
    }
    notifyListeners();
  }

  resetQuantity(int id) {
    _stockIns[id].stok = 1;
    _stockIns[id].total = _stockIns[id].harga;
    notifyListeners();
  }
}
