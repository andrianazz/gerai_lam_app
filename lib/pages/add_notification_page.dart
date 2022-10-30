import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/notification_model.dart';
import 'package:gerai_lam_app/services/log_service.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../theme.dart';

class AddNotificationPage extends StatefulWidget {
  const AddNotificationPage({Key? key}) : super(key: key);

  @override
  State<AddNotificationPage> createState() => _AddNotificationPageState();
}

class _AddNotificationPageState extends State<AddNotificationPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String nameKasir = "";

  List<NotificationModel> suppliers = [];
  NotificationModel? _dropdownSupplier;

  void sendNotificationMessage(String title, String body, String token) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAATv2OdgQ:APA91bFRUB1YE8sv0iR_AwEHOH2QZuQNj_BkCJ67h8v7tEOBdCiMOBEsDw13WhoAX8lpoVaXCQqbT-T15GxGg7zaggMOEAG9KfItRrypXnoFAQogSvtB0VDhJBSK0rL4wLYToWkdpjEu',
          },
          body: jsonEncode({
            'notification': {
              'body': '${body}',
              'title': '${title}',
            },
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
            },
            'to': '${token}'
          }));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getLength();
    getPref();
  }

  Future<void> getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String name = pref.getString("name") ?? '';

    setState(() {
      nameKasir = name;
    });
  }

  getLength() {
    firestore.collection('tokenFCM').orderBy('name').get().then((snapshot) =>
        snapshot.docs.forEach((doc) {
          setState(() {
            suppliers.add(
                NotificationModel.fromJson(doc.data() as Map<String, dynamic>));
          });
        }));
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference notifications = firestore.collection('notifications');

    String document = Uuid().v1();

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
                  "Tambah Notifikasi",
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
                            "Konten Notifikasi",
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Judul Notifikasi",
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
                                          hintText: 'Pemberitahuan Penting!',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 270,
                                  margin: EdgeInsets.only(top: 10),
                                  child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Supplier',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      value: _dropdownSupplier,
                                      hint: Text("Semua Supplier"),
                                      items: suppliers
                                          .map((item) => DropdownMenuItem<
                                                  NotificationModel>(
                                                child: Container(
                                                  width: 140,
                                                  child: Text(
                                                    item.name!,
                                                    overflow: TextOverflow.clip,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                value: item,
                                              ))
                                          .toList(),
                                      onChanged: (selected) {
                                        setState(() {
                                          _dropdownSupplier =
                                              selected as NotificationModel;
                                        });
                                      }),
                                ),
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
                                              "Menambahkan Promo. Mohon Tunggu .....",
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        backgroundColor: primaryColor,
                                      ),
                                    );

                                    notifications.doc(document).set({
                                      'code': document,
                                      'title': titleController.text,
                                      'description': descController.text,
                                      'supplier': _dropdownSupplier!.name,
                                      'id_supplier': _dropdownSupplier!.email,
                                      'date': DateTime.now(),
                                      'isRead': false,
                                    });

                                    LogService().addLog(
                                      nama: nameKasir,
                                      desc: "Menambah Notifikasi",
                                      data_old: {},
                                      data_new: {
                                        'code': document,
                                        'title': titleController.text,
                                        'description': descController.text,
                                        'supplier': _dropdownSupplier!.name,
                                        'id_supplier': _dropdownSupplier!.email,
                                        'date': DateTime.now(),
                                        'isRead': false,
                                      },
                                    );

                                    sendNotificationMessage(
                                        titleController.text,
                                        descController.text,
                                        _dropdownSupplier!.token!);

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
                                  ),
                                ),
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
