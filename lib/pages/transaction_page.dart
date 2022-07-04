import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/employee_model.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/models/supplier_model.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../theme.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String> filterList = ['Harian', 'Mingguan', 'Bulanan', 'Tahunan'];
  String? _dropdownFilterList = 'Harian';

  List<ProductModel> products = [];
  String? _dropdownProduct;

  List<EmployeeModel> cashiers = [];
  String? _dropdownCashier;

  List<SupplierModel> suppliers = [];
  String? _dropdownSupplier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInit();
    getAll();
  }

  getAll() {
    firestore
        .collection('supplier')
        .orderBy('name')
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              setState(() {
                suppliers.add(
                    SupplierModel.fromJson(doc.data() as Map<String, dynamic>));
              });
            }));

    firestore
        .collection('product')
        .orderBy('nama')
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              setState(() {
                products.add(
                    ProductModel.fromJson(doc.data() as Map<String, dynamic>));
              });
            }));

    firestore
        .collection('employees')
        .orderBy('name')
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              setState(() {
                cashiers.add(
                    EmployeeModel.fromJson(doc.data() as Map<String, dynamic>));
              });
            }));
  }

  Future<void> getInit() async {
    await Provider.of<TransactionProvider>(context, listen: false)
        .getTransaction();

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
        title: Text('Rincian Transaksi'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Filter',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: _dropdownFilterList,
                      items: filterList
                          .map((item) => DropdownMenuItem<String>(
                                child: Text(item),
                                value: item,
                              ))
                          .toList(),
                      onChanged: (selected) {
                        setState(() {
                          _dropdownFilterList = selected as String?;
                        });
                      }),
                ),
                SizedBox(width: 20),
                Container(
                  width: 250,
                  child: DropdownButtonFormField(
                      hint: Text("Semua Produk"),
                      decoration: InputDecoration(
                        labelText: 'Produk',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: _dropdownProduct,
                      items: products
                          .map((item) => DropdownMenuItem<String>(
                                child: Container(
                                  width: 200,
                                  child: Text(
                                    item.nama!,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                value: item.nama,
                              ))
                          .toList(),
                      onChanged: (selected) {
                        setState(() {
                          _dropdownProduct = selected as String?;
                        });
                      }),
                ),
                SizedBox(width: 20),
                Container(
                  width: 240,
                  child: DropdownButtonFormField(
                      hint: Text("Semua Kasir"),
                      decoration: InputDecoration(
                        labelText: 'Kasir',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: _dropdownCashier,
                      items: cashiers
                          .map((item) => DropdownMenuItem<String>(
                                child: Container(
                                  width: 140,
                                  child: Text(
                                    item.name!,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                ),
                                value: item.name,
                              ))
                          .toList(),
                      onChanged: (selected) {
                        setState(() {
                          _dropdownCashier = selected as String?;
                        });
                      }),
                ),
                SizedBox(width: 20),
                Container(
                  width: 240,
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Supplier',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: _dropdownSupplier,
                      hint: Text("Semua Supplier"),
                      items: suppliers
                          .map((item) => DropdownMenuItem<String>(
                                child: Container(
                                  width: 140,
                                  child: Text(
                                    item.name!,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                ),
                                value: item.name,
                              ))
                          .toList(),
                      onChanged: (selected) {
                        setState(() {
                          _dropdownSupplier = selected as String?;
                        });
                      }),
                ),
                Expanded(child: Container()),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.print,
                  ),
                  label: Text("Print PDF"),
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  PaginatedDataTable(
                      header: const Text('Transaksi Harian'),
                      rowsPerPage: 10,
                      columns: [
                        DataColumn(label: Text('Tanggal')),
                        DataColumn(label: Text('Total Kasir')),
                        DataColumn(label: Text('Total Barang')),
                        DataColumn(label: Text('Total Global')),
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

class DTS extends DataTableSource {
  List<TransactionModel>? transDTS;
  DTS({this.transDTS});

  final rupiah =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
  final angka = NumberFormat.currency(decimalDigits: 0, symbol: '');

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text('${transDTS![index].date}')),
      DataCell(Text('${rupiah.format(transDTS![index].totalTransaction)}')),
      DataCell(Text('${angka.format(transDTS![index].totalProducts)}')),
      DataCell(Text('${rupiah.format(transDTS![index].totalTransaction)}')),
    ]);
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
