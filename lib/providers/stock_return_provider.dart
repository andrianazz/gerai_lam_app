import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/product_model.dart';

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
      indexId: _stockRetn.length,
      id: product.id,
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

  addQuantity(int index, int qty) {
    _stockRetn[index].stok = (_stockRetn[index].stok! + qty);
    _stockRetn[index].total =
        (_stockRetn[index].harga! * _stockRetn[index].stok!);
    notifyListeners();
  }

  removeQuantity(int index, int qty) {
    if (_stockRetn[index].stok != 1) {
      _stockRetn[index].stok = (_stockRetn[index].stok! - qty);
      _stockRetn[index].total =
          _stockRetn[index].total! - _stockRetn[index].harga!;
    }
    notifyListeners();
  }

  resetQuantity(int index) {
    _stockRetn[index].stok = 1;
    _stockRetn[index].total = _stockRetn[index].harga;
    notifyListeners();
  }
}
