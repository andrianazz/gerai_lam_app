import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/employee_model.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/models/supplier_model.dart';
import 'package:gerai_lam_app/pages/filter/daily_filter_page.dart';
import 'package:gerai_lam_app/pages/filter/transaction_filter_page.dart';
import 'package:gerai_lam_app/providers/filter_provider.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String> filterList = ['Harian', 'Mingguan', 'Bulanan', 'Tahunan'];
  String? _dropdownFilterList;

  List<ProductModel> products = [];
  String? _dropdownProduct;

  List<EmployeeModel> cashiers = [];
  String? _dropdownCashier;

  List<SupplierModel> suppliers = [];
  String? _dropdownSupplier;

  @override
  void initState() {
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
    await Provider.of<FilterProvider>(context, listen: false).getStruk();
    setState(() {});
  }

  Future<void> getDaily() async {
    await Provider.of<FilterProvider>(context, listen: false).getDaily();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                      hint: Text('Pilih'),
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
                          getDaily();
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
            _dropdownFilterList == "Harian"
                ? DailyFilterPage(
                    cashiers: cashiers,
                  )
                : TransactionFilterPage(),
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
