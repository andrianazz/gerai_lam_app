import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/stock_cashier_model.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

class InvoiceSupplierPage extends StatelessWidget {
  StockCashierModel? stockCashier;
  InvoiceSupplierPage({Key? key, this.stockCashier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var f = DateFormat('dd MMMM yyyy');

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
            margin: EdgeInsets.all(50),
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
                            "Jl Diponegoro No 39 - Pekanbaru",
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
                            "Kepada Yth ${stockCashier!.cashier_out!.name}",
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
                                ": ${stockCashier!.noFaktur}",
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
                                ': ${f.format(stockCashier!.date_in!)}',
                                style: primaryText.copyWith(
                                  fontSize: 20,
                                ),
                              )),
                        ],
                      ),
                      SizedBox(height: 20),
                      Table(
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
                          ),
                          for (int i = 0;
                              i < stockCashier!.stock_in!.length;
                              i++)
                            buildRow([
                              '${stockCashier!.stock_in![i].nama}',
                              '',
                              '${stockCashier!.stock_in![i].nama}',
                              '${stockCashier!.stock_in![i].stok}',
                              'PCS',
                              "${NumberFormat.currency(name: 'Rp. ', decimalDigits: 0).format(stockCashier!.stock_in![i].harga)}",
                              "${NumberFormat.currency(name: 'Rp. ', decimalDigits: 0).format(stockCashier!.stock_in![i].total)}",
                            ]),
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

  TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
        children: cells.map(
          (cell) {
            final style = primaryText.copyWith(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: 18,
            );
            return Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Text(
                  cell,
                  style: style,
                ),
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
