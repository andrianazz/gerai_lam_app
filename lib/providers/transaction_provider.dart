import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gerai_lam_app/models/item_model.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  set transactions(List<TransactionModel> carts) {
    _transactions = transactions;
    notifyListeners();
  }

  addTransactions(
      List<ItemModel> carts, String payment, int ongkir, int total) async {
    CollectionReference ref = firestore.collection('transactions');
    ref.get().then(
          (snap) => _transactions.add(
            TransactionModel(
                id: snap.docs.length,
                idCashier: 1,
                payment: payment,
                date: DateTime.now(),
                address: 'Pekanbaru',
                idCostumer: 0,
                items: carts,
                totalProducts: carts.length,
                totalTransaction: total,
                status: 'Proses',
                ongkir: ongkir,
                keterangan: ''),
          ),
        );
  }
}
