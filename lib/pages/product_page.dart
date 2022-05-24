import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/providers/product_provider.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/supplier_model.dart';
import '../theme.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int idProduct = 0;
  @override
  void initState() {
    super.initState();
    getSuppliers();
  }

  getSuppliers() {
    firestore
        .collection('supplier')
        .orderBy('name')
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              supplier.add(SupplierModel.fromJson(doc.data()));
            }));
  }

  bool _addProduct = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController capitalController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  List<SupplierModel> supplier = [];
  SupplierModel? _dropdownSupplier;
  ProductModel? selectedProduct;

  String oldImage =
      'https://firebasestorage.googleapis.com/v0/b/phr-marketplace.appspot.com/o/no-image.png?alt=media&token=370795d8-34c8-454d-8e7b-6a297e404bb3';
  String? newImage;

  void imageUpload(String name) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    Reference ref = FirebaseStorage.instance.ref().child(name);

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        newImage = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference products = firestore.collection('product');

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text("Produk"),
        backgroundColor: primaryColor,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                columnAppbarLeft(context),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _addProduct = !_addProduct;
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "TAMBAH PRODUK",
                              style: primaryText.copyWith(
                                  fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 2 / 3 - 60,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                TextField(
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
                                child: InkWell(
                                  splashColor: redColor,
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => CupertinoAlertDialog(
                                              title: Text(
                                                  'Konfirmasi menghapus Karyawan'),
                                              content: Text(
                                                  'Apa kamu yakin inging menghapus ${product['nama']}'),
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
                                                    products
                                                        .doc(product['kode'])
                                                        .delete();

                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: (selectedProduct != null &&
                                              selectedProduct!.id ==
                                                  product['id'])
                                          ? secondaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 54,
                                              width: 54,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        product['imageUrl']),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Container(
                                              width: 200,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product['nama'],
                                                    style: primaryText.copyWith(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    overflow: TextOverflow.clip,
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    NumberFormat.simpleCurrency(
                                                      decimalDigits: 0,
                                                      name: 'Rp. ',
                                                    ).format(
                                                        product['harga_jual']),
                                                    style: primaryText.copyWith(
                                                      color: primaryColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 160,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                product['tag'][0],
                                                style: primaryText.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: textGreyColor,
                                                ),
                                                overflow: TextOverflow.clip,
                                                maxLines: 1,
                                              ),
                                              Text(
                                                NumberFormat.simpleCurrency(
                                                        decimalDigits: 0,
                                                        name: 'Rp. ')
                                                    .format(
                                                        product['harga_modal']),
                                                style: primaryText.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: textGreyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          product['kode'],
                                          style: primaryText.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: textGreyColor,
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          child: Text(
                                            product['sisa_stok'].toString(),
                                            style: primaryText.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: textGreyColor,
                                            ),
                                            textAlign: TextAlign.end,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("No Data"),
                            ],
                          );
                        }
                      }),
                )
              ],
            ),
          ),
          Expanded(
            child: _addProduct == true
                ? Container(
                    color: const Color(0xffF6F6F6),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: false,
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: products.snapshots(),
                                          builder: (_, snapshot) {
                                            idProduct =
                                                snapshot.data!.docs.length + 1;
                                            if (snapshot.hasData) {
                                              return Row(
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    child: TextField(
                                                      controller:
                                                          TextEditingController(
                                                              text: idProduct
                                                                  .toString()),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        labelText: 'ID',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return SizedBox();
                                            }
                                          }),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: TextField(
                                            controller: codeController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              labelText: 'Kode Produk',
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Flexible(
                                          flex: 4,
                                          child: TextField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              labelText: 'Nama Produk',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: 133,
                                      height: 102,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              newImage ?? oldImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    codeController.text.isNotEmpty
                                        ? ElevatedButton(
                                            onPressed: () {
                                              imageUpload(codeController.text);
                                            },
                                            child: const Text('Change Image'),
                                          )
                                        : SizedBox(),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: descController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        labelText: 'Deskripsi',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: TextFormField(
                                            controller: capitalController,
                                            inputFormatters: [
                                              CurrencyTextInputFormatter(
                                                decimalDigits: 0,
                                                symbol: 'Rp. ',
                                                locale: 'ID',
                                              )
                                            ],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              labelText: 'Harga Modal',
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 200,
                                          child: TextFormField(
                                            controller: priceController,
                                            inputFormatters: [
                                              CurrencyTextInputFormatter(
                                                decimalDigits: 0,
                                                symbol: 'Rp. ',
                                                locale: 'ID',
                                              )
                                            ],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              labelText: 'Harga Jual',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButtonFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Supplier',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        hint: Text("Pilih Supplier"),
                                        items: supplier
                                            .map((item) => DropdownMenuItem(
                                                  child: Container(
                                                    width: 300,
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
                                    SizedBox(height: 10),
                                    TextField(
                                      controller: tagController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        labelText: 'Tag',
                                      ),
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
                                  clear();
                                  setState(() {
                                    _addProduct = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.warning,
                                  color: primaryColor,
                                ),
                                label: Text(
                                  "BATAL",
                                  style: primaryText.copyWith(
                                    fontSize: 20,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  products
                                      .doc(codeController.text)
                                      .get()
                                      .then((snapshot) {
                                    if (snapshot.exists) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Kode sudah terdaftar",
                                            textAlign: TextAlign.center,
                                          ),
                                          backgroundColor: redColor,
                                        ),
                                      );
                                    } else {
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
                                                "Menambahkan. Mohon Tunggu .....",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          backgroundColor: primaryColor,
                                        ),
                                      );
                                      products.doc(codeController.text).set({
                                        'imageUrl': newImage ?? oldImage,
                                        'id': idProduct,
                                        'kode': codeController.text,
                                        'nama': nameController.text,
                                        'deskripsi': descController.text,
                                        'harga_modal': int.parse(
                                            capitalController.text
                                                .replaceAll(
                                                    RegExp('[A-Za-z]'), '')
                                                .replaceAll('.', '')),
                                        'harga_jual': int.parse(priceController
                                            .text
                                            .replaceAll(RegExp('[A-Za-z]'), '')
                                            .replaceAll('.', '')),
                                        'stok_awal': 0,
                                        'stok_tanggal': DateTime.now(),
                                        'sisa_stok': 0,
                                        'tag': tagController.text.split(";"),
                                        'supplier': {
                                          'id': _dropdownSupplier!.id,
                                          'daerah': _dropdownSupplier!.zone,
                                          'nama': _dropdownSupplier!.name,
                                        },
                                      });

                                      clear();

                                      setState(() {
                                        _addProduct = false;
                                      });
                                    }
                                  });
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
                      ],
                    ),
                  )
                : Container(
                    color: primaryColor,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Image.asset("assets/toko_logo.png"),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  clear() {
    newImage = null;
    nameController.text = '';
    codeController.text = '';
    descController.text = '';
    capitalController.text = '';
    priceController.text = '';
    tagController.text = '';
  }
}

Widget columnAppbarLeft(context) {
  return Container(
    width: MediaQuery.of(context).size.width * 2 / 3 - 60,
    child: Container(),
  );
}
