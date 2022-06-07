// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/employee_model.dart';
import 'package:gerai_lam_app/pages/sign_up_page.dart';
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
  EmployeeModel? selectedStaff;

  TextEditingController idController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  List<String> role = ['Kasir', 'Owner'];
  String? _dropdownRole;

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(
                                isEmployee: true,
                              ),
                            ),
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
                    stream: employees.orderBy('name').snapshots(),
                    builder: (_, snapshot) {
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
                                    color: selectedStaff == null
                                        ? Colors.transparent
                                        : selectedStaff!.name.toString() ==
                                                employee['name']
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
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
                                              SizedBox(
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
                          children: const [
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
            child: selectedStaff == null
                ? Container(
                    color: primaryColor,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Image.asset("assets/toko_logo.png"),
                      ),
                    ),
                  )
                : Container(
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
                                                    color: textGreyColor,
                                                    width: 3)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    side: BorderSide(
                                        color: primaryColor, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  primary: secondaryColor,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 10,
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => CupertinoAlertDialog(
                                            title: Text(
                                                'Konfirmasi Lupa Password Kasir'),
                                            content: Text(
                                                'Apa kamu yakin ingin mengirim email kepada ${selectedStaff!.email}?'),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: Text('Batal'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                child: Text('Kirim Email'),
                                                onPressed: () {
                                                  AuthService()
                                                      .updatePasswordwithEmail(
                                                          context,
                                                          selectedStaff!
                                                              .email!);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ));
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.mark_email_read,
                                  color: primaryColor,
                                ),
                                label: Text(
                                  'Lupa Password',
                                  style: primaryText.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
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
                                      builder: (_) => CupertinoAlertDialog(
                                            title: Text(
                                                'Konfirmasi menghapus Karyawan'),
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
                                    side: BorderSide(
                                        color: primaryColor, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  primary: secondaryColor,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 10,
                                  ),
                                ),
                                onPressed: () {
                                  showEditData(context);
                                },
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

  showEditData(context) {
    CollectionReference employees =
        FirebaseFirestore.instance.collection('employees');

    nameController.text = selectedStaff!.name!;
    _dropdownRole = selectedStaff!.role!;
    phoneController.text = selectedStaff!.phone!;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 800,
          height: 400,
          margin: EdgeInsets.all(40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Ubah Data Pegawai",
                    style: primaryText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama Pegawai",
                            style: primaryText.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: nameController,
                            style: primaryText.copyWith(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              focusColor: const Color(0xfff2f2f2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: "Masukkan Nama...",
                              fillColor: const Color(0xfff2f2f2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Role",
                            style: primaryText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
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
                    const SizedBox(width: 30),
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "No Telepon",
                            style: primaryText.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: phoneController,
                            style: primaryText.copyWith(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              focusColor: const Color(0xfff2f2f2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: "Masukkan Nomor...",
                              fillColor: const Color(0xfff2f2f2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              primary: primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                            ),
                            onPressed: () {
                              employees.doc(selectedStaff!.email).update({
                                'name': nameController.text,
                                'role': _dropdownRole,
                                'phone': phoneController.text,
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(milliseconds: 1000),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      CircularProgressIndicator(),
                                      SizedBox(width: 20),
                                      Text(
                                        "Mengubah Data. Mohon Tunggu .....",
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  backgroundColor: primaryColor,
                                ),
                              );

                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.save_alt_outlined),
                            label: Text("UBAH DATA")),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            primary: secondaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: primaryColor,
                          ),
                          label: Text(
                            "BATAL",
                            style: primaryText.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget columnAppbarLeft(context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 2 / 3 - 60,
    child: Row(
      children: const [],
    ),
  );
}
