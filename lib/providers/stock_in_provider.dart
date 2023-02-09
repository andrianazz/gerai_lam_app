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
      indexId: _stockIns.length,
      id: product.id,
      harga: product.harga_modal,
      hargaJual: product.harga_jual,
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

  addQuantity(int index, int qty) {
    _stockIns[index].stok = (_stockIns[index].stok! + qty);
    _stockIns[index].total = (_stockIns[index].harga! * _stockIns[index].stok!);
    notifyListeners();
  }

  removeQuantity(int index, int qty) {
    if (_stockIns[index].stok != 1) {
      _stockIns[index].stok = (_stockIns[index].stok! - qty);
      _stockIns[index].total =
          _stockIns[index].total! - _stockIns[index].harga!;
    }
    notifyListeners();
  }

  resetQuantity(int index) {
    _stockIns[index].stok = 1;
    _stockIns[index].total = _stockIns[index].harga;
    notifyListeners();
  }
}
