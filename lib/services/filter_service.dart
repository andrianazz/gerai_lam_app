import 'package:barcode/barcode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerai_lam_app/models/filter_model.dart';
import 'package:intl/intl.dart';

import '../models/day_recap_model.dart';

class FilterService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? namaKasir;

  Future<List<FilterModel>> getStruk() async {
    final rupiah = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    final angka = NumberFormat.currency(decimalDigits: 0, symbol: '');

    List<FilterModel> struk = [];
    try {
      await firestore
          .collection("transactions")
          // .where('status', isEqualTo: "Selesai")
          .orderBy('tanggal', descending: true)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          Map<String, dynamic> e = doc.data() as Map<String, dynamic>;
          if (e['status'].toString().contains('Selesai')) {
            // struk.add(FilterModel(
            //     column1: e['tanggal'].toDate().toString(),
            //     column2: angka.format(e['total_produk']),
            //     column3: rupiah.format(e['total_transaksi']),
            //     column4: angka.format(e['bayar'])));

            DateTime today = DateTime.now().subtract(Duration(days: 1));
            var todayDate = today.day;
            var todayMonth = today.month;

            print(today);
          } else {}
        });
      });

      return struk;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<FilterModel>> getStruk2() async {
    final rupiah = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    final angka = NumberFormat.currency(decimalDigits: 0, symbol: '');

    List<FilterModel> struk = [];
    try {
      await firestore
          .collection("day_recap")
          .orderBy('tanggal', descending: true)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          DayRecapModel recap =
              DayRecapModel.fromJson(doc.data() as Map<String, dynamic>);

          struk.add(FilterModel(
              column1: recap.tanggal.toString(),
              column2: angka.format(recap.totalProduk),
              column3: rupiah.format(recap.totalTransaksi),
              column4: angka.format(recap.items!.length)));

          // DateTime today = DateTime.now().subtract(Duration(days: 1));
          // var todayDate = today.day;
          // var todayMonth = today.month;
          //
          print(recap.totalTransaksi);
        });
      });

      return struk;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<FilterModel>> getDaily() async {
    DateTime date = DateTime.now();
    List _daysInMonth = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    int month = DateTime.now().month - 1;
    int day = 29;
    List<DateTime> dates = [];
    dates =
        List.generate(day, (index) => DateTime(date.year, month, index + 1));

    final rupiah = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    final angka = NumberFormat.currency(decimalDigits: 0, symbol: '');

    List<FilterModel> daily = [];
    try {
      await firestore.collection("transactions").get().then((snapshot) {
        snapshot.docs.forEach((doc) async {
          Map<String, dynamic> e = doc.data() as Map<String, dynamic>;

          String date = DateFormat("dd-MM-yyyy").format(e['tanggal'].toDate());

          daily.add(FilterModel(
              column1: date,
              column2: e['id_kasir'],
              column3: angka.format(e['total_produk']),
              column4: rupiah.format(e['total_transaksi'])));
        });
      });

      return daily;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
