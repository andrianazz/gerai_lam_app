import 'package:gerai_lam_app/models/stock_in_model.dart';
import 'package:gerai_lam_app/models/stock_return_model.dart';

class StockModel {
  String? noFaktur;
  String? supplier;
  DateTime? dateIn;
  String? timeIn;
  List<StockInModel>? stockIn;
  List<StockReturnModel>? stockReturn;
  String? description;

  StockModel({
    this.noFaktur,
    this.supplier,
    this.dateIn,
    this.timeIn,
    this.stockIn,
    this.stockReturn,
    this.description,
  });

  StockModel.fromJson(Map<String, dynamic> json) {
    noFaktur = json['noFaktur'];
    supplier = json['supplier'];
    dateIn = json['date_in'].toDate();
    timeIn = json['time_in'];
    stockIn = json['stock_in']
        .map<StockInModel>((stockData) => StockInModel.fromJson(stockData))
        .toList;
    stockReturn = json['stockReturn']
        .map<StockReturnModel>(
            (stockData) => StockReturnModel.fromJson(stockData))
        .toList;
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'noFaktur': noFaktur,
      'supplier': supplier,
      'date_in': dateIn.toString(),
      'time_in': timeIn,
      'stock_in': stockIn?.map((stockData) => StockInModel().toJson()).toList(),
      'stockReturn':
          stockReturn?.map((stockData) => StockReturnModel().toJson()).toList(),
      'description': description,
    };
  }
}

List<StockModel> mockStock = [
  StockModel(
    noFaktur: 'FS/SS/0702020221',
    supplier: 'Andrian Wahyu',
    dateIn: DateTime.now(),
    timeIn: '20:00',
    stockIn: [
      mockStockIn[0],
    ],
    stockReturn: [
      mockStockReturn[0],
    ],
    description: '',
  ),
];
