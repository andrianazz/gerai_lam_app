import 'package:gerai_lam_app/models/supplier_model.dart';

class ItemModel {
  int? id;
  String? name;
  int? capital;
  int? nett;
  int? price;
  int? quantity;
  int? total;
  int? idSupplier;
  String? zone;

  ItemModel({
    this.id,
    this.name,
    this.capital,
    this.nett,
    this.price,
    this.quantity,
    this.total,
    this.idSupplier,
    this.zone,
  });
}
