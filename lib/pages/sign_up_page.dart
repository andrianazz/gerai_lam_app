import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/pages/staff_page.dart';
import 'package:gerai_lam_app/pages/supplier_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../services/auth_service.dart';
import '../theme.dart';

class SignUpPage extends StatefulWidget {
  bool? isEmployee;
  SignUpPage({Key? key, this.isEmployee}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String> role = ['Kasir', 'Owner'];
  String? _dropdownRole;

  bool _isSecure = true;
  bool _isSecure2 = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  TextEditingController zoneController = TextEditingController();

  String oldImage =
      'https://firebasestorage.googleapis.com/v0/b/phr-marketplace.appspot.com/o/no-image.png?alt=media&token=370795d8-34c8-454d-8e7b-6a297e404bb3';
  String? newImage;

  void imageUpload(String name) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    // Reference ref = FirebaseStorage.instance.ref().child(name);
    //
    // await ref.putFile(File(image!.path));
    // ref.getDownloadURL().then((value) {
    //   setState(() {
    //     newImage = value;
    //   });
    // });

    var postUri = Uri.parse("https://galerilamriau.com/api/image");
    var headers = {
      "Authorization":
          "Bearer 2wNAfr1QBPn2Qckv55u5b4GN2jrgfnC8Y7cZO04yNpXciQHrj9NaWQhs1FSMo0Jd",
      "Content-Type": "multipart/form-data",
      "Accept": "application/json",
    };

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);
    request.headers.addAll(headers);
    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('image', image!.path);
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();

    print(response.statusCode);
    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);
    var res = result.substring(12, result.length - 2).replaceAll(r"\", "");

    setState(() {
      newImage = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference employees = firestore.collection('employees');
    CollectionReference suppliers = firestore.collection('supplier');

    bool _isEmployee = widget.isEmployee ?? false;
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
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios),
                            iconSize: 24,
                            color: primaryColor,
                          ),
                          Text(
                            "Daftar Akun",
                            style: primaryText.copyWith(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Row(
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.isEmployee = true;
                                });
                              },
                              child: Container(
                                height: 62,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "PENGELOLA : ",
                                              style: primaryText.copyWith(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: _isEmployee
                                                    ? primaryColor
                                                    : textGreyColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            StreamBuilder<QuerySnapshot>(
                                                stream: employees.snapshots(),
                                                builder: (_, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(
                                                      ' ${snapshot.data!.docs.length} ORANG',
                                                      style:
                                                          primaryText.copyWith(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _isEmployee
                                                            ? primaryColor
                                                            : textGreyColor,
                                                      ),
                                                    );
                                                  } else {
                                                    return Text(
                                                      '0 orang',
                                                      style:
                                                          primaryText.copyWith(
                                                        fontSize: 24,
                                                        color: _isEmployee
                                                            ? primaryColor
                                                            : textGreyColor,
                                                      ),
                                                    );
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: _isEmployee
                                            ? primaryColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
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
                                  widget.isEmployee = false;
                                });
                              },
                              child: Container(
                                height: 62,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "PELANGGAN : ",
                                              style: primaryText.copyWith(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: !_isEmployee
                                                    ? primaryColor
                                                    : textGreyColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            StreamBuilder<QuerySnapshot>(
                                                stream: suppliers.snapshots(),
                                                builder: (_, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(
                                                      ' ${snapshot.data!.docs.length} ORANG',
                                                      style:
                                                          primaryText.copyWith(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: !_isEmployee
                                                            ? primaryColor
                                                            : textGreyColor,
                                                      ),
                                                    );
                                                  } else {
                                                    return Text(
                                                      '0 ORANG',
                                                      style:
                                                          primaryText.copyWith(
                                                        fontSize: 24,
                                                        color: !_isEmployee
                                                            ? primaryColor
                                                            : textGreyColor,
                                                      ),
                                                    );
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: !_isEmployee
                                            ? primaryColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
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
                      _isEmployee ? employee() : supplier()
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

  Widget employee() {
    CollectionReference employees = firestore.collection('employees');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nama Pegawai",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    style: primaryText.copyWith(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email Pegawai",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    style: primaryText.copyWith(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Role",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: _dropdownRole,
                        hint: Text("Pilih Role"),
                        items: role
                            .map((item) => DropdownMenuItem<String>(
                                  child: Text(
                                    item,
                                  ),
                                  value: item,
                                ))
                            .toList(),
                        onChanged: (selected) {
                          setState(() {
                            _dropdownRole = selected as String?;
                          });
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No Telepon",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    style: primaryText.copyWith(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nomor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Password",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: _isSecure,
                    style: primaryText.copyWith(fontSize: 24),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isSecure = !_isSecure;
                            });
                          },
                          icon: Icon(
                            _isSecure ? Icons.visibility : Icons.visibility_off,
                          )),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Password Konfirmasi",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: password2Controller,
                    obscureText: _isSecure2,
                    style: primaryText.copyWith(fontSize: 24),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isSecure2 = !_isSecure2;
                            });
                          },
                          icon: Icon(
                            _isSecure2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          )),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Container(
          height: 100,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              employees.doc(emailController.text).get().then((snapshot) {
                if (snapshot.exists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Email sudah terdaftar",
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: redColor,
                    ),
                  );
                } else {
                  if (passwordController.text == password2Controller.text) {
                    employees.doc(emailController.text).set({
                      'id': Uuid().v5(
                          Uuid.NAMESPACE_URL, emailController.text.toString()),
                      'name': nameController.text,
                      'email': emailController.text,
                      'phone': phoneController.text,
                      'date': DateTime.now(),
                      'role': _dropdownRole,
                      'status': 'aktif',
                    });

                    AuthService().register(
                      context,
                      emailController.text,
                      passwordController.text,
                    );

                    clear();

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StaffPage(),
                        ),
                        (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Password tidak sama",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: redColor,
                      ),
                    );
                  }
                }
              });
            },
            child: Text(
              "SIMPAN",
              style: primaryText.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }

  Widget supplier() {
    CollectionReference suppliers = firestore.collection('supplier');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(newImage ?? oldImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        emailController.text.isNotEmpty
            ? Center(
                child: ElevatedButton(
                  onPressed: () {
                    imageUpload(emailController.text.toString());
                  },
                  child: const Text('Change Image'),
                ),
              )
            : SizedBox(),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nama Supplier",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    style: primaryText.copyWith(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email Supplier",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: primaryText.copyWith(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No Telepon",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    style: primaryText.copyWith(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nomor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Password",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: _isSecure,
                    style: primaryText.copyWith(fontSize: 24),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isSecure = !_isSecure;
                            });
                          },
                          icon: Icon(
                            _isSecure ? Icons.visibility : Icons.visibility_off,
                          )),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Password Konfirmasi",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: password2Controller,
                    obscureText: _isSecure2,
                    style: primaryText.copyWith(fontSize: 24),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isSecure2 = !_isSecure2;
                            });
                          },
                          icon: Icon(
                            _isSecure2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          )),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Daerah Domisili",
                    style: primaryText.copyWith(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: zoneController,
                    keyboardType: TextInputType.number,
                    style: primaryText.copyWith(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Daerah',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Container(
          height: 100,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              suppliers.doc(emailController.text).get().then((snapshot) {
                if (snapshot.exists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Data sudah pernah terdaftar",
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: redColor,
                    ),
                  );
                } else {
                  if (passwordController.text == password2Controller.text) {
                    suppliers.doc(emailController.text).set({
                      'id': Uuid().v5(
                          Uuid.NAMESPACE_URL, emailController.text.toString()),
                      'name': nameController.text,
                      'email': emailController.text,
                      'phone': phoneController.text,
                      'imageUrl': newImage ?? oldImage,
                      'date': DateTime.now(),
                      'zone': zoneController.text,
                    });

                    AuthService().register(
                      context,
                      emailController.text,
                      passwordController.text,
                    );

                    clear();

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SuppplierPage(),
                        ),
                        (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Password tidak sama",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: redColor,
                      ),
                    );
                  }
                }
              });
            },
            child: Text(
              "SIMPAN",
              style: primaryText.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }

  void clear() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    password2Controller.clear();
  }
}
