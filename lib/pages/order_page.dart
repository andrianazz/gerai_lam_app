import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/pages/detail_order_page.dart';
import 'package:gerai_lam_app/providers/cart_provider.dart';
import 'package:gerai_lam_app/widgets/dialog_quantity.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String selectedTag = '';

  bool isOrder = false;

  String emailSupplier = "";

  @override
  void initState() {
    super.initState();
    getAll();
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
          drawer: DrawerWidget(),
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
          body: landscape(context)),
    );
  }

  Widget columnAppbarLeft(context) {
    CollectionReference tags = firestore.collection("tags");

    return Container(
      width: MediaQuery.of(context).size.width * 2 / 3 - 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedTag = "";
                searchController.clear();
              });
            },
            child: Text(
              "Semua",
              style: primaryText.copyWith(fontSize: 20, color: Colors.white),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: tags.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: snapshot.data!.docs.map((e) {
                    Map<String, dynamic> tag = e.data() as Map<String, dynamic>;
                    return TextButton(
                      onPressed: () {
                        setState(() {
                          selectedTag = tag['name'];
                          searchController.text = '';
                        });
                        print(selectedTag);
                      },
                      child: Text(
                        tag['name'].toString(),
                        style: primaryText.copyWith(
                            fontSize: 20, color: Colors.white),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Center(
                  child: Text(
                    "No Data",
                    style: primaryText.copyWith(color: Colors.white),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget columnAppbarRight(context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 60,
      child: Row(
        children: [
          Visibility(
            visible: false,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isOrder = !isOrder;
                });
              },
              child: Text(
                "DAFTAR ORDER",
                style: primaryText.copyWith(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget landscape(context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 2 / 3 - 60,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: isOrder ? listOrder() : listProduct(context),
        ),
        Expanded(
          child: Container(
            color: const Color(0xffF6F6F6),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Text(
                                    "QTY",
                                    style: primaryText.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    "Nama Barang",
                                    style: primaryText.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "Harga",
                                    style: primaryText.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: cartProvider.carts
                                  .map((order) => Dismissible(
                                        key: Key(order.name.toString()),
                                        background: Container(
                                          color: redColor,
                                          child: const Center(
                                            child: Text(
                                              'Hapus',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onDismissed: (direction) {
                                          setState(() {
                                            cartProvider.carts.removeWhere(
                                                (item) =>
                                                    item.name == order.name);
                                          });
                                        },
                                        child: InkWell(
                                          onLongPress: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => DialogQuantity(
                                                item: order,
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 41,
                                                    child: Text(
                                                      order.quantity.toString(),
                                                      style:
                                                          primaryText.copyWith(
                                                        fontSize: 18,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Expanded(
                                                    child: Text(
                                                      order.name.toString(),
                                                      style:
                                                          primaryText.copyWith(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    NumberFormat.simpleCurrency(
                                                      decimalDigits: 0,
                                                      name: 'Rp. ',
                                                    ).format(order.price),
                                                    style: primaryText.copyWith(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                ),
                                                height: 1,
                                                color: greyColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  color: secondaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                    title: Text('Konfirmasi menghapus Orderan'),
                                    content: Text(
                                        'Apa kamu yakin inging menghapus semua orderan'),
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
                                          setState(() {
                                            cartProvider.carts.clear();
                                          });

                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: primaryColor,
                        ),
                        label: Text(
                          "HAPUS",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          print(cartProvider.carts);
                        },
                        icon: const Icon(
                          Icons.save,
                          color: primaryColor,
                        ),
                        label: Text(
                          "SIMPAN",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DetailOrderPage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 80,
                    color: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Bayar",
                          style: primaryText.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Text(
                            NumberFormat.simpleCurrency(
                              decimalDigits: 0,
                              name: 'Rp. ',
                            ).format(cartProvider.getTotal() ?? 0),
                            textAlign: TextAlign.right,
                            style: primaryText.copyWith(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget listProduct(context) {
    CollectionReference products = firestore.collection('product');
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Column(
      children: [
        TextField(
          controller: searchController,
          onChanged: (value) async {
            await Future.delayed(Duration(seconds: 3), () {
              setState(() {
                selectedTag = '';
                searchController.text =
                    value[0].toUpperCase() + value.substring(1).toLowerCase();
              });
              print(searchController.text);
            });
          },
          onTap: () {
            setState(() {
              searchController.text = '';
            });
          },
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_sharp),
              focusColor: primaryColor,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: greyColor),
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(12)),
              hintText: 'Search...',
              hintStyle: primaryText.copyWith(fontSize: 14)),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: selectedTag.isNotEmpty
                ? products.where('tag', arrayContains: selectedTag).snapshots()
                : searchController.text.isNotEmpty
                    ? products
                        .where('nama',
                            isGreaterThanOrEqualTo: searchController.text)
                        .snapshots()
                    : products.orderBy('nama').snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.docs.map((e) {
                    Map<String, dynamic> product =
                        e.data() as Map<String, dynamic>;
                    return Card(
                      color: cartProvider.carts
                              .any((item) => item.idProduk == product['id'])
                          ? secondaryColor
                          : Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (cartProvider.carts
                                .any((item) => item.name == product['nama'])) {
                              cartProvider.removeCart(product);
                            } else {
                              cartProvider
                                  .addCart(ProductModel.fromJson(product));
                            }
                          });
                        },
                        child: ListTile(
                          leading: Container(
                            height: 54,
                            width: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: NetworkImage(product['imageUrl'][0]),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          title: Text(
                            product['nama'],
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                NumberFormat.simpleCurrency(
                                  decimalDigits: 0,
                                  name: 'Rp. ',
                                ).format(product['harga_jual']),
                                style: primaryText.copyWith(
                                  color: greenColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                NumberFormat.simpleCurrency(
                                  decimalDigits: 0,
                                  name: '',
                                ).format(product['sisa_stok']),
                                style: primaryText.copyWith(
                                  color: product['sisa_stok'] > 5
                                      ? greenColor
                                      : redColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
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
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              }
            },
          ),
        )
      ],
    );
  }

  Widget listOrder() {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DAFTAR ORDER",
              style: primaryText.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Meja 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Meja 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Meja 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Meja 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Meja 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Meja 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "VIP 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "VIP 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "VIP 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Gojek 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Gojek 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Gojek 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Gojek 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Grab 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 133,
                      height: 102,
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Grab 1",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Keluar Aplikasi'),
            content: Text('Apakah anda ingin keluar dari Aplikasi?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ElevatedButton.styleFrom(
                  primary: greenColor,
                ),
                //return false when click on "NO"
                child: Text('Tidak'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  primary: redColor,
                ),
                //return true when click on "Yes"
                child: Text('Keluar'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Future<void> getAll() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString("email") ?? '';
    setState(() {
      emailSupplier = email;
    });
  }
}
