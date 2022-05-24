import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/employee_model.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/models/supplier_model.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<String> filterList = ['Harian', 'Mingguan', 'Bulanan', 'Tahunan'];
  String? _dropdownFilterList = 'Harian';

  List<ProductModel> products = mockProduct;
  String? _dropdownProduct = 'Wortel Segar';

  List<EmployeeModel> cashiers = mockEmployee;
  String? _dropdownCashier = 'kasir1';

  List<SupplierModel> suppliers = mockSupplier;
  String? _dropdownSupplier = 'Bambang Suparman';

  final dts = DTS();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('History Transaksi'),
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
                  width: 240,
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'Produk',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: _dropdownProduct,
                      items: products
                          .map((item) => DropdownMenuItem<String>(
                                child: Text(
                                  item.nama!,
                                  overflow: TextOverflow.clip,
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
                      decoration: InputDecoration(
                        labelText: 'Kasir',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: _dropdownCashier,
                      items: cashiers
                          .map((item) => DropdownMenuItem<String>(
                                child: Text(
                                  item.id.toString(),
                                  overflow: TextOverflow.clip,
                                ),
                                value: item.id.toString(),
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
                      items: suppliers
                          .map((item) => DropdownMenuItem<String>(
                                child: Text(
                                  item.name!,
                                  overflow: TextOverflow.clip,
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
                    columns: [
                      DataColumn(label: Text('Tanggal')),
                      DataColumn(label: Text('Total Kasir')),
                      DataColumn(label: Text('Total Barang')),
                      DataColumn(label: Text('Total Global')),
                    ],
                    source: dts),
              ],
            ))
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
  List<Map<String, dynamic>> transactions = [
    {
      'date': DateTime.now(),
      'totalCashier': 10000000,
      'totalProduct': 350,
      'totalGlobal': 350000000,
    },
    {
      'date': DateTime.now(),
      'totalCashier': 250000,
      'totalProduct': 200,
      'totalGlobal': 350000000,
    },
    {
      'date': DateTime.now(),
      'totalCashier': 1500500,
      'totalProduct': 2000,
      'totalGlobal': 350000000,
    },
  ];

  final rupiah =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
  final angka = NumberFormat.currency(decimalDigits: 0, symbol: '');

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(transactions[index]['date'].toString())),
      DataCell(Text('${rupiah.format(transactions[index]['totalCashier'])}')),
      DataCell(Text('${angka.format(transactions[index]['totalProduct'])}')),
      DataCell(Text('${rupiah.format(transactions[index]['totalGlobal'])}')),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => transactions.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
