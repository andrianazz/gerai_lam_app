import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/daily_trans_model.dart';
import 'package:gerai_lam_app/models/item_model.dart';
import 'package:gerai_lam_app/pages/invoice_transaction_page.dart';
import 'package:intl/intl.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

import '../theme.dart';

// ignore: must_be_immutable
class DialogDetailTransaction extends StatelessWidget {
  DailyTransactionModel? dailyTrans;
  String? supplierName;
  DialogDetailTransaction({Key? key, this.dailyTrans, this.supplierName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 1000,
        height: 800,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: showTableDetail(context),
      ),
    );
  }

  Widget showTableDetail(BuildContext context) {
    double _scrollOffsetX = 0;
    double _scrollOffsetY = 0;
    List<String> columnString = ["Qty", "Jual", "Net", "Modal", "Profit"];

    int qtyAdd = 0;
    int jualAdd = 0;
    int netAdd = 0;
    int modalAdd = 0;
    int profitAdd = 0;
    for (var e in dailyTrans!.items!) {
      qtyAdd += e.quantity!;
      jualAdd += e.price!;
      netAdd += e.nett!;
      modalAdd += e.capital!;
      profitAdd += (e.price! - e.capital!) * e.quantity!;
    }

    List<ItemModel> dataTotal = [
      ItemModel(
        name: "Total",
        quantity: qtyAdd,
        price: jualAdd,
        nett: netAdd,
        capital: modalAdd,
      ),
    ];

    return ListView(
      children: [
        Row(
          children: [
            Text(
              "Detail Transaksi",
              style: primaryText.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 500,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: greyColor.withOpacity(0.20),
            borderRadius: BorderRadius.circular(20),
          ),
          child: StickyHeadersTable(
            cellDimensions: CellDimensions.variableColumnWidthAndRowHeight(
              columnWidths: List.generate(
                  columnString.length, (index) => 800 / columnString.length),
              rowHeights:
                  List.generate(dailyTrans!.items!.length, (index) => 50),
              stickyLegendWidth: 400,
              stickyLegendHeight: 50,
            ),
            initialScrollOffsetX: _scrollOffsetX,
            initialScrollOffsetY: _scrollOffsetY,
            onEndScrolling: (scrollOffsetX, scrollOffsetY) {
              _scrollOffsetX = scrollOffsetX;
              _scrollOffsetY = scrollOffsetY;
            },
            columnsLength: columnString.length,
            legendCell: Text(
              "Nama Barang",
              style: primaryText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            rowsLength: dailyTrans!.items!.length,
            columnsTitleBuilder: (i) => Text(
              "${columnString[i].toString()}",
              style: primaryText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            rowsTitleBuilder: (i) => Text(
              "${dailyTrans!.items![i].name}",
              style: primaryText.copyWith(fontSize: 20),
            ),
            contentCellBuilder: (i, j) {
              var rupiah =
                  NumberFormat.currency(name: 'Rp. ', decimalDigits: 0);
              var angka = NumberFormat.currency(decimalDigits: 0, name: "");

              List<List<String>> dataString = dailyTrans!.items!.map((e) {
                return [
                  "${angka.format(e.quantity)}",
                  "${rupiah.format(e.price)}",
                  "${rupiah.format(e.price! - e.capital!)}",
                  "${rupiah.format(e.capital)}",
                  "${rupiah.format((e.price! - e.capital!) * e.quantity!)}",
                ];
              }).toList();

              return Text(
                "${dataString[j][i]}",
                style: primaryText.copyWith(fontSize: 16),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 120,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: greyColor.withOpacity(0.20),
            borderRadius: BorderRadius.circular(20),
          ),
          child: StickyHeadersTable(
            cellDimensions: CellDimensions.variableColumnWidthAndRowHeight(
              columnWidths: List.generate(
                  columnString.length, (index) => 800 / columnString.length),
              rowHeights: List.generate(dataTotal.length, (index) => 50),
              stickyLegendWidth: 400,
              stickyLegendHeight: 40,
            ),
            initialScrollOffsetX: _scrollOffsetX,
            initialScrollOffsetY: _scrollOffsetY,
            onEndScrolling: (scrollOffsetX, scrollOffsetY) {
              _scrollOffsetX = scrollOffsetX;
              _scrollOffsetY = scrollOffsetY;
            },
            columnsLength: columnString.length,
            rowsLength: dataTotal.length,
            columnsTitleBuilder: (i) => Text(
              "${columnString[i].toString()}",
              style: primaryText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            rowsTitleBuilder: (i) => Text(
              "${dataTotal[i].name}",
              style: primaryText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            contentCellBuilder: (i, j) {
              var rupiah =
                  NumberFormat.currency(name: 'Rp. ', decimalDigits: 0);
              var angka = NumberFormat.currency(decimalDigits: 0, name: "");

              List<List<String>> dataString2 = dataTotal.map((e) {
                return [
                  "${angka.format(e.quantity)}",
                  "${rupiah.format(e.price)}",
                  "${rupiah.format(e.price! - e.capital!)}",
                  "${rupiah.format(e.capital)}",
                  "${rupiah.format(profitAdd)}",
                ];
              }).toList();
              print(dataString2);

              return Text(
                "${dataString2[j][i]}",
                style: primaryText.copyWith(fontSize: 16),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor,
              ),
              child: Text(
                "Batal",
                style: primaryText.copyWith(fontSize: 24),
              ),
            ),
            supplierName != "" ? SizedBox(width: 20) : SizedBox(),
            supplierName != ""
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoiceTransactionPage(
                            dailyTrans: dailyTrans,
                            supplierName: supplierName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                    ),
                    child: Text(
                      "Print Invoice",
                      style: primaryText.copyWith(fontSize: 24),
                    ),
                  )
                : SizedBox(),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  // Widget showReceiptDetail(BuildContext context) {
  //   final monthString = [
  //     '',
  //     'Januari',
  //     'February',
  //     'Maret',
  //     'April',
  //     'Mey',
  //     'Juni',
  //     'Juli',
  //     'Agustus',
  //     'September',
  //     'Oktober',
  //     'November',
  //     'Desember'
  //   ];

  //   return ListView(
  //     children: [
  //       SizedBox(height: 10),
  //       Container(
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: cartColor,
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "Detail Rekapan",
  //               style: primaryText.copyWith(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             SizedBox(height: 30),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "Tanggal",
  //                   style: primaryText.copyWith(
  //                     fontSize: 14,
  //                     color: artikelColor,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //                 Text(
  //                   "${dailyTrans!.tanggal ?? ''} ${dailyTrans!.bulan != null ? monthString[dailyTrans!.bulan!] : ''} ${dailyTrans!.tahun}",
  //                   style: primaryText.copyWith(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "Total Items",
  //                   style: primaryText.copyWith(
  //                     fontSize: 14,
  //                     color: artikelColor,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //                 Text(
  //                   "${dailyTrans!.items!.length} items",
  //                   style: primaryText.copyWith(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "Total Produk",
  //                   style: primaryText.copyWith(
  //                     fontSize: 14,
  //                     color: artikelColor,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //                 Text(
  //                   "${dailyTrans!.totalProducts} Produk",
  //                   style: primaryText.copyWith(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //       SizedBox(height: 30),
  //       Container(
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: cartColor,
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Text(
  //               "TOP 3 Produk",
  //               style: primaryText.copyWith(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             SizedBox(height: 30),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: dailyTrans!.items!
  //                   .map((e) {
  //                     dailyTrans!.items!
  //                         .sort((a, b) => b.quantity!.compareTo(a.quantity!));

  //                     return Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(
  //                           e.name!,
  //                           style: primaryText.copyWith(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w700,
  //                           ),
  //                         ),
  //                         Text(
  //                           e.quantity!.toString(),
  //                           style: primaryText.copyWith(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w700,
  //                           ),
  //                         ),
  //                       ],
  //                     );
  //                   })
  //                   .take(3)
  //                   .toList(),
  //             ),
  //           ],
  //         ),
  //       ),
  //       SizedBox(height: 30),
  //       Container(
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: cartColor,
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "Detail Items",
  //               style: primaryText.copyWith(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             SizedBox(height: 30),
  //             Column(
  //               children: dailyTrans!.items!
  //                   .map((e) => Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             e.name!,
  //                             style: primaryText.copyWith(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w700,
  //                             ),
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 "Harga Modal",
  //                                 style: primaryText.copyWith(
  //                                   fontSize: 14,
  //                                   color: artikelColor,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 NumberFormat.currency(
  //                                         name: "Rp. ", decimalDigits: 0)
  //                                     .format(e.capital),
  //                                 style: primaryText.copyWith(
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 "Harga Jual",
  //                                 style: primaryText.copyWith(
  //                                   fontSize: 14,
  //                                   color: artikelColor,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 NumberFormat.currency(
  //                                         name: "Rp. ", decimalDigits: 0)
  //                                     .format(e.price),
  //                                 style: primaryText.copyWith(
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 "Terjual",
  //                                 style: primaryText.copyWith(
  //                                   fontSize: 14,
  //                                   color: artikelColor,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 e.quantity.toString(),
  //                                 style: primaryText.copyWith(
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 "Total",
  //                                 style: primaryText.copyWith(
  //                                   fontSize: 14,
  //                                   color: artikelColor,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                               Text(
  //                                 NumberFormat.currency(
  //                                         name: "Rp. ", decimalDigits: 0)
  //                                     .format(e.total),
  //                                 style: primaryText.copyWith(
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(height: 20),
  //                         ],
  //                       ))
  //                   .toList(),
  //             )
  //           ],
  //         ),
  //       ),
  //       SizedBox(height: 30),
  //       Container(
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: cartColor,
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "Total Transaksi",
  //               style: primaryText.copyWith(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             SizedBox(height: 30),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "Total Transaksi",
  //                   style: primaryText.copyWith(
  //                     fontSize: 14,
  //                     color: artikelColor,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //                 Text(
  //                   NumberFormat.currency(name: "Rp. ", decimalDigits: 0)
  //                       .format(dailyTrans!.totalTransaction),
  //                   style: primaryText.copyWith(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //       SizedBox(height: 10),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: redColor,
  //             ),
  //             child: Text(
  //               "Batal",
  //               style: primaryText.copyWith(fontSize: 24),
  //             ),
  //           ),
  //           supplierName != "" ? SizedBox(width: 20) : SizedBox(),
  //           supplierName != ""
  //               ? ElevatedButton(
  //                   onPressed: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => InvoiceTransactionPage(
  //                           dailyTrans: dailyTrans,
  //                           supplierName: supplierName,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: greenColor,
  //                   ),
  //                   child: Text(
  //                     "Print Invoice",
  //                     style: primaryText.copyWith(fontSize: 24),
  //                   ),
  //                 )
  //               : SizedBox(),
  //         ],
  //       ),
  //       SizedBox(height: 10),
  //     ],
  //   );
  // }

}
