import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../models/item_model.dart';
import '../theme.dart';

class DialogQuantity extends StatefulWidget {
  ItemModel? item;
  DialogQuantity({Key? key, this.item}) : super(key: key);

  @override
  State<DialogQuantity> createState() => _DialogQuantityState();
}

class _DialogQuantityState extends State<DialogQuantity> {
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        width: 600,
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.item!.name!,
              style: primaryText.copyWith(fontSize: 42),
            ),
            Row(
              children: [
                SizedBox(width: 50),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cartProvider.removeQuantity(widget.item!.id!, 1);
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
                Container(
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
                      widget.item!.quantity!.toString(),
                      style: primaryText.copyWith(fontSize: 52),
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
                              cartProvider.addQuantity(widget.item!.id!, 1);
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
                              cartProvider.addQuantity(widget.item!.id!, 5);
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
                              cartProvider.addQuantity(widget.item!.id!, 10);
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
                              cartProvider.addQuantity(widget.item!.id!, 50);
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
                          cartProvider.addQuantity(widget.item!.id!, 100);
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
                      primary: redColor,
                    ),
                    onPressed: () {
                      setState(() {
                        cartProvider.resetQuantity(widget.item!.id!);
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
                      cartProvider.getTotal();
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
