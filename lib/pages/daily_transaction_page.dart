import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';
import 'package:gerai_lam_app/widgets/btprint_dialog_struk.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';
import '../widgets/drawer_widget.dart';

class DailyTransactionPage extends StatefulWidget {
  const DailyTransactionPage({Key? key}) : super(key: key);

  @override
  State<DailyTransactionPage> createState() => _DailyTransactionPageState();
}

class _DailyTransactionPageState extends State<DailyTransactionPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TransactionModel? selectedTrans;
  bool _detailStruk = false;

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
    CollectionReference transactions = firestore.collection('transactions');
    DateTime thisDt = DateTime.now();

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text("Transaksi Harian"),
        backgroundColor: primaryColor,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                columnAppbarLeft(context),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tampilan Struk",
                        style: primaryText.copyWith(
                            fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 2 / 3 - 60,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaksi Harian',
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: transactions
                          .orderBy('tanggal', descending: true)
                          .where(
                            "tanggal",
                            isGreaterThan:
                                DateTime(thisDt.year, thisDt.month, 1),
                          )
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            scrollDirection: Axis.vertical,
                            children: snapshot.data!.docs.map((e) {
                              Map<String, dynamic> trans =
                                  e.data() as Map<String, dynamic>;
                              TransactionModel transModel =
                                  TransactionModel.fromJsonWithoutPayDate(
                                      e.data() as Map<String, dynamic>);
                              final f = new DateFormat('dd MMMM yyyy, hh:mm');

                              return Card(
                                child: InkWell(
                                  splashColor: greenColor,
                                  onTap: () {
                                    setState(() {
                                      selectedTrans =
                                          TransactionModel.fromJson(trans);
                                      _detailStruk = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: (selectedTrans != null &&
                                              selectedTrans!.id!
                                                  .contains(trans['id']))
                                          ? secondaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 300,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    f.format(transModel.date!),
                                                    style: primaryText.copyWith(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    overflow: TextOverflow.clip,
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    NumberFormat.simpleCurrency(
                                                      decimalDigits: 0,
                                                      name: 'Rp. ',
                                                    ).format(int.parse(
                                                        trans['total_transaksi']
                                                            .toString())),
                                                    style: primaryText.copyWith(
                                                      color: primaryColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 160,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Produk",
                                                style: primaryText.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: textGreyColor,
                                                ),
                                                overflow: TextOverflow.clip,
                                                maxLines: 1,
                                              ),
                                              Text(
                                                "${trans['total_produk']}",
                                                style: primaryText.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: textGreyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          child: Text(
                                            trans['payment'],
                                            style: primaryText.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: textGreyColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: 120,
                                          child: Text(
                                            trans['status'].toString(),
                                            style: primaryText.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: (transModel.status ==
                                                      "Selesai")
                                                  ? textGreyColor
                                                  : redColor,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("No Data"),
                            ],
                          );
                        }
                      }),
                )
              ],
            ),
          ),
          Expanded(
            child: _detailStruk == true
                ? DetailStruk(context)
                : Container(
                    color: primaryColor,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Image.asset("assets/toko_logo.png"),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget DetailStruk(BuildContext context) {
    int? subTotal = (ppl == 0)
        ? (selectedTrans!.totalTransaction! ~/ (1 + (ppn / 100)))
        : (selectedTrans!.totalTransaction! ~/ (1 + (ppn / 100))) -
            (selectedTrans!.totalTransaction! ~/ (1 + (ppl / 100)));

    int? pajakPPN = (ppn / 100 * (subTotal)).toInt();
    int? pajakPPL = (ppl / 100 * (subTotal)).toInt();

    return Container(
      color: const Color(0xffF6F6F6),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Text(
                            "Sentra Budaya & Ekraf Riau",
                            style: primaryText.copyWith(
                              fontSize: 30,
                              fontWeight: FontWeight.w100,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Jalan Diponegoro, Suka Mulia, Kec. Sail, Kota Pekanbaru, Riau 28127",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "www.galerilamriau.com",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        "No Struk : ${selectedTrans!.id}",
                        style: primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: selectedTrans!.items!
                            .map((e) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${e.name}",
                                      style: primaryText.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${e.price}",
                                          style: primaryText.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                        Text(
                                          "x${e.quantity}",
                                          style: primaryText.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                        Text(
                                          "",
                                          style: primaryText.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                        Text(
                                          "${e.price! * e.quantity!}",
                                          style: primaryText.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ))
                            .toList(),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          Text(
                            "${selectedTrans!.subtotal}",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "PPN",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          Text(
                            "${selectedTrans!.ppn}",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "PPL",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          Text(
                            "${selectedTrans!.ppl}",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    name: "Rp. ", decimalDigits: 0)
                                .format(selectedTrans!.totalTransaction),
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bayar",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    name: "Rp. ", decimalDigits: 0)
                                .format(selectedTrans!.pay),
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Kembalian",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                                    name: "Rp. ", decimalDigits: 0)
                                .format(selectedTrans!.pay! -
                                    selectedTrans!.totalTransaction!),
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Terima kasih",
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Semoga puas dengan pelayanan kami",
                            style: primaryText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w100,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          selectedTrans!.status == "Selesai"
              ? Container(
                  height: 80,
                  color: secondaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => BTPrintDialogStruk(
                              alamat: alamat.toString(),
                              items: selectedTrans!.items,
                              ppl: ppl,
                              ppn: ppn,
                              subtotal: subTotal,
                              trans: selectedTrans,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.print,
                          color: primaryColor,
                        ),
                        label: Text(
                          "Print Ulang",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

Widget columnAppbarLeft(context) {
  return Container(
    width: MediaQuery.of(context).size.width * 2 / 3 - 60,
    child: Container(),
  );
}
