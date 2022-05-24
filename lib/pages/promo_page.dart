import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/pages/add_promo_page.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';

import '../theme.dart';

class PromoPage extends StatelessWidget {
  const PromoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference promos = firestore.collection('promo');

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Artikel Promo"),
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
                  'Daftar Artikel Promo',
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
                        builder: (context) => const AddPromoPage(),
                      ),
                    );
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
                    'Tambah Artikel',
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
                stream: promos.orderBy('id').snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data!.docs.map((e) {
                        Map<String, dynamic> promo =
                            e.data() as Map<String, dynamic>;
                        return Card(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 54,
                                      width: 54,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(promo['imageUrl']),
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
                                                      promos
                                                          .doc(promo['code'])
                                                          .delete();

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ));
                                    },
                                    icon: Icon(
                                      Icons.highlight_remove_rounded,
                                      color: redColor,
                                      size: 50,
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
