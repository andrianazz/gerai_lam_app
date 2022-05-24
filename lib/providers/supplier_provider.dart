import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/supplier_model.dart';
import 'package:gerai_lam_app/services/supplier_service.dart';

class SupplierProvider with ChangeNotifier {
  List<SupplierModel> _suppliers = [];

  List<SupplierModel> get suppliers => _suppliers;

  set supliers(List<SupplierModel> suppliers) {
    _suppliers = suppliers;
    notifyListeners();
  }

  Future<void> getSuppliers() async {
    try {
      List<SupplierModel> suppliers = await SupplierService().getSuppliers();
      _suppliers = suppliers;
    } catch (e) {
      print(e);
    }
  }
}
