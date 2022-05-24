import 'package:flutter/material.dart';
import 'package:gerai_lam_app/pages/login_page.dart';
import 'package:gerai_lam_app/providers/product_provider.dart';
import 'package:gerai_lam_app/providers/stock_provider.dart';
import 'package:gerai_lam_app/theme.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    getInit();
    super.initState();
  }

  getInit() async {
    await Provider.of<ProductProvider>(context, listen: false).getProducts();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appbarColor,
      body: Center(
        child: Hero(
          tag: 'logo1',
          child: Image.asset("assets/toko_logo.png"),
        ),
      ),
    );
  }
}
