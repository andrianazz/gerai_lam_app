import 'package:gerai_lam_app/models/cashier_model.dart';
import 'package:gerai_lam_app/models/employee_model.dart';
import 'package:gerai_lam_app/models/stock_in_model.dart';
import 'package:gerai_lam_app/models/stock_return_model.dart';

class StockCashierModel {
  CashierModel? cashier_in;
  CashierModel? cashier_out;
  DateTime? date_in;
  String? description;
  String? noFaktur;
  List<StockInModel>? stock_in;
  List<StockReturnModel>? stock_out;
  String? time_in;

  StockCashierModel({
    this.cashier_in,
    this.cashier_out,
    this.date_in,
    this.description,
    this.noFaktur,
    this.stock_in,
    this.stock_out,
    this.time_in,
  });

  StockCashierModel.fromJson(Map<String, dynamic> json) {
    cashier_in = CashierModel.fromJson(json['cashier_in']);
    cashier_out = CashierModel.fromJson(json['cashier_out']);
    date_in = json['date_in'].toDate();
    description = json['description'];
    noFaktur = json['noFaktur'];
    stock_in = json['stock_in']
        .map<StockInModel>((item) => StockInModel.fromJson(item))
        .toList();
    stock_out = json['stock_return']
        .map<StockReturnModel>((item) => StockReturnModel.fromJson(item))
        .toList();
    time_in = json['time'];
  }

  Map<String, dynamic> toJson() {
    return {
      'cashier_in': cashier_in!.toJson(),
      'cashier_out': cashier_out!.toJson(),
      'date_in': date_in.toString(),
      'description': description,
      'noFaktur': noFaktur,
      'stock_in': stock_in!.map((e) => e.toJson()).toList(),
      'stock_return': stock_out!.map((e) => e.toJson()).toList(),
      'time_in': time_in,
    };
  }
}
