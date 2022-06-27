import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/pages/login_page.dart';

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
    await Future.delayed(Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Hero(
          tag: 'logo1',
          child: Image.asset(
            "assets/splash_screen.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
