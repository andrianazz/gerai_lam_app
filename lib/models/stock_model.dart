import 'package:gerai_lam_app/models/stock_in_model.dart';
import 'package:gerai_lam_app/models/stock_return_model.dart';

class StockModel {
  String? noFaktur;
  String? supplier;
  DateTime? date_in;
  String? time_in;
  List<StockInModel>? stock_in;
  List<StockReturnModel>? stock_out;
  String? description;

  StockModel({
    this.noFaktur,
    this.supplier,
    this.date_in,
    this.time_in,
    this.stock_in,
    this.stock_out,
    this.description,
  });

  StockModel.fromJson(Map<String, dynamic> json) {
    supplier = json['supplier']['nama'];
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
      'noFaktur': noFaktur,
      'supplier': supplier,
      'date_in': date_in.toString(),
      'description': description,
      'stock_in': stock_in!.map((e) => e.toJson()).toList(),
      'stock_return': stock_out!.map((e) => e.toJson()).toList(),
      'time_in': time_in,
    };
  }
}
