import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/pages/add_stock_page.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';

import '../theme.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  @override
  void Initstate() {
    super.initState();
  }

  DateTime? _datetime;
  @override
  Widget build(BuildContext context) {
    CollectionReference stocks = firestore.collection('stock');

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Stok Produk"),
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
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 600,
                      child: TextField(
                        keyboardType: TextInputType.none,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_sharp),
                            focusColor: primaryColor,
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: greyColor),
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(12)),
                            hintText: 'Search...',
                            hintStyle: primaryText.copyWith(fontSize: 14)),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2001),
                                lastDate: DateTime(2222))
                            .then((date) {
                          setState(() {
                            _datetime = date;
                          });
                        });
                      },
                      child: Container(
                        width: 330,
                        height: 60,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: primaryColor, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.date_range,
                              color: primaryColor,
                            ),
                            Text(
                              _datetime == null
                                  ? 'Tanggal Belum dipilih'
                                  : _datetime.toString(),
                              style: primaryText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: Container(
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddStockPage(),
                            ),
                          );
                        },
                        child: Text(
                          "+ TAMBAH STOK",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
                SizedBox(height: 50),
                StreamBuilder<QuerySnapshot>(
                    stream: stocks.snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!.docs.map((e) {
                            Map<String, dynamic> stock =
                                e.data() as Map<String, dynamic>;
                            return Card(
                              child: Container(
                                height: 60,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 110,
                                      child: Text(
                                        stock['date_in'].toDate().toString(),
                                        style: primaryText.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text(
                                      stock['noFaktur'],
                                      style: primaryText.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: textGreyColor,
                                      ),
                                    ),
                                    Text(
                                      stock['stock_in'][0]['stok'].toString(),
                                      style: primaryText.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: textGreyColor,
                                      ),
                                    ),
                                    Text(
                                      stock['stockReturn'][0]['stok']
                                          .toString(),
                                      style: primaryText.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: textGreyColor,
                                      ),
                                    ),
                                    Chip(
                                      backgroundColor: blueColor,
                                      label: Text(
                                        'Verifikasi',
                                        style: primaryText.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return Column(
                          children: [Text("No Data")],
                        );
                      }
                    })
              ],
            ),
          ),
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
