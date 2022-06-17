import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/pages/order_page.dart';
import 'package:gerai_lam_app/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../theme.dart';
import '../widgets/drawer_widget.dart';

class OrderDonePage extends StatefulWidget {
  int? subTotal;
  int? ongkir;
  int? total;
  int? bayar;
  int? kembali;

  OrderDonePage(
      {Key? key,
      this.subTotal,
      this.total,
      this.kembali,
      this.ongkir,
      this.bayar})
      : super(key: key);

  @override
  State<OrderDonePage> createState() => _OrderDonePageState();
}

class _OrderDonePageState extends State<OrderDonePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: const Text("Rincian Pesanan"),
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: landscape(context),
    );
  }

  Widget landscape(context) {
    return Row(
      children: [
        columnLeft(context),
        columnCenter(),
      ],
    );
  }

  Widget columnLeft(context) {
    return Flexible(
      flex: 1,
      child: Column(
        children: [
          payment(context),
          Expanded(
            child: Container(
              color: secondaryColor,
            ),
          ),
          detailPayment(),
          totalPayment(),
        ],
      ),
    );
  }

  Widget columnCenter() {
    return Flexible(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 100,
                      color: primaryColor,
                    ),
                    Text(
                      "Orderan sedang diproses",
                      style: primaryText.copyWith(fontSize: 50),
                    )
                  ],
                ),
              ),
            ),
          ),
          done(),
        ],
      ),
    );
  }

  Widget payment(context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      color: secondaryColor,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  "QTY",
                  style: primaryText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  "Nama Barang",
                  style: primaryText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Harga",
                  style: primaryText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: cartProvider.carts
                .map((order) => Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 41,
                              child: Text(
                                order.quantity.toString(),
                                style: primaryText.copyWith(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                order.name.toString(),
                                style: primaryText.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              NumberFormat.simpleCurrency(
                                decimalDigits: 0,
                                name: 'Rp. ',
                              ).format(order.price),
                              style: primaryText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          height: 1,
                          color: greyColor,
                        )
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget detailPayment() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      color: secondaryBlueColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SUBTOTAL",
                style: primaryText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                NumberFormat.simpleCurrency(
                  decimalDigits: 0,
                  name: 'Rp. ',
                ).format(widget.subTotal),
                style: primaryText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ONGKOS KIRIM",
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  NumberFormat.simpleCurrency(
                    decimalDigits: 0,
                    name: 'Rp. ',
                  ).format(widget.ongkir),
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOTAL (ppn)",
                style: primaryText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                NumberFormat.simpleCurrency(
                  decimalDigits: 0,
                  name: 'Rp. ',
                ).format(widget.total),
                style: primaryText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "BAYAR",
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  NumberFormat.simpleCurrency(
                    decimalDigits: 0,
                    name: 'Rp. ',
                  ).format(widget.bayar),
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget totalPayment() {
    return Container(
      height: 89,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(color: primaryColor, width: 2),
      ),
      child: Row(
        children: [
          Text(
            "KEMBALI",
            style: primaryText.copyWith(
              color: primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              NumberFormat.simpleCurrency(
                decimalDigits: 0,
                name: 'Rp. ',
              ).format(widget.kembali),
              style: primaryText.copyWith(
                color: primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget done() {
    TransactionProvider tProvider = Provider.of<TransactionProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference transactions = firestore.collection('transactions');
    CollectionReference products = firestore.collection('product');

    return Container(
      height: 90,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_print_shop_outlined,
                    color: primaryColor,
                    size: 40,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "CETAK STRUK",
                    style: primaryText.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                cartProvider.carts.map((e) {
                  return products
                      .where('id', isEqualTo: e.idProduk)
                      .get()
                      .then((value) {
                    value.docs.forEach((doc) {
                      Map<String, dynamic> product =
                          doc.data() as Map<String, dynamic>;
                      products.doc(product['kode']).update({
                        'sisa_stok': FieldValue.increment(
                            -num.parse(e.quantity.toString())),
                      });
                    });
                  });
                }).toList();

                transactions
                    .doc('${tProvider.transactions[0].id.toString()}')
                    .set({
                  'id': tProvider.transactions[0].id,
                  'tanggal': tProvider.transactions[0].date,
                  'id_customer': tProvider.transactions[0].idCostumer,
                  'address': tProvider.transactions[0].address,
                  'items': cartProvider.carts.map((e) => e.toJson()).toList(),
                  'total_produk': tProvider.transactions[0].totalProducts,
                  'bayar': tProvider.transactions[0].pay,
                  'total_transaksi': tProvider.transactions[0].totalTransaction,
                  'id_kasir': tProvider.transactions[0].idCashier,
                  'payment': tProvider.transactions[0].payment,
                  'ongkir': tProvider.transactions[0].ongkir,
                  'status': tProvider.transactions[0].status,
                  'keterangan': tProvider.transactions[0].keterangan,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(milliseconds: 1000),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(width: 20),
                        Text(
                          "Menambahkan. Mohon Tunggu .....",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    backgroundColor: primaryColor,
                  ),
                );

                cartProvider.carts.clear();
                tProvider.transactions.clear();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => OrderPage()),
                    (route) => false);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: primaryColor,
                  border: Border.all(
                    color: primaryColor,
                    width: 3,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_print_shop_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "SELESAI",
                      style: primaryText.copyWith(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
