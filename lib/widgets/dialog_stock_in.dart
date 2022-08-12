import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/stock_in_model.dart';
import 'package:gerai_lam_app/providers/stock_in_provider.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class DialogStockIn extends StatefulWidget {
  StockInModel? stock;
  DialogStockIn({Key? key, this.stock}) : super(key: key);

  @override
  State<DialogStockIn> createState() => _DialogStockInState();
}

class _DialogStockInState extends State<DialogStockIn> {
  TextEditingController priceController = TextEditingController();
  TextEditingController capController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StockInProvider _stockProvider = Provider.of<StockInProvider>(context);
    setState(() {
      capController.text = widget.stock!.harga.toString();
      priceController.text = widget.stock!.hargaJual.toString();
    });
    return SingleChildScrollView(
      child: Dialog(
        child: Container(
          padding: EdgeInsets.all(20),
          width: 600,
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 550,
                child: Text(
                  widget.stock!.nama!,
                  style: primaryText.copyWith(fontSize: 42),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 50),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _stockProvider.removeQuantity(widget.stock!.id!, 1);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: secondaryRedColor,
                          border: Border.all(color: redColor, width: 3)),
                      child: Text(
                        "-1",
                        style: primaryText.copyWith(
                          fontSize: 30,
                          color: redColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  Spacer(),
                  Center(
                    child: Container(
                      width: 200,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black,
                          width: 5,
                        ),
                        color: secondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.stock!.stok!.toString(),
                          style: primaryText.copyWith(fontSize: 52),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _stockProvider.addQuantity(
                                    widget.stock!.id!, 1);
                              });
                            },
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: secondaryColor,
                                  border: Border.all(
                                      color: primaryColor, width: 3)),
                              child: Center(
                                child: Text(
                                  "+1",
                                  style: primaryText.copyWith(
                                    fontSize: 30,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _stockProvider.addQuantity(
                                    widget.stock!.id!, 5);
                              });
                            },
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: secondaryColor,
                                  border: Border.all(
                                      color: primaryColor, width: 3)),
                              child: Center(
                                child: Text(
                                  "+5",
                                  style: primaryText.copyWith(
                                    fontSize: 30,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _stockProvider.addQuantity(
                                    widget.stock!.id!, 10);
                              });
                            },
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: secondaryColor,
                                  border: Border.all(
                                      color: primaryColor, width: 3)),
                              child: Center(
                                child: Text(
                                  "+10",
                                  style: primaryText.copyWith(
                                    fontSize: 30,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _stockProvider.addQuantity(
                                    widget.stock!.id!, 50);
                              });
                            },
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: secondaryColor,
                                  border: Border.all(
                                      color: primaryColor, width: 3)),
                              child: Center(
                                child: Text(
                                  "+50",
                                  style: primaryText.copyWith(
                                    fontSize: 30,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _stockProvider.addQuantity(widget.stock!.id!, 100);
                          });
                        },
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: secondaryColor,
                              border:
                                  Border.all(color: primaryColor, width: 3)),
                          child: Center(
                            child: Text(
                              "+100",
                              style: primaryText.copyWith(
                                fontSize: 30,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 200,
                    child: TextFormField(
                      controller: capController,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          decimalDigits: 0,
                          symbol: 'Rp. ',
                          locale: 'ID',
                        )
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Harga Modal',
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: TextFormField(
                      controller: priceController,
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          decimalDigits: 0,
                          symbol: 'Rp. ',
                          locale: 'ID',
                        )
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Harga Jual',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.stock!.harga = int.parse(capController.text
                              .replaceAll(RegExp('[A-Za-z]'), '')
                              .replaceAll('.', ''));

                          widget.stock!.hargaJual = int.parse(priceController
                              .text
                              .replaceAll(RegExp('[A-Za-z]'), '')
                              .replaceAll('.', ''));

                          _stockProvider
                              .resetQuantity(widget.stock!.id!.toInt());
                        });
                      },
                      child: Text("Set Harga"))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: redColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _stockProvider.resetQuantity(widget.stock!.id!);
                        });
                      },
                      child: Text(
                        "Reset",
                        style: primaryText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Text(
                        "Simpan",
                        style: primaryText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
