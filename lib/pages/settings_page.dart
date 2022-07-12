import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/drawer_widget.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController ppnController = TextEditingController();
  TextEditingController pplController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController telController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getInit();
  }

  Future getInit() async {
    await firestore.collection('settings').doc('galerilam').get().then((value) {
      setState(() {
        ppnController.text = value['ppn'].toString();
        pplController.text = value['ppl'].toString();
        alamatController.text = value['alamat'];
        telController.text = value['telepon'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference settings = firestore.collection("settings");

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Pengaturan Toko"),
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
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 5),
                              blurRadius: 10,
                            ),
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Perhatian : ",
                            style: primaryText.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Mengubah data disini akan mengakibatkan berubahnya beberapa data yang akan diproses, Mohon diteliti lagi dengan baik",
                            style: primaryText.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 5),
                              blurRadius: 10,
                            ),
                          ]),
                      child: StreamBuilder(
                        stream: settings.doc('galerilam').snapshots(),
                        builder: (context, snapshot) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Alamat Toko",
                                style: primaryText.copyWith(fontSize: 20)),
                            SizedBox(height: 10),
                            TextField(
                              controller: alamatController,
                              style: primaryText.copyWith(fontSize: 20),
                              maxLines: 2,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                hintText: "Masukkan Alamat",
                                hintStyle: primaryText.copyWith(
                                  fontSize: 20,
                                  color: textGreyColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: greyColor),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Text("Nomor Telepon Toko",
                                style: primaryText.copyWith(fontSize: 20)),
                            SizedBox(height: 10),
                            TextField(
                              controller: telController,
                              style: primaryText.copyWith(fontSize: 20),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                hintText: "Masukkan Nomor Telepon",
                                hintStyle: primaryText.copyWith(
                                  fontSize: 20,
                                  color: textGreyColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: greyColor),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Text("Persentase Pajak PPN",
                                style: primaryText.copyWith(fontSize: 20)),
                            SizedBox(height: 10),
                            TextField(
                              controller: ppnController,
                              style: primaryText.copyWith(fontSize: 20),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                hintText: "Masukkan PPN",
                                hintStyle: primaryText.copyWith(
                                  fontSize: 20,
                                  color: textGreyColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: greyColor),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Text("Persentase Pajak Lainnya",
                                style: primaryText.copyWith(fontSize: 20)),
                            SizedBox(height: 10),
                            TextField(
                              controller: pplController,
                              style: primaryText.copyWith(fontSize: 20),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                hintText: "Masukkan Pajak Lainnya",
                                hintStyle: primaryText.copyWith(
                                  fontSize: 20,
                                  color: textGreyColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: greyColor),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Center(
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    settings.doc('galerilam').update({
                                      'alamat':
                                          alamatController.text.toString(),
                                      'telepon': telController.text.toString(),
                                      'ppn': int.parse(
                                          ppnController.text.toString()),
                                      'ppl': int.parse(
                                          pplController.text.toString()),
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(milliseconds: 1000),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            CircularProgressIndicator(),
                                            SizedBox(width: 20),
                                            Text(
                                              "Authenticating. Please wait .....",
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        backgroundColor: primaryColor,
                                      ),
                                    );

                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: primaryColor,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10)),
                                  icon: Icon(Icons.save),
                                  label: Text(
                                    "UBAH SETTING",
                                    style: primaryText.copyWith(fontSize: 20),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
