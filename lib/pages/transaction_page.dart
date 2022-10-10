import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/employee_model.dart';
import 'package:gerai_lam_app/models/filter_model.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/models/supplier_model.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';
import 'package:gerai_lam_app/providers/filter_provider.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../theme.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String> filterList = ['Harian', 'Bulanan', 'Tahunan'];
  String? _dropdownFilterList = "Harian";

  List<ProductModel> products = [];
  ProductModel? _dropdownProduct;

  List<EmployeeModel> cashiers = [];
  EmployeeModel? _dropdownCashier;

  List<SupplierModel> suppliers = [];
  SupplierModel? _dropdownSupplier;

  @override
  void initState() {
    super.initState();
    getDaily();
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

  Future<void> getDaily(
      {ProductModel? product,
      SupplierModel? supplier,
      EmployeeModel? cashier}) async {
    await Provider.of<FilterProvider>(context, listen: false).getDaily(
        filterProduct: product,
        filterSupplier: supplier,
        filterChasier: cashier);
    setState(() {});
  }

  Future<void> getMonthly(
      {ProductModel? product,
      SupplierModel? supplier,
      EmployeeModel? cashier}) async {
    await Provider.of<FilterProvider>(context, listen: false).getMonthly(
        filterProduct: product,
        filterSupplier: supplier,
        filterCashier: cashier);
    setState(() {});
  }

  Future<void> getAnnual(
      {ProductModel? product,
      SupplierModel? supplier,
      EmployeeModel? cashier}) async {
    await Provider.of<FilterProvider>(context, listen: false).getAnnual(
        filterProduct: product,
        filterSupplier: supplier,
        filterCashier: cashier);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FilterProvider fProvider = Provider.of<FilterProvider>(context);
    List<FilterModel>? trans = fProvider.dataTable;
    DTS dts = DTS(transDTS: trans);

    List<FilterModel> reversedList = new List.from(trans.reversed);

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
                          _dropdownFilterList = selected as String;
                        });
                        getData(
                          filter: selected as String,
                          product: _dropdownProduct,
                          supplier: _dropdownSupplier,
                        );
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
                          .map((item) => DropdownMenuItem<ProductModel>(
                                child: Container(
                                  width: 200,
                                  child: Text(
                                    item.nama!,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                value: item,
                              ))
                          .toList(),
                      onChanged: (selected) {
                        setState(() {
                          _dropdownProduct = selected as ProductModel;
                        });

                        print(_dropdownFilterList);

                        getData(
                          filter: _dropdownFilterList,
                          product: _dropdownProduct,
                        );
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
                          .map((item) => DropdownMenuItem<EmployeeModel>(
                                child: Container(
                                  width: 140,
                                  child: Text(
                                    item.name!,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                ),
                                value: item,
                              ))
                          .toList(),
                      onChanged: (selected) {
                        setState(() {
                          _dropdownCashier = selected as EmployeeModel;
                        });

                        print(_dropdownFilterList);

                        getData(
                          filter: _dropdownFilterList,
                          cashier: _dropdownCashier,
                        );
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
                          .map((item) => DropdownMenuItem<SupplierModel>(
                                child: Container(
                                  width: 140,
                                  child: Text(
                                    item.name!,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                  ),
                                ),
                                value: item,
                              ))
                          .toList(),
                      onChanged: (selected) {
                        setState(() {
                          _dropdownSupplier = selected as SupplierModel;
                        });

                        print(_dropdownSupplier);

                        getData(
                          filter: _dropdownFilterList,
                          supplier: _dropdownSupplier,
                        );
                      }),
                ),
                Expanded(child: Container()),
                IconButton(
                    onPressed: () {
                      refresh();
                    },
                    icon: Icon(Icons.refresh_outlined)),
                // ElevatedButton.icon(
                //   style: ElevatedButton.styleFrom(
                //     primary: primaryColor,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                //   ),
                //   onPressed: () {},
                //   icon: Icon(
                //     Icons.print,
                //   ),
                //   label: Text("Print PDF"),
                // )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: ListView(
                      children: [
                        PaginatedDataTable(
                            header: const Text('Transaksi per Struk'),
                            rowsPerPage: 10,
                            columns: [
                              DataColumn(label: Text('Tanggal')),
                              DataColumn(
                                  label: Text(_dropdownProduct != null
                                      ? 'Harga Barang'
                                      : 'Banyak Items')),
                              DataColumn(label: Text('Total Barang')),
                              DataColumn(label: Text('Total Transaksi')),
                            ],
                            source: dts),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              // Chart title
                              title: ChartTitle(
                                text:
                                    'Laporan ${_dropdownFilterList} \n Total Transaksi',
                                textStyle: TextStyle(
                                  color: Color.fromARGB(255, 74, 39, 136),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              // Enable legend
                              legend: Legend(isVisible: false),
                              // Enable tooltip
                              tooltipBehavior: TooltipBehavior(),
                              series: <LineSeries<FilterModel, String>>[
                                LineSeries<FilterModel, String>(
                                    name: 'Total Transaksi',
                                    dataSource: reversedList,
                                    xValueMapper: (FilterModel filter, _) =>
                                        filter.column1.toString(),
                                    yValueMapper: (FilterModel filter, _) =>
                                        num.parse(filter.column4!
                                            .replaceAll("Rp. ", "")
                                            .replaceAll(".", "")
                                            .toString()),
                                    markerSettings:
                                        MarkerSettings(isVisible: true),
                                    width: 3,
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              // Chart title
                              title: ChartTitle(
                                text:
                                    'Laporan ${_dropdownFilterList} \n Total Barang',
                                textStyle: TextStyle(
                                  color: Color.fromARGB(255, 74, 39, 136),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              // Enable legend
                              legend: Legend(isVisible: false),
                              // Enable tooltip
                              tooltipBehavior: TooltipBehavior(),
                              series: <LineSeries<FilterModel, String>>[
                                LineSeries<FilterModel, String>(
                                    name: 'Total Barang',
                                    color: greenColor,
                                    dataSource: reversedList,
                                    xValueMapper: (FilterModel filter, _) =>
                                        filter.column1.toString(),
                                    yValueMapper: (FilterModel filter, _) =>
                                        num.parse(filter.column3!
                                            .replaceAll("Rp. ", "")
                                            .replaceAll(".", "")
                                            .toString()),
                                    markerSettings:
                                        MarkerSettings(isVisible: true),
                                    width: 3,
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: true))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getData(
      {String? filter,
      ProductModel? product,
      SupplierModel? supplier,
      EmployeeModel? cashier}) {
    switch (filter.toString()) {
      case "Harian":
        getDaily(product: product, supplier: supplier, cashier: cashier);
        setState(() {});
        break;
      case "Bulanan":
        getMonthly(product: product, supplier: supplier, cashier: cashier);
        setState(() {});
        break;
      case "Tahunan":
        getAnnual(product: product, supplier: supplier, cashier: cashier);
        setState(() {});
        break;
      default:
    }
  }

  void refresh() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TransactionPage()));
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
  List<FilterModel>? transDTS;
  DTS({this.transDTS});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text('${transDTS![index].column1}')),
      DataCell(Text('${transDTS![index].column2}')),
      DataCell(Text('${transDTS![index].column3}')),
      DataCell(Text('${transDTS![index].column4}')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => transDTS!.length;

  @override
  int get selectedRowCount => 0;
}
