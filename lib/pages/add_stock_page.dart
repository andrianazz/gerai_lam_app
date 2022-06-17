import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/providers/stock_in_provider.dart';
import 'package:gerai_lam_app/providers/stock_provider.dart';
import 'package:gerai_lam_app/providers/stock_return_provider.dart';
import 'package:gerai_lam_app/widgets/dialog_stock_in.dart';
import 'package:gerai_lam_app/widgets/dialog_stock_return.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/supplier_model.dart';
import '../theme.dart';

class AddStockPage extends StatefulWidget {
  const AddStockPage({Key? key}) : super(key: key);

  @override
  State<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSuppliers();
  }

  Future<void> getSuppliers() async {
    firestore
        .collection('supplier')
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              setState(() {
                supplier.add(SupplierModel.fromJson(doc.data()));
              });
            }));
  }

  TextEditingController noFaktur = TextEditingController();
  List<SupplierModel> supplier = [];
  SupplierModel? _dropdownSupplier;

  DateTime dateIn = DateTime.now();
  TimeOfDay timeIn = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    CollectionReference product = firestore.collection('product');
    String tglMasuk = DateFormat('dd MMMM yyyy').format(dateIn);

    StockProvider stockProvider = Provider.of<StockProvider>(context);
    StockInProvider stockIn = Provider.of<StockInProvider>(context);
    StockReturnProvider stockOut = Provider.of<StockReturnProvider>(context);

    noFaktur.text = Uuid().v1();

    CollectionReference stocksStore = firestore.collection('stock');

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
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
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tambah Stok Masuk",
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  height: 1,
                  color: textGreyColor,
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 450,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Informasi Umum",
                            style: primaryText.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            height: 1,
                            color: textGreyColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "No Faktur",
                                      style: primaryText.copyWith(
                                        fontSize: 16,
                                        color: textGreyColor,
                                      ),
                                    ),
                                    Container(
                                      width: 350,
                                      child: TextField(
                                        controller: noFaktur,
                                        readOnly: true,
                                        style:
                                            primaryText.copyWith(fontSize: 16),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          hintText: 'asssd-asdwddsa-asddsa',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Supplier",
                                      style: primaryText.copyWith(
                                        fontSize: 16,
                                        color: textGreyColor,
                                      ),
                                    ),
                                    Container(
                                      width: 322,
                                      child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          hint: Text("Pilih Supplier"),
                                          items: supplier
                                              .map((item) => DropdownMenuItem(
                                                    child: Container(
                                                      width: 270,
                                                      child: Text(
                                                        item.name.toString(),
                                                        overflow:
                                                            TextOverflow.clip,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    value: item,
                                                  ))
                                              .toList(),
                                          onChanged: (selected) {
                                            setState(() {
                                              _dropdownSupplier =
                                                  selected as SupplierModel;
                                            });
                                          }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tanggal Masuk",
                                      style: primaryText.copyWith(
                                        fontSize: 16,
                                        color: textGreyColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: dateIn,
                                          firstDate: DateTime(2001),
                                          lastDate: DateTime(2222),
                                        ).then((value) {
                                          setState(() {
                                            dateIn = value!;
                                            print(dateIn);
                                          });
                                        });
                                      },
                                      child: Container(
                                        width: 380,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: textGreyColor,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.date_range,
                                              color: textGreyColor,
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  tglMasuk,
                                                  style: primaryText.copyWith(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Waktu Masuk",
                                      style: primaryText.copyWith(
                                        fontSize: 16,
                                        color: textGreyColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          setState(() {
                                            timeIn = value!;
                                            print(timeIn);
                                          });
                                        });
                                      },
                                      child: Container(
                                        width: 280,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: textGreyColor,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time_outlined,
                                              color: textGreyColor,
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  '${timeIn.hour.toString()}:${timeIn.minute.toString()}',
                                                  style: primaryText.copyWith(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 450,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stok Masuk",
                            style: primaryText.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            height: 1,
                            color: textGreyColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Diserahkan',
                              style: primaryText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                onPressed: () {
                                  _dropdownSupplier == null
                                      ? ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Silahkan Pilih Supplier dulu!",
                                              textAlign: TextAlign.center,
                                            ),
                                            backgroundColor: redColor,
                                          ),
                                        )
                                      : showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                                title: Text(
                                                  "Silahkan Pilih Barang",
                                                  style: primaryText.copyWith(
                                                      fontSize: 24),
                                                ),
                                                children: [
                                                  Container(
                                                    width: 800,
                                                    height: 500,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: product
                                                          .orderBy('nama')
                                                          .where("supplier.id",
                                                              isEqualTo:
                                                                  _dropdownSupplier!
                                                                      .id)
                                                          .snapshots(),
                                                      builder: (_, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return ListView(
                                                            children: snapshot
                                                                .data!.docs
                                                                .map((e) {
                                                              ProductModel
                                                                  product =
                                                                  ProductModel.fromJson(e
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>);

                                                              return GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    stockIn.addStockIn(
                                                                        product,
                                                                        0);
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              10),
                                                                  child: Card(
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        product
                                                                            .nama!,
                                                                        style: primaryText
                                                                            .copyWith(
                                                                          fontSize:
                                                                              24,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          );
                                                        } else {
                                                          return Column(
                                                            children: [
                                                              Text("No Data")
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ]);
                                          });
                                },
                                child: Text(
                                  "+ Tambah Barang",
                                  style: primaryText.copyWith(
                                    fontSize: 16,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Card(
                              child: Container(
                                height: 36,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: Text(
                                        "Nama Produk",
                                        style: primaryText.copyWith(
                                          fontSize: 16,
                                          color: textGreyColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      child: Text(
                                        "ID Produk",
                                        style: primaryText.copyWith(
                                          fontSize: 16,
                                          color: textGreyColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Harga",
                                      style: primaryText.copyWith(
                                        fontSize: 16,
                                        color: textGreyColor,
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      child: Text(
                                        "Stok",
                                        style: primaryText.copyWith(
                                          fontSize: 16,
                                          color: textGreyColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Total",
                                      style: primaryText.copyWith(
                                        fontSize: 16,
                                        color: textGreyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: stockIn.stockIns.map((stock) {
                                return Card(
                                  child: InkWell(
                                    splashColor: redColor,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => DialogStockIn(
                                          stock: stock,
                                        ),
                                      );
                                    },
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => CupertinoAlertDialog(
                                                title: Text(
                                                    'Konfirmasi menghapus Produk'),
                                                content: Text(
                                                    'Apa kamu yakin inging menghapus ${stock.nama}?'),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    child: Text('Batal'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoDialogAction(
                                                    child: Text('Hapus'),
                                                    onPressed: () {
                                                      stockIn.removeStockIn(
                                                          stock.id!);

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ));
                                    },
                                    child: Container(
                                      height: 36,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 150,
                                            child: Text(
                                              stock.nama!,
                                              style: primaryText.copyWith(
                                                fontSize: 16,
                                                color: textGreyColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            child: Text(
                                              stock.kode!,
                                              style: primaryText.copyWith(
                                                fontSize: 16,
                                                color: textGreyColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            NumberFormat.simpleCurrency(
                                              decimalDigits: 0,
                                              name: 'Rp. ',
                                            ).format(stock.harga!),
                                            style: primaryText.copyWith(
                                              fontSize: 16,
                                              color: textGreyColor,
                                            ),
                                          ),
                                          Container(
                                            width: 80,
                                            child: Center(
                                              child: Text(
                                                NumberFormat.simpleCurrency(
                                                  decimalDigits: 0,
                                                  name: '',
                                                ).format(stock.stok!),
                                                style: primaryText.copyWith(
                                                  fontSize: 16,
                                                  color: textGreyColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            NumberFormat.simpleCurrency(
                                              decimalDigits: 0,
                                              name: 'Rp. ',
                                            ).format(stock.total!),
                                            style: primaryText.copyWith(
                                              fontSize: 16,
                                              color: textGreyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 450,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stok Return",
                            style: primaryText.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            height: 1,
                            color: textGreyColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dikembalikan',
                              style: primaryText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                onPressed: () {
                                  _dropdownSupplier == null
                                      ? ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Silahkan Pilih Supplier dulu!",
                                              textAlign: TextAlign.center,
                                            ),
                                            backgroundColor: redColor,
                                          ),
                                        )
                                      : showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                                title: Text(
                                                  "Silahkan Pilih Barang",
                                                  style: primaryText.copyWith(
                                                      fontSize: 24),
                                                ),
                                                children: [
                                                  Container(
                                                    width: 800,
                                                    height: 500,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: product
                                                          .orderBy('nama')
                                                          .where("supplier.id",
                                                              isEqualTo:
                                                                  _dropdownSupplier!
                                                                      .id)
                                                          .snapshots(),
                                                      builder: (_, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return ListView(
                                                            children: snapshot
                                                                .data!.docs
                                                                .map((e) {
                                                              ProductModel
                                                                  product =
                                                                  ProductModel.fromJson(e
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>);

                                                              return GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    stockOut.addStockRetn(
                                                                        product,
                                                                        0);
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              10),
                                                                  child: Card(
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        product
                                                                            .nama!,
                                                                        style: primaryText
                                                                            .copyWith(
                                                                          fontSize:
                                                                              24,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          );
                                                        } else {
                                                          return Column(
                                                            children: [
                                                              Text("No Data")
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ]);
                                          });
                                },
                                child: Text(
                                  "+ Tambah Barang",
                                  style: primaryText.copyWith(
                                    fontSize: 16,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Card(
                              child: Container(
                                height: 36,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: Text(
                                        "Nama Produk",
                                        style: primaryText.copyWith(
                                          fontSize: 16,
                                          color: textGreyColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      child: Text(
                                        "ID Produk",
                                        style: primaryText.copyWith(
                                          fontSize: 16,
                                          color: textGreyColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Harga",
                                      style: primaryText.copyWith(
                                        fontSize: 16,
                                        color: textGreyColor,
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      child: Center(
                                        child: Text(
                                          "Stok",
                                          style: primaryText.copyWith(
                                            fontSize: 16,
                                            color: textGreyColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Total",
                                      style: primaryText.copyWith(
                                        fontSize: 16,
                                        color: textGreyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: stockOut.stockRetn.map((stock) {
                                return Card(
                                  child: InkWell(
                                    splashColor: redColor,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => DialogStockReturn(
                                          stock: stock,
                                        ),
                                      );
                                    },
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => CupertinoAlertDialog(
                                                title: Text(
                                                    'Konfirmasi menghapus Produk'),
                                                content: Text(
                                                    'Apa kamu yakin inging menghapus ${stock.nama}?'),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    child: Text('Batal'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoDialogAction(
                                                    child: Text('Hapus'),
                                                    onPressed: () {
                                                      stockOut.removeStockRetn(
                                                          stock.id!);

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ));
                                    },
                                    child: Container(
                                      height: 36,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 150,
                                            child: Text(
                                              stock.nama!,
                                              style: primaryText.copyWith(
                                                fontSize: 16,
                                                color: textGreyColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            child: Text(
                                              stock.kode!,
                                              style: primaryText.copyWith(
                                                fontSize: 16,
                                                color: textGreyColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            NumberFormat.simpleCurrency(
                                              decimalDigits: 0,
                                              name: 'Rp. ',
                                            ).format(stock.harga!),
                                            style: primaryText.copyWith(
                                              fontSize: 16,
                                              color: textGreyColor,
                                            ),
                                          ),
                                          Container(
                                            width: 80,
                                            child: Center(
                                              child: Text(
                                                NumberFormat.simpleCurrency(
                                                  decimalDigits: 0,
                                                  name: '',
                                                ).format(stock.stok!),
                                                style: primaryText.copyWith(
                                                  fontSize: 16,
                                                  color: textGreyColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            NumberFormat.simpleCurrency(
                                              decimalDigits: 0,
                                              name: 'Rp. ',
                                            ).format(stock.total!),
                                            style: primaryText.copyWith(
                                              fontSize: 16,
                                              color: textGreyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Keterangan",
                                  style: primaryText.copyWith(
                                    fontSize: 16,
                                    color: textGreyColor,
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: descController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: secondaryColor,
                                    fixedSize: Size(145, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cancel,
                                        color: primaryColor,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "BATAL",
                                        style: primaryText.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: primaryColor,
                                      fixedSize: Size(145, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      stockIn.stockIns.map((e) {
                                        return product.doc(e.kode).update({
                                          "stok_awal": FieldValue.increment(
                                              num.parse(e.stok.toString())),
                                          "sisa_stok": FieldValue.increment(
                                              num.parse(e.stok.toString())),
                                          "stok_tanggal": DateTime.now(),
                                        });
                                      }).toList();

                                      stockOut.stockRetn.map((e) {
                                        return product.doc(e.kode).update({
                                          "sisa_stok": FieldValue.increment(
                                              -num.parse(e.stok.toString())),
                                        });
                                      }).toList();

                                      stocksStore.doc(noFaktur.text).set({
                                        'noFaktur': noFaktur.text,
                                        'supplier': {
                                          'id': _dropdownSupplier!.id,
                                          'nama': _dropdownSupplier!.name,
                                          'daerah': _dropdownSupplier!.zone
                                        },
                                        'date_in': dateIn,
                                        'time_in': timeIn.toString(),
                                        'description': descController.text,
                                        'stock_in': stockIn.stockIns
                                            .map((e) => e.toJson())
                                            .toList(),
                                        'stock_return': stockOut.stockRetn
                                            .map((e) => e.toJson())
                                            .toList(),
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration:
                                              Duration(milliseconds: 1000),
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              CircularProgressIndicator(),
                                              SizedBox(width: 20),
                                              Text(
                                                "Menambahkan Stok. Mohon Tunggu .....",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          backgroundColor: primaryColor,
                                        ),
                                      );

                                      noFaktur.clear();
                                      descController.clear();
                                      stockIn.stockIns.clear();
                                      stockOut.stockRetn.clear();
                                      _dropdownSupplier = null;
                                      stockProvider.stocks.clear();

                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.save,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "SIMPAN",
                                          style: primaryText.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
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

Widget columnAppbarRight(context) {
  return Expanded(child: Container());
}
