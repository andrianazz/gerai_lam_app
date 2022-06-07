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
    DTS dts = DTS(transDTS: trans);

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Transaksi Online'),
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
                        DataColumn(label: Text('Kode Transaksi')),
                        DataColumn(label: Text('Ongkir')),
                        DataColumn(label: Text('Total Barang')),
                        DataColumn(label: Text('Total Harga')),
                        DataColumn(label: Text('Edit Ongkir')),
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
  DTS({this.transDTS});

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final rupiah =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
  final angka = NumberFormat.currency(decimalDigits: 0, symbol: '');

  @override
  DataRow? getRow(int index) {
    CollectionReference transStore = firestore.collection('transactions');
    return DataRow(
      cells: [
        DataCell(Text(transDTS![index].id!)),
        DataCell(Text('${rupiah.format(transDTS![index].ongkir)}')),
        DataCell(Center(
          child: Text(
            '${angka.format(transDTS![index].totalProducts)}',
          ),
        )),
        DataCell(Text('${rupiah.format(transDTS![index].totalTransaction)}')),
        DataCell(
          transDTS![index].status.toString() == "Proses"
              ? ElevatedButton(onPressed: () {}, child: Text('Ganti Ongkir'))
              : ElevatedButton(onPressed: null, child: Text('Ganti Ongkir')),
        ),
        DataCell(
          transDTS![index].status.toString() == "Proses"
              ? ElevatedButton(
                  onPressed: () {
                    transStore
                        .doc('PR-${transDTS![index].id.toString()}')
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
