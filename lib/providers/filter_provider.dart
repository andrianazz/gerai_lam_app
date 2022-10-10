import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/employee_model.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/models/supplier_model.dart';
import 'package:gerai_lam_app/services/filter_service.dart';

import '../models/filter_model.dart';

class FilterProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<FilterModel> _dataTable = [];

  List<FilterModel> get dataTable => _dataTable;

  set dataTable(List<FilterModel> dataTable) {
    _dataTable = dataTable;
    notifyListeners();
  }

  Future<void> getStruk() async {
    try {
      List<FilterModel> dataTable = await FilterService().getStruk();
      _dataTable = dataTable;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getStruk2() async {
    try {
      List<FilterModel> dataTable = await FilterService().getStruk2();
      _dataTable = dataTable;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDaily(
      {ProductModel? filterProduct,
      SupplierModel? filterSupplier,
      EmployeeModel? filterChasier}) async {
    try {
      List<FilterModel> dataTable = await FilterService().getDaily(
        filterProduct: filterProduct,
        filterSupplier: filterSupplier,
        filterCashier: filterChasier,
      );
      _dataTable = dataTable;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getMonthly(
      {ProductModel? filterProduct,
      SupplierModel? filterSupplier,
      EmployeeModel? filterCashier}) async {
    try {
      List<FilterModel> dataTable = await FilterService().getMonthly(
        filterProduct: filterProduct,
        filterSupplier: filterSupplier,
        filterCashier: filterCashier,
      );
      _dataTable = dataTable;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAnnual(
      {ProductModel? filterProduct,
      SupplierModel? filterSupplier,
      EmployeeModel? filterCashier}) async {
    try {
      List<FilterModel> dataTable = await FilterService().getAnnual(
          filterProduct: filterProduct,
          filterSupplier: filterSupplier,
          filterCashier: filterCashier);
      _dataTable = dataTable;
    } catch (e) {
      print(e);
    }
  }
}
