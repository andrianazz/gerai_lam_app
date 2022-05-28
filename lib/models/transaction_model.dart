import 'package:gerai_lam_app/models/address_model.dart';
import 'package:gerai_lam_app/models/item_model.dart';

class TransactionModel {
  int? id;
  DateTime? date;
  int? idCostumer;
  String? address;
  List<ItemModel>? items;
  int? totalProducts;
  int? totalTransaction;
  int? idCashier;
  String? payment;
  int? ongkir;
  String? status;
  String? keterangan;

  TransactionModel({
    this.id,
    this.date,
    this.idCostumer,
    this.address,
    this.items,
    this.totalProducts,
    this.totalTransaction,
    this.idCashier,
    this.payment,
    this.ongkir,
    this.status,
    this.keterangan,
  });
}

List<TransactionModel> mockTransaction = [
  TransactionModel(
    id: 1,
    date: DateTime.now(),
    idCostumer: 1,
    address: 'Jl. Nelayan',
    items: [
      ItemModel(
        id: 1,
        name: 'Cabe Segar',
        capital: 5000,
        nett: 1000,
        price: 6000,
        quantity: 2,
        total: 12000,
        idSupplier: 1,
        zone: 'Pekanbaru',
      ),
      ItemModel(
        id: 2,
        name: 'Wortel Segar',
        capital: 3000,
        nett: 500,
        price: 3500,
        quantity: 1,
        total: 3500,
        idSupplier: 1,
        zone: 'Pekanbaru',
      ),
      ItemModel(
        id: 3,
        name: 'Beras Special',
        capital: 10000,
        nett: 2000,
        price: 12000,
        quantity: 1,
        total: 12000,
        idSupplier: 1,
        zone: 'Pekanbaru',
      ),
    ],
    totalProducts: 4,
    totalTransaction: 27500,
    idCashier: 1,
  ),
  TransactionModel(
    id: 1,
    date: DateTime.now(),
    idCostumer: 1,
    address: 'Jl. Rumbai',
    items: [
      ItemModel(
        id: 1,
        name: 'Cabe Segar',
        capital: 5000,
        nett: 1000,
        price: 6000,
        quantity: 1,
        total: 6000,
        idSupplier: 1,
        zone: 'Pekanbaru',
      ),
      ItemModel(
        id: 2,
        name: 'Wortel Segar',
        capital: 3000,
        nett: 500,
        price: 3500,
        quantity: 2,
        total: 7000,
        idSupplier: 1,
        zone: 'Pekanbaru',
      ),
      ItemModel(
        id: 3,
        name: 'Beras Special',
        capital: 10000,
        nett: 2000,
        price: 12000,
        quantity: 1,
        total: 12000,
        idSupplier: 1,
        zone: 'Pekanbaru',
      ),
    ],
    totalProducts: 4,
    totalTransaction: 25000,
    idCashier: 1,
  ),
];
