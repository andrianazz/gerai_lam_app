import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getProducts() async {
    try {
      CollectionReference products = _firestore.collection('product');
      List<ProductModel> product = [];
      await products.get().then((snapshot) => snapshot.docs.forEach((doc) {
            product
                .add(ProductModel.fromJson(doc.data() as Map<String, dynamic>));
          }));
      return product;
    } catch (e) {
      print(e);
      print(e.toString());
      return [];
    }
  }
}
