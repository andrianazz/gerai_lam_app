import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/daily_trans_model.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class DialogDetailTransaction extends StatelessWidget {
  DailyTransactionModel? dailyTrans;
  DialogDetailTransaction({Key? key, this.dailyTrans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monthString = [
      '',
      'Januari',
      'February',
      'Maret',
      'April',
      'Mey',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

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
                    "Detail Rekapan",
                    style: primaryText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tanggal",
                        style: primaryText.copyWith(
                          fontSize: 14,
                          color: artikelColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${dailyTrans!.tanggal ?? ''} ${dailyTrans!.bulan != null ? monthString[dailyTrans!.bulan!] : ''} ${dailyTrans!.tahun}",
                        style: primaryText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Items",
                        style: primaryText.copyWith(
                          fontSize: 14,
                          color: artikelColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${dailyTrans!.items!.length} items",
                        style: primaryText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Produk",
                        style: primaryText.copyWith(
                          fontSize: 14,
                          color: artikelColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${dailyTrans!.totalProducts} Produk",
                        style: primaryText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "TOP 3 Produk",
                    style: primaryText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dailyTrans!.items!
                        .map((e) {
                          dailyTrans!.items!.sort(
                              (a, b) => b.quantity!.compareTo(a.quantity!));

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.name!,
                                style: primaryText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                e.quantity!.toString(),
                                style: primaryText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          );
                        })
                        .take(3)
                        .toList(),
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
                    "Detail Items",
                    style: primaryText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: dailyTrans!.items!
                        .map((e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.name!,
                                  style: primaryText.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Harga Modal",
                                      style: primaryText.copyWith(
                                        fontSize: 14,
                                        color: artikelColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                              name: "Rp. ", decimalDigits: 0)
                                          .format(e.capital),
                                      style: primaryText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Harga Jual",
                                      style: primaryText.copyWith(
                                        fontSize: 14,
                                        color: artikelColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                              name: "Rp. ", decimalDigits: 0)
                                          .format(e.price),
                                      style: primaryText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Terjual",
                                      style: primaryText.copyWith(
                                        fontSize: 14,
                                        color: artikelColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      e.quantity.toString(),
                                      style: primaryText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: primaryText.copyWith(
                                        fontSize: 14,
                                        color: artikelColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                              name: "Rp. ", decimalDigits: 0)
                                          .format(e.total),
                                      style: primaryText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ))
                        .toList(),
                  )
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
                    "Total Transaksi",
                    style: primaryText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Transaksi",
                        style: primaryText.copyWith(
                          fontSize: 14,
                          color: artikelColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        NumberFormat.currency(name: "Rp. ", decimalDigits: 0)
                            .format(dailyTrans!.totalTransaction),
                        style: primaryText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
