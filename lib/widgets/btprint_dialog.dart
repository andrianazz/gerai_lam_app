import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/item_model.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';
import 'package:gerai_lam_app/providers/cart_provider.dart';
import 'package:gerai_lam_app/providers/transaction_provider.dart';
import 'package:gerai_lam_app/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BTPrintDialog extends StatefulWidget {
  final TransactionModel? trans;
  final String? alamat;
  final List<ItemModel>? items;
  final int? subtotal;
  final int? ppn;
  final int? ppl;
  const BTPrintDialog({
    Key? key,
    this.trans,
    this.alamat,
    this.items,
    this.subtotal,
    this.ppl,
    this.ppn,
  }) : super(key: key);

  @override
  State<BTPrintDialog> createState() => _BTPrintDialogState();
}

class _BTPrintDialogState extends State<BTPrintDialog> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    getDevices();
    super.initState();
  }

  void getDevices() async {
    devices = await printer.getBondedDevices();
    setState(() {});
    print(devices);
  }

  @override
  Widget build(BuildContext context) {
    TransactionProvider tProvider = Provider.of<TransactionProvider>(context);
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 800,
        height: 500,
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Printer Thermal",
              style: primaryText.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            Column(
              children: devices
                  .map(
                    (e) => GestureDetector(
                      onTap: () {
                        testPrint(
                            e, tProvider.transactions[0], cartProvider.carts);

                        Navigator.pop(context);
                      },
                      child: ListTile(
                        title: Text(e.name!),
                        subtitle: Text(e.address!),
                        leading: Icon(Icons.print),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void testPrint(BluetoothDevice device, TransactionModel trans,
      List<ItemModel> item) async {
    String total = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: 'Rp. ',
    ).format(trans.totalTransaction);
    String bayar = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: 'Rp. ',
    ).format(trans.pay);
    String kembalian = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: 'Rp. ',
    ).format(trans.pay! - trans.totalTransaction!);

    String tanggalStruk = DateFormat("dd MMMM yyyy").format(trans.date!);

    // String ongkir = NumberFormat.simpleCurrency(
    //   decimalDigits: 0,
    //   name: 'Rp. ',
    // ).format(trans.ongkir);

    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

    if ((await printer.isConnected)!) {
      printer.printCustom("Sentra Budaya & Ekraf Riau", 3, 1);
      printer.printCustom("${widget.alamat},", 1, 1);
      // printer.printCustom("Kec. Sail, Kota Pekanbaru", 1, 1);
      // printer.printCustom("Riau 28156", 1, 1);
      printer.printCustom("www.galerilamriau.com", 1, 1);
      printer.printCustom("==========================================", 0, 2);
      //bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      printer.printCustom("No Struk : ${trans.id}", 1, 1);
      printer.printCustom("Tanggal : ${tanggalStruk}", 1, 1);
      printer.printCustom("==========================================", 0, 2);
      printer.printNewLine();
      item.map((e) {
        printer.printLeftRight("${e.name}", "", 1);
        printer.print4Column(
            "   ${e.price}", "x${e.quantity}", ":", "${e.total}", 1);
      }).toList();
      printer.printCustom("-----------------------------------------", 0, 2);
      printer.printLeftRight("SubTotal", "${(widget.subtotal)}", 1);
      printer.printLeftRight("ppn(${widget.ppn}%)",
          "${(widget.ppn! / 100 * (widget.subtotal!)).toInt()}", 1);
      printer.printLeftRight("ppl(${widget.ppl}%)",
          "${(widget.ppl! / 100 * (widget.subtotal!)).toInt()}", 1);
      printer.printCustom("-----------------------------------------", 0, 2);
      printer.printLeftRight("Total", "${total}", 1);
      printer.printLeftRight("Bayar", "${bayar}", 1);
      printer.printCustom("-----------------------------------------", 0, 2);
      printer.printLeftRight("Kembalian", '${kembalian}', 1);
      printer.printNewLine();

      printer.printCustom("Terima kasih", 1, 1);
      printer.printCustom("Semoga puas dengan pelayanan kami", 0, 1);
      printer.paperCut().then((value) => printer.drawerPin2());
    }

    // printer.drawerPin2();

    printer.connect(device);
  }
}
