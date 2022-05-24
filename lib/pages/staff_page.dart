import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/employee_model.dart';
import 'package:gerai_lam_app/services/auth_service.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';

import '../theme.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({Key? key}) : super(key: key);

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  int? idKasir = 0;
  EmployeeModel? selectedStaff = mockEmployee[0];

  TextEditingController idController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  List<String> role = ['Kasir', 'Owner'];
  String? _dropdownRole = 'Kasir';

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference employees = firestore.collection('employees');

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Kasir"),
        backgroundColor: primaryColor,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                columnAppbarLeft(context),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Scaffold(
                                backgroundColor: Colors.transparent,
                                body: Container(
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 80,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: ListView(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.arrow_back,
                                              size: 32,
                                            ),
                                          ),
                                          Text(
                                            "Tambah Karyawan",
                                            style: primaryText.copyWith(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "ID Kasir",
                                                  style: primaryText.copyWith(
                                                    fontSize: 24,
                                                    color: textGreyColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color: greyColor,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      idKasir.toString(),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Flexible(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nama Kasir",
                                                  style: primaryText.copyWith(
                                                    fontSize: 24,
                                                    color: textGreyColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  child: TextField(
                                                    controller: nameController,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                      hintText: 'Masukkan Nama',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Flexible(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Email",
                                                  style: primaryText.copyWith(
                                                    fontSize: 24,
                                                    color: textGreyColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  child: TextField(
                                                    controller: emailController,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Masukkan Email',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Role",
                                                  style: primaryText.copyWith(
                                                    fontSize: 24,
                                                    color: textGreyColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  height: 60,
                                                  child:
                                                      DropdownButtonFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                          ),
                                                          value: _dropdownRole,
                                                          items: role
                                                              .map((item) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    child: Text(
                                                                        item),
                                                                    value: item,
                                                                  ))
                                                              .toList(),
                                                          onChanged:
                                                              (selected) {
                                                            setState(() {
                                                              _dropdownRole =
                                                                  selected
                                                                      as String?;
                                                            });
                                                          }),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Flexible(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "No Telepon",
                                                  style: primaryText.copyWith(
                                                    fontSize: 24,
                                                    color: textGreyColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  child: TextField(
                                                    controller: phoneController,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Masukkan Nomor Telepon',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          8,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Flexible(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Password",
                                                  style: primaryText.copyWith(
                                                    fontSize: 24,
                                                    color: textGreyColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  child: TextField(
                                                    obscureText: true,
                                                    controller:
                                                        passwordController,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Masukkan Password',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(flex: 4, child: Container()),
                                          SizedBox(width: 40),
                                          Flexible(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Konfirmasi Password",
                                                  style: primaryText.copyWith(
                                                    fontSize: 24,
                                                    color: textGreyColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  child: TextField(
                                                    obscureText: true,
                                                    controller:
                                                        password2Controller,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Masukkan Konfirmasi Password',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: secondaryColor,
                                              fixedSize: Size(145, 50),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () {
                                                employees
                                                    .doc(emailController.text)
                                                    .get()
                                                    .then((snapshot) {
                                                  if (snapshot.exists) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Email sudah terdaftar",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        backgroundColor:
                                                            redColor,
                                                      ),
                                                    );
                                                  } else {
                                                    if (passwordController
                                                            .text ==
                                                        password2Controller
                                                            .text) {
                                                      employees
                                                          .doc(emailController
                                                              .text)
                                                          .set({
                                                        'id': idKasir,
                                                        'name':
                                                            nameController.text,
                                                        'email': emailController
                                                            .text,
                                                        'phone': phoneController
                                                            .text,
                                                        'role': _dropdownRole,
                                                        'status': 'aktif',
                                                      });

                                                      AuthService().createAuth(
                                                          context,
                                                          emailController.text,
                                                          passwordController
                                                              .text,
                                                          nameController.text);

                                                      clear();

                                                      Navigator.pop(context);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            "Password tidak sama",
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          backgroundColor:
                                                              redColor,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                });
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
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.group_add_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "TAMBAH KARYAWAN",
                              style: primaryText.copyWith(
                                  fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 2 / 3 - 60,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  keyboardType: TextInputType.none,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_sharp),
                      focusColor: primaryColor,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: greyColor),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'Search...',
                      hintStyle: primaryText.copyWith(fontSize: 14)),
                ),
                const SizedBox(height: 30),
                Text(
                  "Daftar Kasir",
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: employees.orderBy('id').snapshots(),
                    builder: (_, snapshot) {
                      idKasir = snapshot.data!.docs.length + 1;
                      if (snapshot.hasData) {
                        return ListView(
                          children: snapshot.data!.docs.map<Widget>((e) {
                            Map<String, dynamic> employee =
                                e.data()! as Map<String, dynamic>;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedStaff =
                                      EmployeeModel.fromJson(employee);
                                });
                              },
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selectedStaff!.id == employee['id']
                                        ? secondaryColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 54,
                                            width: 54,
                                            decoration: BoxDecoration(
                                              color: greyColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                employee['id'].toString(),
                                                style: primaryText.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                                                  employee['name'],
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
                                                  employee['phone'],
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
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          employee['status'],
                                          style: primaryText.copyWith(
                                            fontSize: 20,
                                            color: textGreyColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("No Data"),
                          ],
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xffF6F6F6),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 50),
                                    Container(
                                      height: 100,
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: textGreyColor, width: 3)),
                                      child: Center(
                                        child: Text(
                                          selectedStaff!.name!,
                                          style: primaryText.copyWith(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 50),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'About',
                                    style: primaryText.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Kasir adalah orang yang bertugas untuk mengurusi dan menyimpan hasil pembayaran terutama uang, dan memasukkannya ke dalam mesin kasir.',
                                    style: primaryText.copyWith(
                                      fontSize: 16,
                                      color: textGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: primaryText.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    selectedStaff!.email!,
                                    style: primaryText.copyWith(
                                      fontSize: 16,
                                      color: textGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No. Telepon',
                                        style: primaryText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        selectedStaff!.phone!,
                                        style: primaryText.copyWith(
                                          fontSize: 16,
                                          color: textGreyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Status',
                                        style: primaryText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        selectedStaff!.status!,
                                        style: primaryText.copyWith(
                                          fontSize: 16,
                                          color: textGreyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            primary: redColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title:
                                          Text('Konfirmasi menghapus Karyawan'),
                                      content: Text(
                                          'Apa kamu yakin inging menghapus ${selectedStaff!.name}'),
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
                                            employees
                                                .doc(selectedStaff!.email)
                                                .delete();

                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ));
                          },
                          icon: Icon(Icons.highlight_remove),
                          label: Text(
                            'HAPUS',
                            style: primaryText.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            primary: secondaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: primaryColor,
                          ),
                          label: Text(
                            'EDIT',
                            style: primaryText.copyWith(
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

Widget columnAppbarLeft(context) {
  return Container(
    width: MediaQuery.of(context).size.width * 2 / 3 - 60,
    child: Row(
      children: [],
    ),
  );
}
