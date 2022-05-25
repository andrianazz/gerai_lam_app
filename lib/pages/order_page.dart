import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/order_model.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/pages/detail_order_page.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isOrder = false;
  TextEditingController searchController = TextEditingController();

  List<OrderModel> order = [];
  int total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: landscape(context));
  }

  Widget columnAppbarLeft(context) {
    return Container(
      width: MediaQuery.of(context).size.width * 2 / 3 - 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  "SEMUA",
                  style:
                      primaryText.copyWith(fontSize: 20, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "MAKANAN",
                  style:
                      primaryText.copyWith(fontSize: 20, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "MINUMAN",
                  style:
                      primaryText.copyWith(fontSize: 20, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "OBAT",
                  style:
                      primaryText.copyWith(fontSize: 20, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "HEALTHCARE",
                  style:
                      primaryText.copyWith(fontSize: 20, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "SEMBAKO",
                  style:
                      primaryText.copyWith(fontSize: 20, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "BUAH",
                  style:
                      primaryText.copyWith(fontSize: 20, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "ROTI",
                  style:
                      primaryText.copyWith(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
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
          TextButton(
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
        ],
      ),
    );
  }

  Widget landscape(context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 2 / 3 - 60,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: isOrder ? listOrder() : listProduct(),
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
                            Column(
                              children: order
                                  .map((order) => Row(
                                        children: [
                                          Container(
                                            width: 41,
                                            child: Text(
                                              order.qty.toString(),
                                              style: primaryText.copyWith(
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Text(
                                              order.product!.nama.toString(),
                                              style: primaryText.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            NumberFormat.simpleCurrency(
                                              decimalDigits: 0,
                                              name: 'Rp. ',
                                            ).format(order.product!.harga_jual),
                                            style: primaryText.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
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
                                            order.clear();
                                            total = 0;
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
                          print(order);
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
                            ).format(total),
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

  Widget listProduct() {
    CollectionReference products = firestore.collection('product');
    return Column(
      children: [
        TextField(
          controller: searchController,
          keyboardType: TextInputType.none,
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
            stream: products.orderBy('nama').snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.docs.map((e) {
                    Map<String, dynamic> product =
                        e.data() as Map<String, dynamic>;
                    return Card(
                      color:
                          order.any((item) => item.idProduct == product['id'])
                              ? secondaryColor
                              : Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (order.any(
                                (item) => item.idProduct == product['id'])) {
                              order.removeWhere(
                                  (item) => item.idProduct == product['id']);

                              total = total -
                                  int.parse(product['harga_jual'].toString());
                            } else {
                              order.add(OrderModel(
                                id: order.length + 1,
                                qty: 1,
                                idProduct: product['id'],
                                product: ProductModel.fromJson(product),
                              ));

                              total = total +
                                  int.parse(product['harga_jual'].toString());
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
                                  image: NetworkImage(product['imageUrl']),
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
                          subtitle: Text(
                            NumberFormat.simpleCurrency(
                              decimalDigits: 0,
                              name: 'Rp. ',
                            ).format(product['harga_jual']),
                            style: primaryText.copyWith(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
}
