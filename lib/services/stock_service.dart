import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerai_lam_app/models/stock_model.dart';

class StockService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<StockModel>> getStock() async {
    try {
      CollectionReference stock = _firestore.collection('stock');

      List<StockModel> stocks = [];
      await stock.get().then((querySnapshot) => querySnapshot.docs.forEach(
          (doc) => stocks
              .add(StockModel.fromJson(doc.data() as Map<String, dynamic>))));
      print(stocks);
      return stocks;
    } catch (e) {
      print('Gagal get Stock');
      print(e);
      return [];
    }
  }
}
