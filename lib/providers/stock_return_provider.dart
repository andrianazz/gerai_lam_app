import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/models/stock_in_model.dart';

import '../models/stock_return_model.dart';

class StockReturnProvider with ChangeNotifier {
  List<StockReturnModel> _stockRetn = [];

  List<StockReturnModel> get stockRetn => _stockRetn;

  set stockRetn(List<StockReturnModel> stockRetn) {
    _stockRetn = stockRetn;
    notifyListeners();
  }

  addStockRetn(ProductModel product, int qty) {
    _stockRetn.add(StockReturnModel(
      id: _stockRetn.length,
      harga: product.harga_modal,
      hargaJual: product.harga_jual,
      kode: product.kode,
      nama: product.nama,
      stok: qty,
      total: product.harga_modal! * qty,
    ));

    print(_stockRetn);
  }

  removeStockRetn(int index) {
    _stockRetn.removeAt(index);
    notifyListeners();
  }

  addQuantity(int id, int qty) {
    _stockRetn[id].stok = (_stockRetn[id].stok! + qty);
    _stockRetn[id].total = (_stockRetn[id].harga! * _stockRetn[id].stok!);
    notifyListeners();
  }

  removeQuantity(int id, int qty) {
    if (_stockRetn[id].stok != 1) {
      _stockRetn[id].stok = (_stockRetn[id].stok! - qty);
      _stockRetn[id].total = _stockRetn[id].total! - _stockRetn[id].harga!;
    }
    notifyListeners();
  }

  resetQuantity(int id) {
    _stockRetn[id].stok = 1;
    _stockRetn[id].total = _stockRetn[id].harga;
    notifyListeners();
  }
}
