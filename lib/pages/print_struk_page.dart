import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/theme.dart';
import 'package:intl/intl.dart';

import '../models/product_model.dart';

class PrintStrukPage extends StatefulWidget {
  ProductModel? product;
  PrintStrukPage({Key? key, this.product}) : super(key: key);

  @override
  State<PrintStrukPage> createState() => _PrintStrukPageState();
}

class _PrintStrukPageState extends State<PrintStrukPage> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printerManager.scanResults.listen((devices) async {
      // print('UI: Devices found ${devices.length}');
      setState(() {
        _devices = devices;
      });
    });
  }

  void _startScanDevices() {
    setState(() {
      _devices = [];
    });
    printerManager.startScan(Duration(seconds: 4));
  }

  void _stopScanDevices() {
    printerManager.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Printer Thermal"),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
          itemCount: _devices.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () => _testPrint(_devices[index]),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.print),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(_devices[index].name ?? ''),
                              Text(_devices[index].address!),
                              Text(
                                'Tekan untuk mencetak Label',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          }),
      floatingActionButton: StreamBuilder<bool>(
        stream: printerManager.isScanningStream,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: _stopScanDevices,
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: _startScanDevices,
            );
          }
        },
      ),
    );
  }

  void _testPrint(PrinterBluetooth printer) async {
    printerManager.selectPrinter(printer);

    // TODO Don't forget to choose printer's paper
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();

    // TEST PRINT
    // final PosPrintResult res =
    // await printerManager.printTicket(await testTicket(paper));

    // DEMO RECEIPT
    final PosPrintResult res =
        await printerManager.printTicket((await testTicket(paper, profile)));

    print(res.msg);
  }

  Future<List<int>> testTicket(
      PaperSize paper, CapabilityProfile profile) async {
    String harga = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: 'Rp. ',
    ).format(widget.product!.harga_jual);

    final Generator generator = Generator(paper, profile);
    List<int> bytes = [];
    bytes += generator.text('${widget.product!.nama!}',
        styles: PosStyles(
            align: PosAlign.left, bold: true, height: PosTextSize.size1));
    bytes += generator.text('${harga}',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    // Print barcode
    String barcode = widget.product!.barcode!;
    final List<int> barData = barcode.split('').map(int.parse).toList();
    bytes += generator.barcode(Barcode.upcA(barData));

    bytes += generator.feed(2);

    bytes += generator.cut();
    return bytes;
  }
}
