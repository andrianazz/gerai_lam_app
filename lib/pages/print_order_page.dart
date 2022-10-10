import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/item_model.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';
import 'package:gerai_lam_app/theme.dart';
import 'package:intl/intl.dart';

class PrintOrderPage extends StatefulWidget {
  final TransactionModel? trans;
  final String? alamat;
  final List<ItemModel>? items;
  final int? subtotal;
  final int? ppn;
  final int? ppl;

  const PrintOrderPage(
      {Key? key,
      this.trans,
      this.alamat,
      this.items,
      this.subtotal,
      this.ppl,
      this.ppn})
      : super(key: key);

  @override
  State<PrintOrderPage> createState() => _PrintOrderPageState();
}

class _PrintOrderPageState extends State<PrintOrderPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'Printer Belum Tersambung';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool? isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      print('cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'Berhasil disambungkan';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'Berhasil disconnect';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected!) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Printer"),
        backgroundColor: primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            bluetoothPrint.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      tips,
                      style: primaryText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Container(
                height: 400,
                child: StreamBuilder<List<BluetoothDevice>>(
                  stream: bluetoothPrint.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!
                        .map((d) => ListTile(
                              title: Text(
                                d.name ?? '',
                                style: primaryText.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                d.address.toString(),
                                style: primaryText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () async {
                                setState(() {
                                  _device = d;
                                });
                              },
                              trailing: _device != null &&
                                      _device!.address == d.address
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null,
                            ))
                        .toList(),
                  ),
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: primaryColor,
                            primary: Colors.black,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: Text(
                            'Sambungkan',
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _connected
                              ? null
                              : () async {
                                  if (_device != null &&
                                      _device!.address != null) {
                                    await bluetoothPrint.connect(_device!);
                                  } else {
                                    setState(() {
                                      tips = 'please select device';
                                    });
                                    print('please select device');
                                  }
                                },
                        ),
                        SizedBox(width: 30),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: redColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: Text(
                            'Disconnect',
                            style: primaryText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: _connected
                              ? () async {
                                  await bluetoothPrint.disconnect();
                                }
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Print Struk',
                        style: primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _connected
                          ? () async {
                              startPrint();
                            }
                          : null,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startPrint() async {
    Map<String, dynamic> config = Map();
    // config['width'] = 58; // 标签宽度，单位mm
    // config['height'] = 20; // 标签高度，单位mm
    // config['gap'] = 0;

    String total = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: 'Rp. ',
    ).format(widget.trans!.totalTransaction);
    String bayar = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: 'Rp. ',
    ).format(widget.trans!.pay);
    String kembalian = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      name: 'Rp. ',
    ).format(widget.trans!.pay! - widget.trans!.totalTransaction!);
    var rupiah = NumberFormat.simpleCurrency(decimalDigits: 0, name: 'Rp. ');

    List<LineText> list = [];
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Galeri LAM Riau',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${widget.alamat!}',
        weight: 0,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'www.galerilamriau.com',
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '================================',
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'No Struk :',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${widget.trans!.id}',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '================================',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(linefeed: 1));

    widget.items!.map((e) {
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '${e.name}',
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 1));

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '${rupiah.format(e.price)} x${e.quantity} ',
          align: LineText.ALIGN_LEFT,
          weight: 0,
          linefeed: 1));

      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${rupiah.format(e.total)}',
        align: LineText.ALIGN_RIGHT,
        weight: 1,
        linefeed: 1,
      ));
    }).toList();

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '--------------------------------',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Subtotal',
      weight: 0,
      align: LineText.ALIGN_LEFT,
      linefeed: 1,
    ));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${rupiah.format(widget.subtotal)}',
        weight: 0,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'PPN ${widget.ppn}%',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${rupiah.format(widget.ppn! / 100 * (widget.subtotal!))}',
        weight: 0,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'PPL ${widget.ppl}%',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${rupiah.format(widget.ppl! / 100 * (widget.subtotal!))}',
        weight: 0,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '--------------------------------',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Total',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${total}',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Bayar',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '${bayar}',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '--------------------------------',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Kembalian',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '${kembalian}',
      weight: 1,
      align: LineText.ALIGN_RIGHT,
      linefeed: 1,
    ));
    list.add(LineText(linefeed: 1));

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Terima Kasih',
        align: LineText.ALIGN_CENTER,
        weight: 0,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Pelayanan menjadi prioritas kami',
        weight: 0,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    await bluetoothPrint.printReceipt(config, list);
  }
}
