import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/services/auth_service.dart';

import '../theme.dart';
import '../widgets/drawer_widget.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController passOld = TextEditingController();
  TextEditingController passNew = TextEditingController();
  TextEditingController pass2New = TextEditingController();

  bool _isSecure2 = true;
  bool _isSecure3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Ganti Password"),
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
                            "Password baru anda harus mengikuti kriteria sebagai berikut:",
                            style: primaryText.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "1. Minimal 8 karakter",
                            style: primaryText.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "2. Harus mengandung huruf kapital dan huruf kecil",
                            style: primaryText.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "3. Harus mengandung angka",
                            style: primaryText.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "4. Berbeda dengan password lama",
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Password Baru",
                              style: primaryText.copyWith(fontSize: 20)),
                          SizedBox(height: 10),
                          TextField(
                            controller: passNew,
                            obscureText: _isSecure2,
                            style: primaryText.copyWith(fontSize: 20),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isSecure2 = !_isSecure2;
                                    });
                                  },
                                  icon: Icon(_isSecure2
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              hintText: "Masukkan Password Baru",
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
                          Text("Konfirmasi Password Baru",
                              style: primaryText.copyWith(fontSize: 20)),
                          SizedBox(height: 10),
                          TextField(
                            controller: pass2New,
                            obscureText: _isSecure3,
                            style: primaryText.copyWith(fontSize: 20),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isSecure3 = !_isSecure3;
                                    });
                                  },
                                  icon: Icon(_isSecure3
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              hintText: "Konfirmasi Password Baru",
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
                                  if (passNew.text.toString() ==
                                      pass2New.text.toString()) {
                                    AuthService().updatePassword(
                                        context, passNew.text.toString());

                                    passNew.clear();
                                    pass2New.clear();

                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: Text(
                                                "Ubah Password",
                                                style: primaryText.copyWith(
                                                  fontSize: 24,
                                                ),
                                              ),
                                              content: Text(
                                                'Password telah diubah',
                                                style: primaryText.copyWith(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Gagal Password Tidak Sama!",
                                          textAlign: TextAlign.center,
                                        ),
                                        backgroundColor: redColor,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: primaryColor,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10)),
                                icon: Icon(Icons.save),
                                label: Text(
                                  "UBAH PASSWORD",
                                  style: primaryText.copyWith(fontSize: 20),
                                )),
                          )
                        ],
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
