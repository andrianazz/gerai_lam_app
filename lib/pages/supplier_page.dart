import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/supplier_model.dart';
import 'package:gerai_lam_app/pages/sign_up_page.dart';
import 'package:gerai_lam_app/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../theme.dart';
import '../widgets/drawer_widget.dart';

class SuppplierPage extends StatefulWidget {
  const SuppplierPage({Key? key}) : super(key: key);

  @override
  State<SuppplierPage> createState() => _SuppplierPageState();
}

class _SuppplierPageState extends State<SuppplierPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  SupplierModel? selectedSupplier;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController zoneController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  String oldImage =
      'https://firebasestorage.googleapis.com/v0/b/phr-marketplace.appspot.com/o/no-image.png?alt=media&token=370795d8-34c8-454d-8e7b-6a297e404bb3';
  String? newImage;

  void imageUpload(String name) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

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
      print(newImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference suppliers = firestore.collection('supplier');

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text("Supplier"),
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
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 2 / 3 - 60,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: searchController,
                  onTap: () {
                    setState(() {
                      searchController.clear();
                    });
                  },
                  onChanged: (value) async {
                    await Future.delayed(Duration(seconds: 3), () {
                      setState(() {
                        searchController.text = value[0].toUpperCase() +
                            value.substring(1).toLowerCase();
                      });
                      print(searchController.text);
                    });
                  },
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
                  "Daftar Supplier",
                  style: primaryText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: searchController.text.isEmpty
                        ? suppliers.orderBy('name').snapshots()
                        : suppliers
                            .where("name",
                                isGreaterThanOrEqualTo: searchController.text)
                            .snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: snapshot.data!.docs.map((e) {
                            Map<String, dynamic> sup =
                                e.data()! as Map<String, dynamic>;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSupplier =
                                      SupplierModel.fromJson(sup);
                                });
                              },
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selectedSupplier == null
                                        ? Colors.transparent
                                        : selectedSupplier!.id == sup['id']
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    sup['imageUrl']),
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
                                                  sup['name'],
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
                                                  sup['phone'],
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
                                      Text(
                                        sup['zone'],
                                        style: primaryText.copyWith(
                                          fontSize: 20,
                                          color: textGreyColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
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
                ),
              ],
            ),
          ),
          Expanded(
            child: selectedSupplier == null
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 121,
                                            height: 121,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    selectedSupplier!
                                                        .imageUrl!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 25),
                                          Text(
                                            selectedSupplier!.name!,
                                            style: primaryText.copyWith(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            selectedSupplier!.id!,
                                            style: primaryText.copyWith(
                                              fontSize: 20,
                                              color: textGreyColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
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
                                          'Pihak perorangan atau perusahaan yang memasok atau menjual produk kepada pihak kami.',
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
                                          selectedSupplier!.email!,
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
                                              selectedSupplier!.phone!,
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
                                              'Zone',
                                              style: primaryText.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              selectedSupplier!.zone!,
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
                              )
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
                                                'Konfirmasi Lupa Password UMKM'),
                                            content: Text(
                                                'Apa kamu yakin ingin mengirim email kepada ${selectedSupplier!.email}?'),
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
                                                          selectedSupplier!
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
                                                'Konfirmasi menghapus Supplier'),
                                            content: Text(
                                                'Apa kamu yakin inging menghapus ${selectedSupplier!.name}?'),
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
                                                  suppliers
                                                      .doc(selectedSupplier!
                                                          .email)
                                                      .delete();

                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ));
                                  setState(() {});
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

  showEditData(context) {
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('supplier');

    String oldImage = selectedSupplier!.imageUrl ??
        "https://firebasestorage.googleapis.com/v0/b/phr-marketplace.appspot.com/o/no-image.png?alt=media&token=370795d8-34c8-454d-8e7b-6a297e404bb3";
    String? newImage;

    void imageUpload(String name) async {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      var postUri = Uri.parse("https://galerilamriau.com/api/image");
      var headers = {
        "Authorization":
            "Bearer 2wNAfr1QBPn2Qckv55u5b4GN2jrgfnC8Y7cZO04yNpXciQHrj9NaWQhs1FSMo0Jd",
        "Content-Type": "multipart/form-data",
        "Accept": "application/json",
      };

      http.MultipartRequest request =
          new http.MultipartRequest("POST", postUri);
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
        print(newImage);
      });
    }

    nameController.text = selectedSupplier!.name!;
    phoneController.text = selectedSupplier!.phone!;
    zoneController.text = selectedSupplier!.zone!;
    newImage = selectedSupplier!.imageUrl!;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 800,
          height: 800,
          margin: EdgeInsets.all(40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Ubah Data UMKM",
                    style: primaryText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50),
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
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        print(selectedSupplier!.email);
                        imageUpload(selectedSupplier!.email!.toString());
                      });
                      setState(() {});
                    },
                    child: const Text('Change Image'),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama UMKM",
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
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daerah Domisili",
                            style: primaryText.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: zoneController,
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
                              hintText: "Masukkan Daerah...",
                              fillColor: const Color(0xfff2f2f2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
                              suppliers.doc(selectedSupplier!.email).update({
                                'name': nameController.text,
                                'phone': phoneController.text,
                                'zone': zoneController.text,
                                'imageUrl': newImage ?? oldImage,
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
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpPage(
                  isEmployee: false,
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
                "TAMBAH SUPPLIER",
                style: primaryText.copyWith(fontSize: 20, color: Colors.white),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
