import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/stock_in_model.dart';
import 'package:gerai_lam_app/models/stock_model.dart';
import 'package:gerai_lam_app/models/stock_return_model.dart';
import 'package:gerai_lam_app/services/stock_service.dart';

class StockProvider with ChangeNotifier {
  List<StockModel> _stocks = [];

  List<StockModel> get stocks => _stocks;

  set stocks(List<StockModel> stocks) {
    _stocks = stocks;
    notifyListeners();
  }

  Future<void> getStock() async {
    try {
      List<StockModel> stocks = await StockService().getStock();
      _stocks = stocks;
    } catch (e) {
      print(e);
    }
  }

  Future<void> addStock(
    List<StockInModel> stockIn,
    List<StockReturnModel> stockReturn,
    String faktur,
    String deskripsi,
    DateTime dateIn,
    TimeOfDay timeIn,
    String supplier,
  ) async {
    _stocks.add(
      StockModel(
          noFaktur: faktur,
          description: deskripsi,
          dateIn: dateIn,
          timeIn: timeIn,
          supplier: supplier,
          stockIn: stockIn,
          stockReturn: stockReturn),
    );
  }
}
