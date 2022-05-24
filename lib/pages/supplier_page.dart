import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/supplier_model.dart';

import '../theme.dart';
import '../widgets/drawer_widget.dart';

class SuppplierPage extends StatefulWidget {
  const SuppplierPage({Key? key}) : super(key: key);

  @override
  State<SuppplierPage> createState() => _SuppplierPageState();
}

class _SuppplierPageState extends State<SuppplierPage> {
  SupplierModel? selectedSupplier = mockSupplier[0];

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference supplier = firestore.collection('supplier');

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Supplier"),
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
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 2 / 3 - 60,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(
                  "Daftar Supplier",
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: supplier.snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: snapshot.data!.docs.map((e) {
                            Map<String, dynamic> sup =
                                e.data()! as Map<String, dynamic>;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSupplier =
                                      SupplierModel.fromJson(sup);
                                });
                              },
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selectedSupplier!.id == sup['id']
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
                                                    sup['imageUrl']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 250,
                                                child: Text(
                                                  sup['name'],
                                                  style: primaryText.copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              Container(
                                                width: 250,
                                                child: Text(
                                                  sup['phone'],
                                                  style: primaryText.copyWith(
                                                    fontSize: 16,
                                                    color: textGreyColor,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Text(
                                        sup['zone'],
                                        style: primaryText.copyWith(
                                          fontSize: 20,
                                          color: textGreyColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
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
                    },
                  ),
                ),
              ],
            ),
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
                              horizontal: 40, vertical: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      width: 121,
                                      height: 121,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              selectedSupplier!.imageUrl!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    Text(
                                      selectedSupplier!.name!,
                                      style: primaryText.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      selectedSupplier!.id!.toString(),
                                      style: primaryText.copyWith(
                                        fontSize: 20,
                                        color: textGreyColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 50),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'About',
                                    style: primaryText.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Pihak perorangan atau perusahaan yang memasok atau menjual produk kepada pihak kami.',
                                    style: primaryText.copyWith(
                                      fontSize: 16,
                                      color: textGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: primaryText.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    selectedSupplier!.email!,
                                    style: primaryText.copyWith(
                                      fontSize: 16,
                                      color: textGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No. Telepon',
                                        style: primaryText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        selectedSupplier!.phone!,
                                        style: primaryText.copyWith(
                                          fontSize: 16,
                                          color: textGreyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Zone',
                                        style: primaryText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        selectedSupplier!.zone!,
                                        style: primaryText.copyWith(
                                          fontSize: 16,
                                          color: textGreyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            primary: redColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {},
                          icon: Icon(Icons.highlight_remove),
                          label: Text(
                            'HAPUS',
                            style: primaryText.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            primary: secondaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: primaryColor,
                          ),
                          label: Text(
                            'EDIT',
                            style: primaryText.copyWith(
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
    child: Row(
      children: [],
    ),
  );
}

Widget columnAppbarRight(context) {
  return Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    ),
  );
}
