import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/pages/print_page.dart';
import 'package:gerai_lam_app/services/log_service.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

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

  String namaKasir = "";

  // List<BluetoothDevice> devices = [];
  // BluetoothDevice? selectedDevice;
  // BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    super.initState();
    getSuppliers();
    getPref();
    // getDevices();
  }

  // void getDevices() async {
  //   devices = await printer.getBondedDevices();
  //   setState(() {});
  //   print(devices);
  // }

  getSuppliers() {
    firestore
        .collection('supplier')
        .orderBy('name')
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              supplier.add(SupplierModel.fromJson(doc.data()));
            }));
  }

  Future<void> getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String name = pref.getString("name") ?? '';

    setState(() {
      namaKasir = name;
    });
  }

  bool _addProduct = false;

  TextEditingController searchController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController barController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController capitalController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  TextEditingController qtyController = TextEditingController(text: "1");

  List<SupplierModel> supplier = [];
  SupplierModel? _dropdownSupplier = SupplierModel();
  ProductModel? selectedProduct;

  String searchProduct = '';

  String oldImage =
      'https://firebasestorage.googleapis.com/v0/b/phr-marketplace.appspot.com/o/no-image.png?alt=media&token=370795d8-34c8-454d-8e7b-6a297e404bb3';
  List<String> newImage = [];

  void imageUpload(String name) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    String length = newImage.length.toString();

    Reference ref = FirebaseStorage.instance.ref().child('${name}${length}');

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        newImage.add(value);

        print(newImage);
      });
    });
  }

  void sendImage(String name) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    // File imagePath = File(image!.path);

    //Cara Pertama
    // var url = "https://galerilamriau.com/api/image";
    // var headers = {
    //   "Authorization":
    //       "Bearer 2wNAfr1QBPn2Qckv55u5b4GN2jrgfnC8Y7cZO04yNpXciQHrj9NaWQhs1FSMo0Jd",
    //   "Content-Type": "multipart/form-data"
    // };

    // var body = {
    //   "image": imagePath,
    // };
    //
    // var response =
    //     await http.post(Uri.parse(url), headers: headers, body: body);
    // print(response.body);
    // print(response.statusCode);

    // if (response.statusCode == 200) {
    //   print("Berhasil Set");
    // } else {
    //   throw Exception("Gagal get Products");
    // }

    //Cara Kedua
    var postUri = Uri.parse("https://galerilamriau.com/api/image");
    var headers = {
      "Authorization":
          "Bearer 2wNAfr1QBPn2Qckv55u5b4GN2jrgfnC8Y7cZO04yNpXciQHrj9NaWQhs1FSMo0Jd",
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
    };

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);
    request.headers.addAll(headers);
    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('image', image!.path);
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();

    print(response.statusCode);
    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);
    var res = result.substring(12, result.length - 2).replaceAll(r"\", "");

    setState(() {
      newImage.add(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference products = firestore.collection('product');
    CollectionReference tableLog = firestore.collection("logs");

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
                          print(newImage);
                          setState(() {
                            clear();
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
                  controller: searchController,
                  onChanged: (value) async {
                    await Future.delayed(Duration(seconds: 3), () {
                      setState(() {
                        searchProduct = value[0].toUpperCase() +
                            value.substring(1).toLowerCase();
                      });
                    });
                  },
                  onTap: () {
                    setState(() {
                      searchController.clear();
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
                      stream: (searchProduct.isNotEmpty && searchProduct != '')
                          ? products
                              .where('nama',
                                  isGreaterThanOrEqualTo: searchProduct)
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
                                child: InkWell(
                                  splashColor: redColor,
                                  onTap: () {
                                    setState(() {
                                      selectedProduct =
                                          ProductModel.fromJson(product);

                                      nameController.text =
                                          selectedProduct!.nama!;
                                      barController.text =
                                          selectedProduct!.barcode ?? '';
                                      descController.text =
                                          selectedProduct!.deskripsi!;
                                      capitalController.text = selectedProduct!
                                          .harga_modal!
                                          .toString();
                                      newImage = selectedProduct!.imageUrl!
                                          .map((e) => e.toString())
                                          .toList();
                                      priceController.text = selectedProduct!
                                          .harga_jual!
                                          .toString();
                                    });

                                    showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Container(
                                          width: 800,
                                          height: 900,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 20),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Detail Data Produk",
                                                      style:
                                                          primaryText.copyWith(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          child: TextField(
                                                            controller:
                                                                qtyController,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                              labelText:
                                                                  'Banyak',
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Container(
                                                          height: 50,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              if (selectedProduct!
                                                                          .barcode!
                                                                          .length >
                                                                      6 ||
                                                                  selectedProduct!
                                                                          .barcode!
                                                                          .length <
                                                                      6) {
                                                                Navigator.pop(
                                                                    context);

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content:
                                                                        Text(
                                                                      "Silahkan Generate ulang barcode anda!",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    backgroundColor:
                                                                        redColor,
                                                                  ),
                                                                );
                                                              } else {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        PrintPage(
                                                                      product:
                                                                          selectedProduct,
                                                                      qty: int.parse(
                                                                          qtyController
                                                                              .text),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            child: Text(
                                                                'Print Label'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 30),
                                                Container(
                                                  height: 110,
                                                  child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: selectedProduct!
                                                        .imageUrl!
                                                        .map((e) {
                                                      return Container(
                                                        width: 133,
                                                        height: 102,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                e.toString()),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        // imageUpload(
                                                        //     selectedProduct!
                                                        //         .kode!);

                                                        sendImage(codeController
                                                            .text
                                                            .toString());
                                                      },
                                                      child: const Text(
                                                          'Add Image'),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    selectedProduct!.imageUrl!
                                                            .isNotEmpty
                                                        ? ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        redColor),
                                                            onPressed: () {
                                                              setState(() {
                                                                print(selectedProduct!
                                                                    .imageUrl);
                                                              });
                                                            },
                                                            child: const Text(
                                                                'Remove Image'),
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex: 4,
                                                      child: TextField(
                                                        controller:
                                                            barController,
                                                        readOnly: true,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          labelText: 'Barcode',
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Flexible(
                                                      flex: 2,
                                                      child: Container(
                                                        height: 50,
                                                        width: 180,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            var rng = Random();
                                                            String
                                                                generatedNumber =
                                                                '';
                                                            for (int i = 0;
                                                                i < 6;
                                                                i++) {
                                                              generatedNumber +=
                                                                  (rng.nextInt(
                                                                              9) +
                                                                          1)
                                                                      .toString();
                                                            }

                                                            setState(() {
                                                              barController
                                                                      .text =
                                                                  generatedNumber;
                                                            });
                                                          },
                                                          child:
                                                              Text('Generate'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: TextField(
                                                        controller:
                                                            nameController,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          labelText:
                                                              'Nama Produk',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: TextField(
                                                        controller:
                                                            descController,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          labelText:
                                                              'Deskripsi',
                                                        ),
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        width: 400,
                                                        child: TextFormField(
                                                          controller:
                                                              capitalController,
                                                          inputFormatters: [
                                                            CurrencyTextInputFormatter(
                                                              decimalDigits: 0,
                                                              symbol: 'Rp. ',
                                                              locale: 'ID',
                                                            )
                                                          ],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            labelText:
                                                                'Harga Modal',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        width: 400,
                                                        child: TextFormField(
                                                          controller:
                                                              priceController,
                                                          inputFormatters: [
                                                            CurrencyTextInputFormatter(
                                                              decimalDigits: 0,
                                                              symbol: 'Rp. ',
                                                              locale: 'ID',
                                                            )
                                                          ],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            labelText:
                                                                'Harga Jual',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                DropdownButtonFormField(
                                                    decoration: InputDecoration(
                                                      labelText: 'Supplier',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                    hint: Text(
                                                        "${selectedProduct!.supplier!['nama']}"),
                                                    items: supplier
                                                        .map((item) =>
                                                            DropdownMenuItem(
                                                              child: Container(
                                                                width: 300,
                                                                child: Text(
                                                                  item.name
                                                                      .toString(),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              value: item,
                                                            ))
                                                        .toList(),
                                                    onChanged: (selected) {
                                                      setState(() {
                                                        _dropdownSupplier =
                                                            selected
                                                                as SupplierModel;
                                                      });
                                                    }),
                                                SizedBox(height: 30),
                                                Container(
                                                  width: double.infinity,
                                                  height: 60,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          primaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  1000),
                                                          content: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              CircularProgressIndicator(),
                                                              SizedBox(
                                                                  width: 20),
                                                              Text(
                                                                "Mengubah. Mohon Tunggu .....",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ],
                                                          ),
                                                          backgroundColor:
                                                              primaryColor,
                                                        ),
                                                      );

                                                      if (_dropdownSupplier!
                                                              .name !=
                                                          null) {
                                                        products
                                                            .doc(
                                                                selectedProduct!
                                                                    .kode!)
                                                            .update({
                                                          'imageUrl': newImage
                                                                  .isNotEmpty
                                                              ? newImage
                                                                  .map((e) => e)
                                                                  .toList()
                                                              : [oldImage],
                                                          'nama': nameController
                                                              .text,
                                                          'deskripsi':
                                                              descController
                                                                  .text,
                                                          'barcode':
                                                              barController
                                                                  .text,
                                                          'harga_modal': int.parse(
                                                              capitalController
                                                                  .text
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          '[A-Za-z]'),
                                                                      '')
                                                                  .replaceAll(
                                                                      '.', '')),
                                                          'harga_jual': int.parse(
                                                              priceController
                                                                  .text
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          '[A-Za-z]'),
                                                                      '')
                                                                  .replaceAll(
                                                                      '.', '')),
                                                          'supplier': {
                                                            'id':
                                                                _dropdownSupplier!
                                                                    .id,
                                                            'daerah':
                                                                _dropdownSupplier!
                                                                    .zone,
                                                            'nama':
                                                                _dropdownSupplier!
                                                                    .name,
                                                          },
                                                        });

                                                        LogService().addLog(
                                                            nama: namaKasir,
                                                            desc:
                                                                "Merubah data produk",
                                                            data_old:
                                                                selectedProduct
                                                                    ?.toJson(),
                                                            data_new: {
                                                              'imageUrl': newImage
                                                                      .isNotEmpty
                                                                  ? newImage
                                                                      .map(
                                                                          (e) =>
                                                                              e)
                                                                      .toList()
                                                                  : [oldImage],
                                                              'nama':
                                                                  nameController
                                                                      .text,
                                                              'deskripsi':
                                                                  descController
                                                                      .text,
                                                              'barcode':
                                                                  barController
                                                                      .text,
                                                              'harga_modal': int.parse(
                                                                  capitalController
                                                                      .text
                                                                      .replaceAll(
                                                                          RegExp(
                                                                              '[A-Za-z]'),
                                                                          '')
                                                                      .replaceAll(
                                                                          '.',
                                                                          '')),
                                                              'harga_jual': int.parse(
                                                                  priceController
                                                                      .text
                                                                      .replaceAll(
                                                                          RegExp(
                                                                              '[A-Za-z]'),
                                                                          '')
                                                                      .replaceAll(
                                                                          '.',
                                                                          '')),
                                                              'supplier': {
                                                                'id':
                                                                    _dropdownSupplier!
                                                                        .id,
                                                                'daerah':
                                                                    _dropdownSupplier!
                                                                        .zone,
                                                                'nama':
                                                                    _dropdownSupplier!
                                                                        .name,
                                                              }
                                                            });
                                                      } else {
                                                        products
                                                            .doc(
                                                                selectedProduct!
                                                                    .kode!)
                                                            .update({
                                                          'imageUrl': newImage
                                                                  .isNotEmpty
                                                              ? newImage
                                                                  .map((e) => e)
                                                                  .toList()
                                                              : [oldImage],
                                                          'nama': nameController
                                                              .text,
                                                          'deskripsi':
                                                              descController
                                                                  .text,
                                                          'barcode':
                                                              barController
                                                                  .text,
                                                          'harga_modal': int.parse(
                                                              capitalController
                                                                  .text
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          '[A-Za-z]'),
                                                                      '')
                                                                  .replaceAll(
                                                                      '.', '')),
                                                          'harga_jual': int.parse(
                                                              priceController
                                                                  .text
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          '[A-Za-z]'),
                                                                      '')
                                                                  .replaceAll(
                                                                      '.', '')),
                                                          'supplier': {
                                                            'id': selectedProduct!
                                                                    .supplier![
                                                                'id'],
                                                            'daerah':
                                                                selectedProduct!
                                                                        .supplier![
                                                                    'daerah'],
                                                            'nama':
                                                                selectedProduct!
                                                                        .supplier![
                                                                    'nama'],
                                                          },
                                                        });

                                                        LogService().addLog(
                                                            nama: namaKasir,
                                                            desc:
                                                                "Merubah data produk",
                                                            data_old:
                                                                selectedProduct
                                                                    ?.toJson(),
                                                            data_new: {
                                                              'imageUrl': newImage
                                                                      .isNotEmpty
                                                                  ? newImage
                                                                      .map(
                                                                          (e) =>
                                                                              e)
                                                                      .toList()
                                                                  : [oldImage],
                                                              'nama':
                                                                  nameController
                                                                      .text,
                                                              'deskripsi':
                                                                  descController
                                                                      .text,
                                                              'barcode':
                                                                  barController
                                                                      .text,
                                                              'harga_modal': int.parse(
                                                                  capitalController
                                                                      .text
                                                                      .replaceAll(
                                                                          RegExp(
                                                                              '[A-Za-z]'),
                                                                          '')
                                                                      .replaceAll(
                                                                          '.',
                                                                          '')),
                                                              'harga_jual': int.parse(
                                                                  priceController
                                                                      .text
                                                                      .replaceAll(
                                                                          RegExp(
                                                                              '[A-Za-z]'),
                                                                          '')
                                                                      .replaceAll(
                                                                          '.',
                                                                          '')),
                                                              'supplier': {
                                                                'id': selectedProduct!
                                                                        .supplier![
                                                                    'id'],
                                                                'daerah': selectedProduct!
                                                                        .supplier![
                                                                    'daerah'],
                                                                'nama': selectedProduct!
                                                                        .supplier![
                                                                    'nama'],
                                                              },
                                                            });
                                                      }

                                                      clear();

                                                      setState(() {
                                                        _addProduct = false;
                                                        selectedProduct = null;
                                                      });

                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "SIMPAN",
                                                      style:
                                                          primaryText.copyWith(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Container(
                                                  width: double.infinity,
                                                  height: 60,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: redColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "BATAL",
                                                      style:
                                                          primaryText.copyWith(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
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

                                                    LogService().addLog(
                                                      nama: namaKasir,
                                                      desc: "Menghapus Produk",
                                                      data_old: selectedProduct
                                                          ?.toJson(),
                                                      data_new: {},
                                                    );

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
                                                        product['imageUrl'][0]),
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
                                                    ).format(int.parse(
                                                        product['harga_jual']
                                                            .toString())),
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
                                                product['tag'][0] ?? '',
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
                                                    .format(int.parse(
                                                        product['harga_modal']
                                                            .toString())),
                                                style: primaryText.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: textGreyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          child: Text(
                                            product['kode'],
                                            style: primaryText.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: textGreyColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 4,
                                          child: TextField(
                                            controller: barController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              labelText: 'Barcode',
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Flexible(
                                          flex: 2,
                                          child: Container(
                                            height: 50,
                                            width: 180,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                var rng = Random();
                                                String generatedNumber = '';
                                                for (int i = 0; i < 6; i++) {
                                                  generatedNumber +=
                                                      (rng.nextInt(9) + 1)
                                                          .toString();
                                                }

                                                setState(() {
                                                  barController.text =
                                                      generatedNumber;
                                                });
                                              },
                                              child: Text('Generate'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    newImage.isEmpty
                                        ? Container(
                                            width: 133,
                                            height: 102,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: DecorationImage(
                                                image: NetworkImage(oldImage),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 100,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: newImage
                                                  .map((e) => Container(
                                                        width: 133,
                                                        height: 102,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                NetworkImage(e),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ),
                                    codeController.text.isNotEmpty
                                        ? ElevatedButton(
                                            onPressed: () {
                                              // imageUpload(codeController.text
                                              //     .toString());

                                              sendImage(codeController.text
                                                  .toString());

                                              // uploadImage('image',
                                              //     File("assets/app_logo.png"));
                                            },
                                            child: const Text('Add Image'),
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
                                          hintText: 'Tag1; Tag2; dst'),
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
                                        'imageUrl': newImage.isNotEmpty
                                            ? newImage
                                                .map((e) => e.toString())
                                                .toList()
                                            : [oldImage],
                                        'id': Uuid().v5(
                                          Uuid.NAMESPACE_URL,
                                          codeController.text.toString(),
                                        ),
                                        'kode': codeController.text,
                                        'barcode': barController.text,
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
    newImage = [];
    nameController.text = '';
    codeController.text = '';
    barController.text = '';
    descController.text = '';
    capitalController.text = '';
    priceController.text = '';
    tagController.text = '';
    _dropdownSupplier = SupplierModel();
  }
}

Widget columnAppbarLeft(context) {
  return Container(
    width: MediaQuery.of(context).size.width * 2 / 3 - 60,
    child: Container(),
  );
}
