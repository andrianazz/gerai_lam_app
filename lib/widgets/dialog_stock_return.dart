import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/stock_return_model.dart';
import 'package:gerai_lam_app/providers/stock_return_provider.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

// ignore: must_be_immutable
class DialogStockReturn extends StatefulWidget {
  StockReturnModel? stock;
  DialogStockReturn({Key? key, this.stock}) : super(key: key);

  @override
  State<DialogStockReturn> createState() => _DialogStockReturnState();
}

class _DialogStockReturnState extends State<DialogStockReturn> {
  @override
  Widget build(BuildContext context) {
    StockReturnProvider _stockProvider =
        Provider.of<StockReturnProvider>(context);

    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        width: 600,
        height: 400,
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
                      _stockProvider.removeQuantity(widget.stock!.indexId!, 1);
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
                                  widget.stock!.indexId!, 1);
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
                                  widget.stock!.indexId!, 5);
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
                                  widget.stock!.indexId!, 10);
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
                                  widget.stock!.indexId!, 50);
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
                          _stockProvider.addQuantity(
                              widget.stock!.indexId!, 100);
                        });
                      },
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: secondaryColor,
                            border: Border.all(color: primaryColor, width: 3)),
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
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _stockProvider.resetQuantity(widget.stock!.indexId!);
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
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
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
    );
  }
}
