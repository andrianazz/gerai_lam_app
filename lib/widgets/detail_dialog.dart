import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';
import 'package:gerai_lam_app/pages/online_transaction_page.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class DetailDialog extends StatefulWidget {
  TransactionModel? trans;
  DetailDialog({Key? key, this.trans}) : super(key: key);

  @override
  State<DetailDialog> createState() => _DetailDialogState();
}

class _DetailDialogState extends State<DetailDialog> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference transactions = firestore.collection("transactions");
    TextEditingController resiController =
        TextEditingController(text: widget.trans!.resi);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 500,
        height: 800,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            Column(
              children: widget.trans!.items!
                  .map(
                    (item) => Container(
                      width: double.infinity,
                      height: 91,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: cartColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 73,
                                height: 73,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(item.imageUrl.toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      item.name.toString(),
                                      style: primaryText.copyWith(
                                          fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: NumberFormat.simpleCurrency(
                                        decimalDigits: 0,
                                        name: 'Rp. ',
                                      ).format(item.price),
                                      style: primaryText.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Text(
                            "${item.quantity} item",
                            style: primaryText.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cartColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Detail Alamat",
                    style: primaryText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: secondaryColor,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.location_on_rounded,
                                color: primaryColor,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Alamat",
                            style: primaryText.copyWith(
                              fontSize: 12,
                              color: greyColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            width: 200,
                            child: Text(
                              widget.trans!.address!,
                              style: primaryText.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cartColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Detail Pembayaran",
                    style: primaryText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: secondaryColor,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                color: primaryColor,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Metode Pembayaran",
                            style: primaryText.copyWith(
                              fontSize: 12,
                              color: greyColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            widget.trans!.payment!,
                            style: primaryText.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cartColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ongkos Kirim",
                    style: primaryText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: secondaryColor,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.delivery_dining,
                                    color: primaryColor,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ongkos Kirim",
                                style: primaryText.copyWith(
                                  fontSize: 12,
                                  color: greyColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                NumberFormat.simpleCurrency(
                                  decimalDigits: 0,
                                  name: 'Rp. ',
                                ).format(widget.trans!.ongkir!),
                                style: primaryText.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cartColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Resi",
                    style: primaryText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 300,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: TextField(
                          controller: resiController,
                          decoration: InputDecoration.collapsed(
                              hintText: "Masukkan No Resi"),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () {
                            transactions
                                .doc(widget.trans!.id.toString())
                                .update({'resi': resiController.text});

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OnlineTransactionPage(),
                              ),
                            );
                            setState(() {});
                          },
                          child: Text("Ubah")),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
