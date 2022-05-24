import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/pages/detail_order_page.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';

import '../theme.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isOrder = false;
  TextEditingController searchController = TextEditingController();

  final sortedProduct = mockProduct..sort((a, b) => a.nama!.compareTo(b.nama!));

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
                            Row(
                              children: [
                                Container(
                                  width: 41,
                                  child: Text(
                                    "1",
                                    style: primaryText.copyWith(
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    "Sop Buntut",
                                    style: primaryText.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Rp. 59.000",
                                  style: primaryText.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 41,
                                  child: Text(
                                    "1",
                                    style: primaryText.copyWith(
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    "Sop Iga",
                                    style: primaryText.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Rp. 50.000",
                                  style: primaryText.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 41,
                                  child: Text(
                                    "1",
                                    style: primaryText.copyWith(
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    "Ayam Bakar",
                                    style: primaryText.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Rp. 25.100",
                                  style: primaryText.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 41,
                                  child: Text(
                                    "1",
                                    style: primaryText.copyWith(
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    "Lemon Tea",
                                    style: primaryText.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Rp. 8.000",
                                  style: primaryText.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 41,
                                  child: Text(
                                    "1",
                                    style: primaryText.copyWith(
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    "Es Teh Manis",
                                    style: primaryText.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Rp. 4.000",
                                  style: primaryText.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
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
                        onPressed: () {},
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
                        onPressed: () {},
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
                            "Rp. 812.800",
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
          child: ListView(
            scrollDirection: Axis.vertical,
            children: sortedProduct
                .map((product) => Card(
                      child: ListTile(
                        leading: Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                                image: NetworkImage(product.imageUrl!),
                                fit: BoxFit.cover),
                          ),
                        ),
                        title: Text(
                          product.nama!,
                          style: primaryText.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          'Rp. ${product.harga_jual!.toString()}',
                          style: primaryText.copyWith(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ))
                .toList(),
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
