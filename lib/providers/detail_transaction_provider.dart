import 'package:flutter/cupertino.dart';
import 'package:gerai_lam_app/services/detail_transaction_service.dart';

import '../models/detail_transaction_model.dart';

class DetailTransactionProvider with ChangeNotifier {
  List<DetailTransactionModel> _detailTransactions = [];

  List<DetailTransactionModel> get detailTransactions => _detailTransactions;

  set detailTransactions(List<DetailTransactionModel> detailTransactions) {
    _detailTransactions = detailTransactions;
    notifyListeners();
  }

  Future<void> getProducts() async {
    try {
      List<DetailTransactionModel> detailTransactions =
          await DetailTransactionService().getDetailTransactions();
      _detailTransactions = detailTransactions;
    } catch (e) {
      print(e.toString());
    }
  }
}
