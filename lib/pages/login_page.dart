import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/pages/order_page.dart';
import 'package:gerai_lam_app/pages/sign_up_page.dart';

import 'package:gerai_lam_app/services/auth_service.dart';
import 'package:gerai_lam_app/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isEmail = true;
  bool _isSecure = true;
  bool _isSecure2 = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;

    return useMobileLayout
        ? Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bg_splash.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/started_illustration2.png",
                      width: 150,
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 400,
                      child: Text(
                        "Tidak dapat menampilkan aplikasi. Silahkan Install aplikasi pada Tablet anda,",
                        style: primaryText.copyWith(
                          fontSize: 18,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: greenColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10)),
                      onPressed: () {},
                      child: Text(
                        "KELUAR APLIKASI",
                        style: primaryText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        : StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Something went Wrong"));
              } else if (snapshot.hasData) {
                print(snapshot.data);
                return const OrderPage();
              } else {
                return Scaffold(
                  body: Row(
                    children: [
                      Container(
                        width: 306,
                        color: appbar2Color,
                        child: Center(
                          child: Hero(
                            tag: 'logo1',
                            child: Image.asset(
                              "assets/toko_logo.png",
                              width: 251,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    "MASUK",
                                    style: primaryText.copyWith(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isEmail = true;
                                            });
                                          },
                                          child: Container(
                                            height: 62,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "WITH EMAIL",
                                                      style:
                                                          primaryText.copyWith(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _isEmail
                                                            ? primaryColor
                                                            : textGreyColor,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 2,
                                                  decoration: BoxDecoration(
                                                    color: _isEmail
                                                        ? primaryColor
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isEmail = false;
                                            });
                                          },
                                          child: Container(
                                            height: 62,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      "WITH PHONE",
                                                      style:
                                                          primaryText.copyWith(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: !_isEmail
                                                            ? primaryColor
                                                            : textGreyColor,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 2,
                                                  decoration: BoxDecoration(
                                                    color: !_isEmail
                                                        ? primaryColor
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 50),
                                  _isEmail
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "EMAIL",
                                              style: primaryText.copyWith(
                                                fontSize: 24,
                                                color: textGreyColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            TextField(
                                              controller: emailController,
                                              style: primaryText.copyWith(
                                                fontSize: 24,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: 'Email',
                                                labelStyle:
                                                    primaryText.copyWith(
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 50),
                                            Text(
                                              "PASSWORD",
                                              style: primaryText.copyWith(
                                                fontSize: 24,
                                                color: textGreyColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            TextField(
                                              controller: passwordController,
                                              obscureText: _isSecure,
                                              style: primaryText.copyWith(
                                                fontSize: 24,
                                              ),
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _isSecure = !_isSecure;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      _isSecure
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                    )),
                                                hintText: 'Password',
                                                labelStyle:
                                                    primaryText.copyWith(
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 50),
                                            Container(
                                              height: 62,
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  isEmployees(emailController
                                                      .text
                                                      .toString());
                                                },
                                                child: Text(
                                                  "MASUK",
                                                  style: primaryText.copyWith(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : phoneSignIn(context),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "LUPA PASSWORD?",
                                        style: primaryText.copyWith(
                                          fontSize: 20,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            });
  }

  isEmployees(String email) {
    CollectionReference employees = firestore.collection('employees');
    employees.doc(email).get().then((snapshot) {
      if (snapshot.exists) {
        return AuthService().signIn(
          context,
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Anda belum mendaftarkan diri!",
              textAlign: TextAlign.center,
            ),
            backgroundColor: redColor,
          ),
        );
      }
    });
  }

  Widget phoneSignIn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "NO. TELEPON",
          style: primaryText.copyWith(
            fontSize: 24,
            color: textGreyColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: phoneController,
          style: primaryText.copyWith(
            fontSize: 24,
          ),
          decoration: InputDecoration(
            hintText: 'No Telepon',
          ),
        ),
        SizedBox(height: 50),
        Text(
          "PASSWORD",
          style: primaryText.copyWith(
            fontSize: 24,
            color: textGreyColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: password2Controller,
          obscureText: _isSecure2,
          style: primaryText.copyWith(
            fontSize: 24,
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isSecure2 = !_isSecure2;
                  });
                },
                icon: Icon(
                  _isSecure ? Icons.visibility : Icons.visibility_off,
                )),
            hintText: 'Password',
            labelStyle: primaryText.copyWith(
              fontSize: 24,
            ),
          ),
        ),
        SizedBox(height: 50),
        Container(
          height: 62,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderPage(),
                ),
              );
            },
            child: Text(
              "MASUK",
              style: primaryText.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
