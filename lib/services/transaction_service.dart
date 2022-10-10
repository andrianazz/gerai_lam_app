import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';

class TransactionService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<TransactionModel>> getTransactions() async {
    List<TransactionModel> transactions = [];
    try {
      await firestore.collection("transactions").get().then((snapshot) {
        snapshot.docs.forEach((doc) {
          transactions.add(
              TransactionModel.fromJson(doc.data() as Map<String, dynamic>));
        });
      });

      return transactions;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<TransactionModel>> getTransactionsOnline() async {
    List<TransactionModel> transactions = [];
    try {
      await firestore
          .collection("transactions")
          .where('id_customer', isNotEqualTo: '0')
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          transactions.add(
              TransactionModel.fromJson(doc.data() as Map<String, dynamic>));
        });
      });

      transactions.sort((a, b) => a.date!.compareTo(b.date!));
      transactions.sort((a, b) => a.status!.compareTo(b.status!));

      return transactions;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
