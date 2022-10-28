import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/pages/order_page.dart';
import 'package:gerai_lam_app/providers/transaction_provider.dart';
import 'package:gerai_lam_app/widgets/btprint_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/cart_provider.dart';
import '../theme.dart';
import '../widgets/drawer_widget.dart';

class OrderDonePage extends StatefulWidget {
  int? subTotal;
  int? ongkir;
  int? total;
  int? bayar;
  int? kembali;
  int? kodeUnik;
  int? ppl;
  int? ppn;

  OrderDonePage({
    Key? key,
    this.subTotal,
    this.total,
    this.kembali,
    this.ongkir,
    this.bayar,
    this.kodeUnik,
    this.ppn,
    this.ppl,
  }) : super(key: key);

  @override
  State<OrderDonePage> createState() => _OrderDonePageState();
}

class _OrderDonePageState extends State<OrderDonePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int ppn = 0;
  int ppl = 0;
  bool api_bandara = false;

  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  String emailKasir = '';
  String alamat = '';
  String token = '';

  @override
  void initState() {
    getAll();
    super.initState();
  }

  Future<void> getAll() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString("email") ?? '';
    String token = pref.getString("token") ?? '';

    setState(() {
      emailKasir = email;
    });

    var setRef = firestore.collection('settings').doc(emailKasir);
    var set2Ref = firestore.collection('settings').doc('galerilam');
    var doc = await setRef.get();
    var doc2 = await set2Ref.get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        print(data['ppn']);
        ppn = data['ppn'];
        ppl = data['ppl'];
        alamat = data['alamat'];
        api_bandara = data['api_bandara'];
      });
    } else if (doc2.exists) {
      Map<String, dynamic> data = doc2.data() as Map<String, dynamic>;
      setState(() {
        ppn = data['ppn'];
        ppl = data['ppl'];
        alamat = data['alamat'];
      });
    }
  }

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
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ExpansionTile(
                tilePadding: EdgeInsets.all(0),
                childrenPadding: EdgeInsets.only(left: 10, bottom: 10),
                title: Text(
                  "RINCIAN BIAYA",
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SUBTOTAL",
                        style: primaryText.copyWith(
                          fontSize: 20,
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
                          fontSize: 20,
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
                            fontSize: 20,
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
                            fontSize: 20,
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
                        "Kode Unik",
                        style: primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                          decimalDigits: 0,
                          name: 'Rp. ',
                        ).format(widget.kodeUnik),
                        style: primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "PPN (${ppn} %)",
                        style: primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                          decimalDigits: 0,
                          name: 'Rp. ',
                        ).format((ppn / 100 * (widget.subTotal!).toInt())),
                        style: primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "PPL (${ppl} %",
                        style: primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        NumberFormat.simpleCurrency(
                          decimalDigits: 0,
                          name: 'Rp. ',
                        ).format((ppl / 100 * widget.subTotal!).toInt()),
                        style: primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
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
            child: GestureDetector(
              onTap: () async {
                // Bluethoot Print (Tested with CashDrawer)
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PrintOrderPage(
                //               alamat: alamat.toString(),
                //               items: cartProvider.carts,
                //               ppl: ppl,
                //               ppn: ppn,
                //               subtotal: widget.subTotal,
                //               trans: tProvider.transactions[0],
                //             )));

                showDialog(
                  context: context,
                  builder: (context) => BTPrintDialog(
                    alamat: alamat.toString(),
                    items: cartProvider.carts,
                    ppl: ppl,
                    ppn: ppn,
                    subtotal: widget.subTotal,
                    trans: tProvider.transactions[0],
                  ),
                );
              },
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
                  'tgl_bayar': tProvider.transactions[0].payDate,
                  'id_customer': tProvider.transactions[0].idCostumer,
                  'address': tProvider.transactions[0].address,
                  'items': cartProvider.carts.map((e) => e.toJson()).toList(),
                  'total_produk': tProvider.transactions[0].totalProducts,
                  'ppn': tProvider.transactions[0].ppn,
                  'ppl': tProvider.transactions[0].ppl,
                  'subtotal': tProvider.transactions[0].subtotal,
                  'bayar': tProvider.transactions[0].pay,
                  'total_transaksi': tProvider.transactions[0].totalTransaction,
                  'id_kasir': tProvider.transactions[0].idCashier,
                  'payment': tProvider.transactions[0].payment,
                  'ongkir': tProvider.transactions[0].ongkir,
                  'status': tProvider.transactions[0].status,
                  'setOngkir': true,
                  'keterangan': tProvider.transactions[0].keterangan,
                });

                if (token.isNotEmpty && api_bandara == true) {
                  DateTime e = tProvider.transactions[0].date as DateTime;

                  String date = DateFormat("yyyy-MM-dd").format(e);

                  var url =
                      "https://api-ecsysdev.angkasapura2.co.id/api/v1/transaction/";
                  var headers = {
                    'Authorization': token,
                    'Content-Type': 'application/json',
                  };

                  var body = jsonEncode({
                    {
                      "store": [
                        {
                          "store_id": "{{store_id}}",
                          "transactions": [
                            for (var cart in cartProvider.carts)
                              {
                                {
                                  "invoice_no":
                                      "${tProvider.transactions[0].id}",
                                  "trans_date": "${date}",
                                  "trans_time":
                                      "${tProvider.transactions[0].date}",
                                  "sequence_unique": "${cart.id}",
                                  "item_name": "${cart.name}",
                                  "item_code": "${cart.idProduk}",
                                  "item_qty": "${cart.quantity}",
                                  "item_price_per_unit": "${cart.price}",
                                  "item_price_amount": "${cart.price}",
                                  "item_vat":
                                      (num.parse(cart.price.toString()) *
                                              ppn *
                                              ppl)
                                          .toString(),
                                  "item_total_price_amount": (num.parse(
                                              cart.price.toString()) *
                                          num.parse(cart.quantity.toString()))
                                      .toString(),
                                  "item_total_vat": "0",
                                  "transaction_amount": (num.parse(
                                              cart.price.toString()) +
                                          (num.parse(cart.price.toString()) *
                                              ppn *
                                              ppl))
                                      .toString(),
                                },
                              }
                          ],
                        }
                      ]
                    }
                  });
                }

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
