import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gerai_lam_app/pages/order_done_page.dart';
import 'package:gerai_lam_app/providers/cart_provider.dart';
import 'package:gerai_lam_app/providers/transaction_provider.dart';
import 'package:gerai_lam_app/widgets/drawer_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class DetailOrderPage extends StatefulWidget {
  const DetailOrderPage({Key? key}) : super(key: key);

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  bool isOngkir = false;
  TextEditingController ongkir = TextEditingController(text: '0');
  TextEditingController bayar = TextEditingController(text: '0');

  String mtdPayment = "TUNAI";

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    int subTotal = cartProvider.getTotal();
    int total = getTotal(subTotal);
    int kembali = getKembali(total);

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: const Text("Rincian Pesanan"),
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: landscape(context, subTotal, total, kembali),
    );
  }

  Widget landscape(context, int subTotal, int total, int kembali) {
    return Row(
      children: [
        columnLeft(context),
        columnCenter(subTotal, total, kembali),
        columnRight(context, subTotal, total, kembali),
      ],
    );
  }

  Widget columnLeft(context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Flexible(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      child: Text(
                        "QTY",
                        style: primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        "Nama Barang",
                        style: primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Harga",
                        style: primaryText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: cartProvider.carts
                      .map((order) => Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 41,
                                    child: Text(
                                      order.quantity.toString(),
                                      style: primaryText.copyWith(
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      order.name.toString(),
                                      style: primaryText.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    NumberFormat.simpleCurrency(
                                      decimalDigits: 0,
                                      name: 'Rp. ',
                                    ).format(order.price),
                                    style: primaryText.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                height: 1,
                                color: greyColor,
                              )
                            ],
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget columnCenter(int subTotal, int total, int kembali) {
    return Flexible(
      child: Column(
        children: [
          payment(),
          Expanded(
            child: Container(
              color: secondaryColor,
            ),
          ),
          detailPayment(subTotal, total),
          totalPayment(kembali),
        ],
      ),
    );
  }

  Widget columnRight(context, int subTotal, int total, int kembali) {
    TransactionProvider transact = Provider.of<TransactionProvider>(context);
    CartProvider cartsProvider = Provider.of<CartProvider>(context);

    return Flexible(
      child: Container(
        color: cartColor,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isOngkir = true;
                      });
                    },
                    child: Container(
                      width: 163,
                      height: 76,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: (isOngkir) ? primaryColor : greyColor,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "ONGKIR",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            color: (isOngkir) ? primaryColor : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isOngkir = false;
                      });
                    },
                    child: Container(
                      width: 163,
                      height: 76,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: (!isOngkir) ? primaryColor : greyColor,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "BAYAR",
                          style: primaryText.copyWith(
                            fontSize: 20,
                            color: (!isOngkir) ? primaryColor : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isOngkir) {
                              ongkir.text = ongkir.text + "7";
                            } else {
                              bayar.text = bayar.text + "7";
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: isOngkir ? blueColor : Colors.blue,
                                width: 5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "7",
                              style: primaryText.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isOngkir) {
                              ongkir.text = ongkir.text + "8";
                            } else {
                              bayar.text = bayar.text + "8";
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: isOngkir ? blueColor : Colors.blue,
                                width: 5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "8",
                              style: primaryText.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isOngkir) {
                              ongkir.text = ongkir.text + "9";
                            } else {
                              bayar.text = bayar.text + "9";
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: isOngkir ? blueColor : Colors.blue,
                                width: 5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "9",
                              style: primaryText.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isOngkir) {
                              ongkir.text = ongkir.text + "4";
                            } else {
                              bayar.text = bayar.text + "4";
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: isOngkir ? blueColor : Colors.blue,
                                width: 5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "4",
                              style: primaryText.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isOngkir) {
                              ongkir.text = ongkir.text + "5";
                            } else {
                              bayar.text = bayar.text + "5";
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: isOngkir ? blueColor : Colors.blue,
                                width: 5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "5",
                              style: primaryText.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isOngkir) {
                              ongkir.text = ongkir.text + "6";
                            } else {
                              bayar.text = bayar.text + "6";
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: isOngkir ? blueColor : Colors.blue,
                                width: 5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "6",
                              style: primaryText.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isOngkir) {
                              ongkir.text = ongkir.text + "1";
                            } else {
                              bayar.text = bayar.text + "1";
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: isOngkir ? blueColor : Colors.blue,
                                width: 5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "1",
                              style: primaryText.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isOngkir) {
                              ongkir.text = ongkir.text + "2";
                            } else {
                              bayar.text = bayar.text + "2";
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: isOngkir ? blueColor : Colors.blue,
                                width: 5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "2",
                              style: primaryText.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isOngkir) {
                              ongkir.text = ongkir.text + "3";
                            } else {
                              bayar.text = bayar.text + "3";
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: isOngkir ? blueColor : Colors.blue,
                                width: 5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "3",
                              style: primaryText.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isOngkir) {
                              ongkir.text = ongkir.text + "0";
                            } else {
                              bayar.text = bayar.text + "0";
                            }
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: isOngkir ? blueColor : Colors.blue,
                                width: 5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "0",
                              style: primaryText.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isOngkir) {
                                ongkir.text = '0';
                              } else {
                                bayar.text = '0';
                              }
                            });
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: redColor, width: 5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "RESET",
                                style: primaryText.copyWith(
                                  fontSize: 32,
                                  color: redColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    transact.addTransactions(cartsProvider.carts, mtdPayment,
                        int.parse(ongkir.text), total);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => OrderDonePage(
                                  subTotal: subTotal,
                                  total: total,
                                  kembali: kembali,
                                  ongkir: int.parse(ongkir.text),
                                  bayar: int.parse(bayar.text),
                                )));
                  });
                },
                child: Container(
                  color: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "PEMBAYARAN",
                        style: primaryText.copyWith(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget payment() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      color: secondaryColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    mtdPayment = "TUNAI";
                  });
                },
                child: Container(
                  width: 163,
                  height: 76,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (mtdPayment == "TUNAI") ? primaryColor : greyColor,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "TUNAI",
                      style: primaryText.copyWith(
                        fontSize: 20,
                        color: (mtdPayment == "TUNAI")
                            ? primaryColor
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    mtdPayment = "EDC";
                  });
                },
                child: Container(
                  width: 163,
                  height: 76,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (mtdPayment == "EDC") ? primaryColor : greyColor,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "EDC",
                      style: primaryText.copyWith(
                        fontSize: 20,
                        color:
                            (mtdPayment == "EDC") ? primaryColor : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    mtdPayment = "OVO";
                  });
                },
                child: Container(
                  width: 163,
                  height: 76,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (mtdPayment == "OVO") ? primaryColor : greyColor,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "OVO",
                      style: primaryText.copyWith(
                        fontSize: 20,
                        color:
                            (mtdPayment == "OVO") ? primaryColor : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    mtdPayment = "GRAB";
                  });
                },
                child: Container(
                  width: 163,
                  height: 76,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (mtdPayment == "GRAB") ? primaryColor : greyColor,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "GRAB",
                      style: primaryText.copyWith(
                        fontSize: 20,
                        color: (mtdPayment == "GRAB")
                            ? primaryColor
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    mtdPayment = "TRANSFER";
                  });
                },
                child: Container(
                  width: 163,
                  height: 76,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          (mtdPayment == "TRANSFER") ? primaryColor : greyColor,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "TRANSFER",
                      style: primaryText.copyWith(
                        fontSize: 20,
                        color: (mtdPayment == "TRANSFER")
                            ? primaryColor
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    mtdPayment = "DANA";
                  });
                },
                child: Container(
                  width: 163,
                  height: 76,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (mtdPayment == "DANA") ? primaryColor : greyColor,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "DANA",
                      style: primaryText.copyWith(
                        fontSize: 20,
                        color: (mtdPayment == "DANA")
                            ? primaryColor
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget detailPayment(int subTotal, int total) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      color: secondaryBlueColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SUBTOTAL",
                style: primaryText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                NumberFormat.simpleCurrency(
                  decimalDigits: 0,
                  name: 'Rp. ',
                ).format(subTotal),
                style: primaryText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isOngkir = true;
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ONGKOS KIRIM",
                    style: primaryText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    NumberFormat.simpleCurrency(
                      decimalDigits: 0,
                      name: 'Rp. ',
                    ).format(int.parse(ongkir.text)),
                    style: primaryText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOTAL (ppn)",
                style: primaryText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                NumberFormat.simpleCurrency(
                  decimalDigits: 0,
                  name: 'Rp. ',
                ).format(total),
                style: primaryText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isOngkir = false;
              });
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "BAYAR",
                    style: primaryText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    NumberFormat.simpleCurrency(
                      decimalDigits: 0,
                      name: 'Rp. ',
                    ).format(int.parse(bayar.text)),
                    style: primaryText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget totalPayment(int kembali) {
    return Container(
      height: 89,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(color: primaryColor, width: 2),
      ),
      child: Row(
        children: [
          Text(
            "KEMBALI",
            style: primaryText.copyWith(
              color: primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              NumberFormat.simpleCurrency(
                decimalDigits: 0,
                name: 'Rp. ',
              ).format(kembali),
              style: primaryText.copyWith(
                color: primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  int getTotal(int subtotal) {
    int total = subtotal + int.parse(ongkir.text) + Random().nextInt(499);
    return total;
  }

  int getKembali(int total) {
    int kembali = int.parse(bayar.text) - total;
    return kembali;
  }
}
