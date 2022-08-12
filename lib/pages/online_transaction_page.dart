import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';
import 'package:gerai_lam_app/providers/transaction_provider.dart';
import 'package:gerai_lam_app/widgets/bayar_dialog.dart';
import 'package:gerai_lam_app/widgets/detail_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/ongkir_dialog.dart';

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
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OnlineTransactionPage(),
                                  ),
                                );
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

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final rupiah =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
  final angka = NumberFormat.currency(decimalDigits: 0, symbol: '');

  @override
  DataRow? getRow(int index) {
    CollectionReference transStore = firestore.collection('transactions');
    return DataRow(
      cells: [
        DataCell(GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return DetailDialog(
                      trans: transDTS![index],
                    );
                  });
            },
            child: Text(transDTS![index].id!.toString()))),
        DataCell(Text('${rupiah.format(transDTS![index].ongkir)}')),
        DataCell(Center(
          child: Text(
            '${angka.format(transDTS![index].totalProducts)}',
          ),
        )),
        DataCell(Text('${rupiah.format(transDTS![index].pay)}')),
        DataCell(Text('${rupiah.format(transDTS![index].totalTransaction)}')),
        DataCell(
          transDTS![index].status.toString() != "Selesai"
              ? ElevatedButton(
                  onPressed: () {
                    String? ongkir = transDTS![index].ongkir.toString();
                    String? id = transDTS![index].id;

                    showDialog(
                      context: context,
                      builder: (_) => OngkirDialog(
                        id: id,
                        ongkir: ongkir,
                      ),
                    );
                  },
                  child: Text('Ongkir'))
              : ElevatedButton(onPressed: null, child: Text('Ongkir')),
        ),
        DataCell(
          transDTS![index].status.toString() != "Selesai"
              ? ElevatedButton(
                  onPressed: () {
                    String? bayar = transDTS![index].pay.toString();
                    String? id = transDTS![index].id;

                    showDialog(
                      context: context,
                      builder: (_) => BayarDialog(
                        id: id,
                        bayar: bayar,
                      ),
                    );
                  },
                  child: Text('Bayar'))
              : ElevatedButton(onPressed: null, child: Text('Bayar')),
        ),
        DataCell(
          transDTS![index].status.toString() != "Selesai"
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
              : transDTS![index].status.toString() == "Bayar"
                  ? Colors.yellow
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
