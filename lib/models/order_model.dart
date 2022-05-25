import 'package:gerai_lam_app/models/product_model.dart';

class OrderModel {
  int? id;
  int? qty;
  int? idProduct;
  ProductModel? product;

  OrderModel({this.id, this.qty, this.product, this.idProduct});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qty = json['qty'];
    idProduct = json['idProduct'];
    product = ProductModel.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
      'idProduct': idProduct,
      'product': product?.toJson(),
    };
  }
}
