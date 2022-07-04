import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/costumer_model.dart';

import '../theme.dart';
import '../widgets/drawer_widget.dart';

class CostumerPage extends StatefulWidget {
  const CostumerPage({Key? key}) : super(key: key);

  @override
  State<CostumerPage> createState() => _CostumerPageState();
}

class _CostumerPageState extends State<CostumerPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController searchController = TextEditingController();

  CostumerModel? selectedCostumer;

  @override
  Widget build(BuildContext context) {
    CollectionReference customers = firestore.collection('customer');
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Costumer"),
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
                  controller: searchController,
                  onTap: () {
                    setState(() {
                      searchController.clear();
                    });
                  },
                  onChanged: (value) async {
                    await Future.delayed(Duration(seconds: 3), () {
                      setState(() {
                        searchController.text = value[0].toUpperCase() +
                            value.substring(1).toLowerCase();
                      });
                      print(searchController.text);
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
                Text(
                  "Daftar Costumer",
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: searchController.text.isEmpty
                        ? customers.orderBy('name').snapshots()
                        : customers
                            .where('name',
                                isGreaterThanOrEqualTo: searchController.text)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: snapshot.data!.docs.map((e) {
                            Map<String, dynamic> costumer =
                                e.data() as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCostumer =
                                      CostumerModel.fromJson(costumer);
                                });
                              },
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selectedCostumer == null
                                        ? Colors.transparent
                                        : selectedCostumer!.id == costumer['id']
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
                                                    costumer['imageUrl']
                                                        .toString()),
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
                                                  costumer['name'],
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
                                                  costumer['phone'],
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return Center(
                          child: Text("No Data"),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: selectedCostumer == null
                ? Container(
                    color: primaryColor,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Image.asset("assets/toko_logo.png"),
                      ),
                    ),
                  )
                : Container(
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
                                                    selectedCostumer!
                                                        .imageUrl!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 25),
                                          Text(
                                            selectedCostumer!.name!,
                                            style: primaryText.copyWith(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            selectedCostumer!.id!.toString(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'About',
                                          style: primaryText.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          'Pelanggan atau langganan merujuk pada individu '
                                          'atau rumah tangga, perusahaan yang membeli '
                                          'barang atau jasa yang dihasilkan dalam ekonomi.',
                                          style: primaryText.copyWith(
                                            fontSize: 16,
                                            color: textGreyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Email',
                                          style: primaryText.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          selectedCostumer!.email!,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  selectedCostumer!.phone!,
                                                  style: primaryText.copyWith(
                                                    fontSize: 16,
                                                    color: textGreyColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 50),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Status',
                                                  style: primaryText.copyWith(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  selectedCostumer!.status!,
                                                  style: primaryText.copyWith(
                                                    fontSize: 16,
                                                    color: textGreyColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Alamat Lengkap',
                                              style: primaryText.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              selectedCostumer!.asal!.alamat!,
                                              style: primaryText.copyWith(
                                                fontSize: 16,
                                                color: textGreyColor,
                                              ),
                                            ),
                                            Text(
                                              selectedCostumer!
                                                  .asal!.kecamatan!,
                                              style: primaryText.copyWith(
                                                fontSize: 16,
                                                color: textGreyColor,
                                              ),
                                            ),
                                            Text(
                                              selectedCostumer!
                                                  .asal!.kelurahan!,
                                              style: primaryText.copyWith(
                                                fontSize: 16,
                                                color: textGreyColor,
                                              ),
                                            ),
                                            Text(
                                              selectedCostumer!.asal!.kota!,
                                              style: primaryText.copyWith(
                                                fontSize: 16,
                                                color: textGreyColor,
                                              ),
                                            ),
                                            Text(
                                              selectedCostumer!.asal!.provinsi!,
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
