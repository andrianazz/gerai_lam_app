import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/pages/costumer_page.dart';
import 'package:gerai_lam_app/pages/login_page.dart';
import 'package:gerai_lam_app/pages/order_page.dart';
import 'package:gerai_lam_app/pages/product_page.dart';
import 'package:gerai_lam_app/pages/promo_page.dart';
import 'package:gerai_lam_app/pages/staff_page.dart';
import 'package:gerai_lam_app/pages/stock_page.dart';
import 'package:gerai_lam_app/pages/supplier_page.dart';
import 'package:gerai_lam_app/pages/transaction_page.dart';
import 'package:gerai_lam_app/services/auth_service.dart';

import '../theme.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: appbarColor,
      child: ListView(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/toko_icon.png",
                          width: 53,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Gerai ',
                                style: primaryText.copyWith(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'LAM',
                                    style: primaryText.copyWith(
                                      color: orangeColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'Aplikasi',
                                  style: primaryText.copyWith(
                                    fontSize: 14,
                                    letterSpacing: 7,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'TOKO',
                                  style: primaryText.copyWith(
                                    fontSize: 14,
                                    letterSpacing: 7,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(),
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.shopping_basket,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Order",
                    style: primaryText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ExpansionTile(
                childrenPadding: EdgeInsets.only(left: 20),
                leading: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
                collapsedIconColor: Colors.white,
                title: Text(
                  'Produk',
                  style: primaryText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        "Daftar Produk",
                        style: primaryText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StockPage(),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        "Stok Produk",
                        style: primaryText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionPage(),
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.analytics_rounded,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Transaksi",
                    style: primaryText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PromoPage(),
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.description,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Artikel Promo",
                    style: primaryText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPage(),
                    ),
                  );
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Notifikasi",
                    style: primaryText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ExpansionTile(
                childrenPadding: EdgeInsets.only(left: 20),
                leading: const Icon(
                  Icons.group_add,
                  color: Colors.white,
                ),
                collapsedIconColor: Colors.white,
                title: Text(
                  'Kelola Akun',
                  style: primaryText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StaffPage(),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        "Akun Kasir",
                        style: primaryText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuppplierPage(),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        "Akun Supplier",
                        style: primaryText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CostumerPage(),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        "Akun Costumer",
                        style: primaryText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 50),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 70,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4)),
            child: Center(
              child: Text(
                user!.displayName.toString(),
                style: primaryText.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 50,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: redColor,
              ),
              onPressed: () {
                AuthService().signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginPage(),
                    ),
                    (route) => false);
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              label: Text(
                "LOGOUT",
                style: primaryText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
