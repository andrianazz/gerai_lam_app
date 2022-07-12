import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerai_lam_app/models/detail_transaction_model.dart';

class DetailTransactionService {
  Future<List<DetailTransactionModel>> getDetailTransactions() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    List<DetailTransactionModel> detailTransactions = [];
    try {
      await firestore
          .collection("transactions")
          .orderBy('tanggal')
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          Map<String, dynamic> transaction = doc.data() as Map<String, dynamic>;

          detailTransactions.add(DetailTransactionModel());
        });
        print(detailTransactions);
      });

      return detailTransactions;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
