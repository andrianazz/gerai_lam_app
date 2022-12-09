import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/stock_cashier_model.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class InvoiceCashierPage extends StatelessWidget {
  StockCashierModel? stockCashier;
  InvoiceCashierPage({Key? key, this.stockCashier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> hari = [
      "",
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu"
    ];

    var f = DateFormat('dd MMMM yyyy');
    var m = DateFormat("MMMM");
    var y = DateFormat("yyyy");

    var rupiah = NumberFormat.currency(name: 'Rp. ', decimalDigits: 0);

    DateTime date_in = stockCashier!.date_in!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice Kasir"),
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
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Berita Acara Serah Terima Barang",
                      style: primaryText.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  "         Pada hari ini ${hari[date_in.weekday]} tanggal ${date_in.day} bulan ${m.format(date_in)} tahun ${y.format(date_in)}. Kami yang bertanda tangan dibawah ini:",
                  style: primaryText.copyWith(fontSize: 20),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            "Jabatan ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            "Alamat ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            "No Telepon ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ": ${stockCashier!.cashier_out!.name}",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            ": ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            ": ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            ": ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "Selanjutnya disebut ",
                    style: primaryText.copyWith(fontSize: 20),
                    children: [
                      TextSpan(
                        text: "PIHAK PERTAMA.",
                        style:
                            primaryText.copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            "Jabatan ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            "Alamat ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            "No Telepon ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ": ${stockCashier!.cashier_in!.name}",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            ": ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            ": ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                          Text(
                            ": ",
                            style: primaryText.copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "Selanjutnya disebut ",
                    style: primaryText.copyWith(fontSize: 20),
                    children: [
                      TextSpan(
                        text: "PIHAK KEDUA.",
                        style:
                            primaryText.copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "         PIHAK PERTAMA menyerahkan barang kepada PIHAK KEDUA, dan PIHAK KEDUA menyatakan telah menerima barang dari PIHAK PERTAMA sesuai dengan daftar terlampir.",
                  style: primaryText.copyWith(fontSize: 20),
                ),
                SizedBox(height: 30),
                stockCashier!.stock_in!.length > 0
                    ? Text(
                        "STOK MASUK",
                        style: primaryText.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : SizedBox(),
                stockCashier!.stock_in!.length > 0
                    ? Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FractionColumnWidth(0.20),
                          1: FractionColumnWidth(0.01),
                          2: FractionColumnWidth(0.30),
                          3: FractionColumnWidth(0.05),
                          4: FractionColumnWidth(0.08),
                          5: FractionColumnWidth(0.20),
                          6: FractionColumnWidth(0.20),
                        },
                        children: [
                          buildRow(
                            [
                              'Barang',
                              '',
                              'Deskripsi Barang',
                              'Kt',
                              'Satuan',
                              'Harga Satuan',
                              'Jumlah'
                            ],
                            isHeader: true,
                            isCenter: true,
                          ),
                          for (int i = 0;
                              i < stockCashier!.stock_in!.length;
                              i++)
                            buildRow(
                              [
                                '${stockCashier!.stock_in![i].nama}',
                                '',
                                '${stockCashier!.stock_in![i].nama}',
                                '${stockCashier!.stock_in![i].stok}',
                                'PCS',
                                "${NumberFormat.currency(name: 'Rp. ', decimalDigits: 0).format(stockCashier!.stock_in![i].harga)}",
                                "${NumberFormat.currency(name: 'Rp. ', decimalDigits: 0).format(stockCashier!.stock_in![i].total)}",
                              ],
                              isCenter: true,
                            ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(height: 20),
                stockCashier!.stock_out!.length > 0
                    ? Text(
                        "STOK KELUAR",
                        style: primaryText.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : SizedBox(),
                stockCashier!.stock_out!.length > 0
                    ? Table(
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FractionColumnWidth(0.20),
                          1: FractionColumnWidth(0.01),
                          2: FractionColumnWidth(0.30),
                          3: FractionColumnWidth(0.05),
                          4: FractionColumnWidth(0.08),
                          5: FractionColumnWidth(0.20),
                          6: FractionColumnWidth(0.20),
                        },
                        children: [
                          buildRow(
                            [
                              'Barang',
                              '',
                              'Deskripsi Barang',
                              'Kt',
                              'Satuan',
                              'Harga Satuan',
                              'Jumlah'
                            ],
                            isHeader: true,
                            isCenter: true,
                          ),
                          for (int i = 0;
                              i < stockCashier!.stock_out!.length;
                              i++)
                            buildRow(
                              [
                                '${stockCashier!.stock_out![i].nama}',
                                '',
                                '${stockCashier!.stock_out![i].nama}',
                                '${stockCashier!.stock_out![i].stok}',
                                'PCS',
                                "${NumberFormat.currency(name: 'Rp. ', decimalDigits: 0).format(stockCashier!.stock_out![i].harga)}",
                                "${NumberFormat.currency(name: 'Rp. ', decimalDigits: 0).format(stockCashier!.stock_out![i].total)}",
                              ],
                              isCenter: true,
                            ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(height: 30),
                Text(
                  "         Demikianlah berita acara serah terima barang ini dibuat oleh kedua belah pihak. Adapun barang yang diserahkan telah diterima dalam kondisi baik dan cukup, sehingga sejak penanda tanganan berita acara ini merupakan tanggung jawab PIHAK KEDUA untuk memelihara / merawat barang yang diterima dengan baik.",
                  style: primaryText.copyWith(fontSize: 20),
                ),
                SizedBox(height: 50),
                Table(
                  columnWidths: {
                    0: FractionColumnWidth(0.50),
                    1: FractionColumnWidth(0.50),
                  },
                  children: [
                    buildRow([
                      'Yang Menerima\nPIHAK KEDUA',
                      'Yang Menyerahkan\nPIHAK PERTAMA'
                    ], isCenter: true),
                    buildRow(['', '']),
                    buildRow([
                      '${stockCashier!.cashier_in!.name}',
                      '${stockCashier!.cashier_out!.name}'
                    ], isCenter: true),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  TableRow buildRow(List<String> cells,
          {bool isHeader = false, bool isCenter = false}) =>
      TableRow(
        children: cells.map(
          (cell) {
            final style = primaryText.copyWith(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
            );
            return Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                cell,
                style: style,
                textAlign: isCenter ? TextAlign.center : TextAlign.start,
              ),
            );
          },
        ).toList(),
      );
}

Widget columnAppbarLeft(context) {
  return Container(
    width: MediaQuery.of(context).size.width * 2 / 3 - 60,
    child: Container(),
  );
}

Widget columnAppbarRight(context) {
  return Expanded(child: Container());
}
