import 'package:flutter/cupertino.dart';
import 'package:gerai_lam_app/models/product_model.dart';

import '../models/item_model.dart';

class CartProvider with ChangeNotifier {
  List<ItemModel> _carts = [];

  List<ItemModel> get carts => _carts;

  set carts(List<ItemModel> carts) {
    _carts = carts;
    notifyListeners();
  }

  addCart(ProductModel product) {
    _carts.add(ItemModel(
      id: _carts.length,
      idSupplier: product.supplier!['id'],
      zone: product.supplier!['daerah'],
      name: product.nama,
      capital: product.harga_modal,
      price: product.harga_jual,
      nett: int.parse(product.harga_jual.toString()) -
          int.parse(product.harga_modal.toString()),
      quantity: 1,
      total: product.harga_jual!,
    ));
  }

  removeCart(Map<String, dynamic> product) {
    _carts.removeWhere((item) => item.name == product['nama']);
  }

  addQuantity(int id, int qty) {
    _carts[id].quantity = (_carts[id].quantity! + qty);
    _carts[id].total = (_carts[id].price! * carts[id].quantity!);
    notifyListeners();
  }

  removeQuantity(int id, int qty) {
    if (_carts[id].quantity != 1) {
      _carts[id].quantity = (_carts[id].quantity! - qty);
      _carts[id].total = _carts[id].total! - _carts[id].price!;
    }
    notifyListeners();
  }

  resetQuantity(int id) {
    _carts[id].quantity = 1;
    _carts[id].total = _carts[id].price;
    notifyListeners();
  }

  getTotal() {
    int total = 0;
    _carts.forEach((element) {
      total = total + int.parse(element.total.toString());
    });
    return total;
  }
}