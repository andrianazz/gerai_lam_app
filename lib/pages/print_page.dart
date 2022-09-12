import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/theme.dart';

class PrintPage extends StatefulWidget {
  final ProductModel? product;
  final int? qty;
  PrintPage({Key? key, this.product, this.qty}) : super(key: key);

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
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
                        'Print Label (TSC)',
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
    // String harga = NumberFormat.simpleCurrency(
    //   decimalDigits: 0,
    //   name: 'Rp. ',
    // ).format(widget.product!.harga_jual);

    Map<String, dynamic> config = Map();
    config['width'] = 33; // 标签宽度，单位mm
    config['height'] = 20; // 标签高度，单位mm
    config['gap'] = 4;

    List<LineText> list = [];
    // list.add(LineText(
    //   type: LineText.TYPE_TEXT,
    //   align: LineText.ALIGN_CENTER,
    //   x: 20,
    //   y: 4,
    //   content: '${widget.product!.barcode!}',
    // ));
    list.add(
      LineText(
        type: LineText.TYPE_BARCODE,
        align: LineText.ALIGN_CENTER,
        x: 45,
        // y: 40,
        y: 20,
        content: widget.product!.barcode.toString(),
      ),
    );

    for (var i = 0; i < (widget.qty)!.toInt(); i++) {
      await bluetoothPrint.printLabel(config, list);
    }
  }
}
