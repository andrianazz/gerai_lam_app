import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/stock_cashier_model.dart';
import 'package:gerai_lam_app/models/stock_model.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class InvoiceSupplierPage extends StatelessWidget {
  StockModel? stockSupplier;
  InvoiceSupplierPage({Key? key, this.stockSupplier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var f = DateFormat('dd MMMM yyyy');
    var rupiah = NumberFormat.currency(name: 'Rp. ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice UMKM"),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sentra Budaya & Ekonomi Kreatif LAM Riau",
                      style: primaryText.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Invoice",
                      style: primaryText.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jl. Diponegoro No 39 - Pekanbaru",
                            style: primaryText.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "CP: 0852 1068 0008",
                            style: primaryText.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Email: galerilamr@gmail.com",
                            style: primaryText.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Kepada Yth ${stockSupplier!.supplier}",
                            style: primaryText.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Pekanbaru",
                            style: primaryText.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "No Faktur :",
                              style: primaryText.copyWith(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 6,
                              child: Text(
                                ": ${stockSupplier!.noFaktur}",
                                style: primaryText.copyWith(
                                  fontSize: 20,
                                ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Tgl Faktur",
                              style: primaryText.copyWith(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 6,
                              child: Text(
                                ': ${f.format(stockSupplier!.date_in!)}',
                                style: primaryText.copyWith(
                                  fontSize: 20,
                                ),
                              )),
                        ],
                      ),
                      SizedBox(height: 20),
                      stockSupplier!.stock_in!.length > 0
                          ? Text(
                              "STOK MASUK",
                              style: primaryText.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : SizedBox(),
                      stockSupplier!.stock_in!.length > 0
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
                                    i < stockSupplier!.stock_in!.length;
                                    i++)
                                  buildRow(
                                    [
                                      '${stockSupplier!.stock_in![i].nama}',
                                      '',
                                      '${stockSupplier!.stock_in![i].nama}',
                                      '${stockSupplier!.stock_in![i].stok}',
                                      'PCS',
                                      "${NumberFormat.currency(name: 'Rp. ', decimalDigits: 0).format(stockSupplier!.stock_in![i].harga)}",
                                      "${NumberFormat.currency(name: 'Rp. ', decimalDigits: 0).format(stockSupplier!.stock_in![i].total)}",
                                    ],
                                    isCenter: true,
                                  ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(height: 20),
                      stockSupplier!.stock_out!.length > 0
                          ? Text(
                              "STOK KELUAR",
                              style: primaryText.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : SizedBox(),
                      stockSupplier!.stock_out!.length > 0
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
                                    i < stockSupplier!.stock_out!.length;
                                    i++)
                                  buildRow(
                                    [
                                      '${stockSupplier!.stock_out![i].nama}',
                                      '',
                                      '${stockSupplier!.stock_out![i].nama}',
                                      '${stockSupplier!.stock_out![i].stok}',
                                      'PCS',
                                      "${NumberFormat.currency(name: 'Rp. ', decimalDigits: 0).format(stockSupplier!.stock_out![i].harga)}",
                                      "${NumberFormat.currency(name: 'Rp. ', decimalDigits: 0).format(stockSupplier!.stock_out![i].total)}",
                                    ],
                                    isCenter: true,
                                  ),
                              ],
                            )
                          : SizedBox(),
                      stockSupplier!.stock_out!.length > 0
                          ? Table(
                              columnWidths: {
                                0: FractionColumnWidth(0.20),
                                1: FractionColumnWidth(0.36),
                                2: FractionColumnWidth(0.08),
                                3: FractionColumnWidth(0.20),
                                4: FractionColumnWidth(0.20),
                              },
                              children: [
                                buildRow([
                                  'Keterangan',
                                  '* ${stockSupplier!.description}',
                                  '',
                                  'Total sub : \nDP : \nTotal Faktur : ',
                                  "${rupiah.format(stockSupplier!.stock_out!.map((expense) => expense.total).reduce((value, element) => value! + element!))} \n0 \n${rupiah.format(stockSupplier!.stock_out!.map((expense) => expense.total).reduce((value, element) => value! + element!))}"
                                ])
                              ],
                            )
                          : SizedBox(),
                      SizedBox(height: 30),
                      Table(
                        columnWidths: {
                          0: FractionColumnWidth(0.40),
                          1: FractionColumnWidth(0.30),
                          2: FractionColumnWidth(0.30),
                        },
                        children: [
                          buildRow(['', 'Diberikan oleh', 'Diterima oleh'],
                              isCenter: true),
                          buildRow(['', '', '']),
                          buildRow([
                            '',
                            'WAN IRZAWATI \nManager Operasional',
                            '${stockSupplier!.supplier}'
                          ], isCenter: true),
                        ],
                      )
                    ],
                  ),
                )
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
