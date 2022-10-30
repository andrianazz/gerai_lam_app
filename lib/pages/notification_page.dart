import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/pages/add_notification_page.dart';
import 'package:gerai_lam_app/services/log_service.dart';

import '../theme.dart';
import '../widgets/drawer_widget.dart';

class NotificationPage extends StatelessWidget {
  String? nameKasir;
  NotificationPage({Key? key, this.nameKasir}) : super(key: key);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference notifications = firestore.collection('notifications');
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Notifikasi"),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Notifikasi',
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNotificationPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  ),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Tambah Notifikasi',
                    style: primaryText.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: notifications.orderBy('date').snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data!.docs.map((e) {
                        Map<String, dynamic> promo =
                            e.data() as Map<String, dynamic>;
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: orangeColor,
                                      ),
                                      child: Icon(
                                        Icons.notifications,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 250,
                                          child: Text(
                                            promo['title'],
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
                                            promo['supplier'],
                                            style: primaryText.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            overflow: TextOverflow.clip,
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: 250,
                                          child: Text(
                                            promo['description'],
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
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => CupertinoAlertDialog(
                                                title: Text(
                                                    'Konfirmasi menghapus Promo'),
                                                content: Text(
                                                    'Apa kamu yakin inging menghapus ${promo['title']}'),
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
                                                      notifications
                                                          .doc(promo['code'])
                                                          .delete();

                                                      LogService().addLog(
                                                        nama: nameKasir,
                                                        desc:
                                                            "Menghapus Notifikasi",
                                                        data_new: {},
                                                        data_old: promo,
                                                      );

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ));
                                    },
                                    icon: Icon(
                                      Icons.highlight_remove_rounded,
                                      color: redColor,
                                      size: 40,
                                    )),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Column(
                      children: [Text("No data")],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
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
}
