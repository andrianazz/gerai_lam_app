import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/promo_model.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../theme.dart';

class AddPromoPage extends StatefulWidget {
  const AddPromoPage({Key? key}) : super(key: key);

  @override
  State<AddPromoPage> createState() => _AddPromoPageState();
}

class _AddPromoPageState extends State<AddPromoPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int promoLength = 0;

  @override
  void initState() {
    super.initState();
    getLength();
  }

  getLength() {
    firestore
        .collection('promo')
        .get()
        .then((snapshot) => promoLength = snapshot.docs.length);
  }

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

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference promo = firestore.collection('promo');

    String document = 'PR-${promoLength + 000}';

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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  "Tambah Stok Masuk",
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  height: 2,
                  color: textGreyColor,
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
                            "Konten Artikel",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 252,
                                      height: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: textGreyColor,
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              newImage ?? oldImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        imageUpload(document);
                                      },
                                      child: Text("Tukar Gambar"),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Judul Artikel",
                                      style: primaryText.copyWith(
                                        fontSize: 16,
                                        color: textGreyColor,
                                      ),
                                    ),
                                    Container(
                                      width: 450,
                                      child: TextField(
                                        controller: titleController,
                                        style:
                                            primaryText.copyWith(fontSize: 16),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          hintText: 'Big Sale 50%',
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: false,
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: promo.snapshots(),
                                          builder: (_, snapshot) {
                                            if (snapshot.hasData) {
                                              promoLength =
                                                  snapshot.data!.docs.length;
                                              return SizedBox();
                                            } else {
                                              return SizedBox();
                                            }
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
                                      "Deskripsi",
                                      style: primaryText.copyWith(
                                        fontSize: 16,
                                        color: textGreyColor,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          450 -
                                          80,
                                      child: TextField(
                                        controller: descController,
                                        maxLines: 10,
                                        style:
                                            primaryText.copyWith(fontSize: 16),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
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
                                                "Menambahkan Promo. Mohon Tunggu .....",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          backgroundColor: primaryColor,
                                        ),
                                      );

                                      promo.doc(document).set({
                                        'id': promoLength,
                                        'imageUrl': newImage ?? oldImage,
                                        'title': titleController.text,
                                        'description': descController.text,
                                      });

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
                    )
                  ],
                ),
              ],
            ),
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
