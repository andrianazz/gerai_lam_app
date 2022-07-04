import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';
import 'package:gerai_lam_app/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../widgets/drawer_widget.dart';

class OnlineTransactionPage extends StatefulWidget {
  OnlineTransactionPage({Key? key}) : super(key: key);

  @override
  State<OnlineTransactionPage> createState() => _OnlineTransactionPageState();
}

class _OnlineTransactionPageState extends State<OnlineTransactionPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getInit();
  }

  Future<void> getInit() async {
    await Provider.of<TransactionProvider>(context, listen: false)
        .getTransactionOnline();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TransactionProvider tProvider = Provider.of<TransactionProvider>(context);
    List<TransactionModel>? trans = tProvider.transactions;
    DTS dts = DTS(
      transDTS: trans,
      context: context,
    );

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Transaksi Toko Online'),
        backgroundColor: primaryColor,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                columnAppbarLeft(context),
                columnAppbarRight(context),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  PaginatedDataTable(
                      columnSpacing: 10,
                      header: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transaksi Online',
                            style: primaryText.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                print(trans);
                                setState(() {});
                              },
                              icon: Icon(Icons.refresh)),
                        ],
                      ),
                      rowsPerPage: 8,
                      onPageChanged: (value) {
                        setState(() {});
                      },
                      columns: [
                        DataColumn(
                          label: Text('Kode Transaksi'),
                        ),
                        DataColumn(label: Text('Ongkir')),
                        DataColumn(label: Text('Barang')),
                        DataColumn(label: Text('Bayar')),
                        DataColumn(label: Text('Total')),
                        DataColumn(label: Text('Ongkir')),
                        DataColumn(label: Text('Bayar')),
                        DataColumn(label: Text('Selesai')),
                        DataColumn(label: Text('Status')),
                      ],
                      source: dts),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget columnAppbarLeft(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 2 / 3 - 60,
      child: Container(),
    );
  }

  Widget columnAppbarRight(context) {
    return Expanded(child: Container());
  }
}

class DTS extends DataTableSource {
  List<TransactionModel>? transDTS;
  BuildContext context;

  DTS({this.transDTS, required this.context});

  TextEditingController ongkirController = TextEditingController();
  TextEditingController bayarController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final rupiah =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
  final angka = NumberFormat.currency(decimalDigits: 0, symbol: '');

  @override
  DataRow? getRow(int index) {
    CollectionReference transStore = firestore.collection('transactions');
    return DataRow(
      cells: [
        DataCell(Text(transDTS![index].id!.toString())),
        DataCell(Text('${rupiah.format(transDTS![index].ongkir)}')),
        DataCell(Center(
          child: Text(
            '${angka.format(transDTS![index].totalProducts)}',
          ),
        )),
        DataCell(Text('${rupiah.format(transDTS![index].pay)}')),
        DataCell(Text('${rupiah.format(transDTS![index].totalTransaction)}')),
        DataCell(
          transDTS![index].status.toString() == "Proses"
              ? ElevatedButton(
                  onPressed: () {
                    ongkirController.text = transDTS![index].ongkir.toString();

                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          width: 500,
                          height: 800,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: Column(children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: greyColor,
                                    width: 2,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    NumberFormat.currency(
                                            symbol: 'Rp.', decimalDigits: 0)
                                        .format(
                                            int.parse(ongkirController.text)),
                                    style: primaryText.copyWith(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          ongkirController.text =
                                              ongkirController.text + "7";
                                          notifyListeners();
                                          print(ongkirController.text);
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: blueColor,
                                              width: 5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "7",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ongkirController.text =
                                              ongkirController.text + "8";
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "8",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "9",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "4",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "5",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "6",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "1",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "2",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "3",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: blueColor,
                                              width: 5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "0",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: redColor, width: 5),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "RESET",
                                                style: primaryText.copyWith(
                                                  fontSize: 32,
                                                  color: redColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 70,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: redColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "BATAL",
                                          style: primaryText.copyWith(
                                            fontSize: 32,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 70,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: greenColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "SIMPAN",
                                          style: primaryText.copyWith(
                                            fontSize: 32,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                        ),
                      ),
                    );
                  },
                  child: Text('Ongkir'))
              : ElevatedButton(onPressed: null, child: Text('Ongkir')),
        ),
        DataCell(
          transDTS![index].status.toString() == "Proses"
              ? ElevatedButton(
                  onPressed: () {
                    bayarController.text = transDTS![index].pay.toString();

                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          width: 500,
                          height: 800,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: Column(children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: greyColor,
                                    width: 2,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    NumberFormat.currency(
                                            symbol: 'Rp.', decimalDigits: 0)
                                        .format(
                                            int.parse(bayarController.text)),
                                    style: primaryText.copyWith(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          ongkirController.text =
                                              ongkirController.text + "7";
                                          notifyListeners();
                                          print(ongkirController.text);
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: blueColor,
                                              width: 5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "7",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ongkirController.text =
                                              ongkirController.text + "8";
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "8",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "9",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "4",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "5",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "6",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "1",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "2",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: blueColor, width: 5),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "3",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: blueColor,
                                              width: 5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "0",
                                              style: primaryText.copyWith(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: redColor, width: 5),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "RESET",
                                                style: primaryText.copyWith(
                                                  fontSize: 32,
                                                  color: redColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 70,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: redColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "BATAL",
                                          style: primaryText.copyWith(
                                            fontSize: 32,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 70,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: greenColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "SIMPAN",
                                          style: primaryText.copyWith(
                                            fontSize: 32,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                        ),
                      ),
                    );
                  },
                  child: Text('Bayar'))
              : ElevatedButton(onPressed: null, child: Text('Bayar')),
        ),
        DataCell(
          transDTS![index].status.toString() == "Proses"
              ? ElevatedButton(
                  onPressed: () {
                    transStore
                        .doc('${transDTS![index].id.toString()}')
                        .update({'status': 'Selesai'});

                    transDTS![index].status = "Selesai";

                    notifyListeners();
                  },
                  child: Text('Selesai'))
              : ElevatedButton(onPressed: null, child: Text('Selesai')),
        ),
        DataCell(Chip(
          label: Text(
            transDTS![index].status.toString(),
            style: primaryText.copyWith(
              color: transDTS![index].status.toString() == "Selesai"
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          backgroundColor: transDTS![index].status.toString() == "Selesai"
              ? greenColor
              : greyColor,
        )),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => transDTS!.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
