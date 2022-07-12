import 'package:blue_thermal_printer/blue_thermal_printer.dart';
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
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    getDevices();
    getPpnPpl();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  Future<void> getPpnPpl() async {
    await firestore.collection('settings').doc('galerilam').get().then((value) {
      setState(() {
        ppn = value['ppn'];
        ppl = value['ppl'];
      });
    });
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
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: 800,
                      height: 500,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Printer Thermal",
                            style: primaryText.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Column(
                            children: devices
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () {
                                      testPrint(e);
                                      Navigator.pop(context);
                                    },
                                    child: ListTile(
                                      title: Text(e.name!),
                                      subtitle: Text(e.address!),
                                      leading: Icon(Icons.print),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
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

  void testPrint(BluetoothDevice device) async {
    TransactionProvider tProvider = Provider.of<TransactionProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    String total = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: 'Rp. ',
    ).format(tProvider.transactions[0].totalTransaction);
    String ongkir = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: 'Rp. ',
    ).format(tProvider.transactions[0].ongkir);
    String bayar = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: 'Rp. ',
    ).format(tProvider.transactions[0].pay);
    String kembalian = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: 'Rp. ',
    ).format(tProvider.transactions[0].pay! -
        tProvider.transactions[0].totalTransaction!);

    printer.connect(device);
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

    if ((await printer.isConnected)!) {
      printer.printNewLine();
      printer.printCustom("Galeri LAM Riau", 3, 1);
      printer.printCustom("Jl. Diponegoro, Suka Mulia,", 1, 1);
      printer.printCustom("Kec. Sail, Kota Pekanbaru", 1, 1);
      printer.printCustom("Riau 28156", 1, 1);
      printer.printCustom("www.galerilamriau.com", 1, 1);
      printer.printCustom("www.galerilamriau.com", 1, 1);
      printer.printCustom("==========================================", 0, 2);
      //bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      printer.printCustom("No Struk : ${tProvider.transactions[0].id}", 1, 1);
      printer.printCustom("==========================================", 0, 2);
      printer.printNewLine();
      cartProvider.carts.map((e) {
        printer.printLeftRight("${e.name}", "", 1);
        printer.print4Column(
            "   ${e.price}}", "x${e.quantity}", ":", "${e.total}", 1);
      }).toList();
      printer.printCustom("-----------------------------------------", 0, 2);
      printer.printLeftRight("ongkir", "${ongkir}", 1);
      printer.printLeftRight("ppn", "${(ppn / 100 * (widget.subTotal!))}", 2);
      printer.printLeftRight("ppl", "${(ppl / 100 * (widget.subTotal!))}", 2);
      printer.printLeftRight("kode unik", "${widget.kodeUnik}", 2);
      printer.printLeftRight("Total", "${total}", 1);
      printer.printLeftRight("Bayar", "${bayar}", 1);
      printer.printLeftRight("Kembalian", '${kembalian}', 1);
      printer.printNewLine();
      printer.printQRcode("https://galerilamriau.com", 200, 200, 1);
      printer.printCustom("Terima kasih", 1, 1);
      printer.printCustom("Semoga puas dengan pelayanan kami", 0, 1);
      printer.paperCut();
    }
  }
}
