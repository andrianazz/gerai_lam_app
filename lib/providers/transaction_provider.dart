import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/services/transaction_service.dart';
import 'package:uuid/uuid.dart';

import '../models/item_model.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  set transactions(List<TransactionModel> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  Future<void> getTransaction() async {
    try {
      List<TransactionModel> transactions =
          await TransactionService().getTransactions();
      _transactions = transactions;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getTransactionOnline() async {
    try {
      List<TransactionModel> transactions =
          await TransactionService().getTransactionsOnline();
      _transactions = transactions;
    } catch (e) {
      print(e);
    }
  }

  addTransactions(List<ItemModel> carts, String payment, int ongkir, int bayar,
      int total) async {
    CollectionReference ref = firestore.collection('transactions');
    ref.get().then((snap) {
      _transactions.add(
        TransactionModel(
            id: Uuid().v1(),
            idCashier: 1,
            payment: payment,
            date: DateTime.now(),
            address: 'JL. Nelayan',
            idCostumer: "0",
            items: carts,
            totalProducts: carts.length,
            pay: bayar,
            totalTransaction: total,
            status: 'Proses',
            ongkir: ongkir,
            keterangan: ''),
      );
      print(_transactions);
    });
  }
}
