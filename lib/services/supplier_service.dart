import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/supplier_model.dart';

class SupplierService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SupplierModel>> getSuppliers() async {
    try {
      CollectionReference supplier = _firestore.collection('supplier');
      List<SupplierModel> sup = [];
      await supplier.get().then((snapshot) => snapshot.docs.forEach((doc) {
            supplier.add(doc.data() as Map<String, dynamic>);
          }));
      return sup;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
