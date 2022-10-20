import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gerai_lam_app/models/annual_trans_model.dart';
import 'package:gerai_lam_app/models/daily_trans_model.dart';
import 'package:gerai_lam_app/models/employee_model.dart';
import 'package:gerai_lam_app/models/filter_model.dart';
import 'package:gerai_lam_app/models/monthly_transaction_model.dart';
import 'package:gerai_lam_app/models/product_model.dart';
import 'package:gerai_lam_app/models/supplier_model.dart';
import 'package:gerai_lam_app/models/transaction_model.dart';
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
    DateFormat tFormat = DateFormat('dd MMMM yyyy');

    List<FilterModel> struk = [];
    try {
      await firestore
          .collection("day_recap")
          .orderBy('tanggal', descending: true)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) async {
          DayRecapModel recap1 =
              DayRecapModel.fromJson(doc.data() as Map<String, dynamic>);
          Map<String, dynamic> recap = doc.data() as Map<String, dynamic>;

          struk.add(FilterModel(
            column1: tFormat.format(recap1.tanggal!),
            column2: angka.format((recap1.totalProduk)),
            column3: angka.format((recap1.items!.length)),
            column4: rupiah.format((recap1.totalTransaksi)),
          ));

          if (recap['tanggal'].toDate() !=
              DateTime.now().subtract(Duration(days: 1))) {
            // print(tFormat.format(DateTime.now().subtract(Duration(days: 1))));
            // print(tFormat.format(recap['tanggal'].toDate()));

            await firestore
                .collection("transactions")
                .where('tanggal',
                    isGreaterThan: recap['tanggal'].toDate(),
                    isLessThanOrEqualTo:
                        DateTime.now().subtract(Duration(days: 1)))
                .get()
                .then((snapshot2) {
              snapshot2.docs.forEach((doc2) {
                Map<String, dynamic> temp = doc2.data() as Map<String, dynamic>;
                print(temp);
              });

              return struk;
            });
          }

          // struk.add(FilterModel(
          //   column1: tFormat.format(recap['tanggal'].toDate()),
          //   column2: angka.format((recap['total_produk'])),
          //   column3: angka.format((recap['items'].length)),
          //   column4: rupiah.format(recap['total_transaksi']),
          // ));

          // DateTime today = DateTime.now().subtract(Duration(days: 1));
          // var todayDate = today.day;
          // var todayMonth = today.month;
          //
        });
      });

      return struk;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<FilterModel>> getDaily(
      {ProductModel? filterProduct,
      SupplierModel? filterSupplier,
      EmployeeModel? filterCashier}) async {
    final rupiah = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    final angka = NumberFormat.currency(decimalDigits: 0, symbol: '');
    List<FilterModel> struk = [];

    final monthString = [
      '',
      'Januari',
      'February',
      'Maret',
      'April',
      'Mey',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    try {
      var trans = <TransactionModel>[];
      trans = await retrieveTransactions();

      var daily = <DailyTransactionModel>[];

      //Cara Pertama
      if (filterProduct != null) {
        List<TransactionModel> filterTrans = [];

        for (var i = 0; i < trans.length; i++) {
          for (var j = 0; j < trans[i].items!.length; j++) {
            if (trans[i].items![j].name == filterProduct.nama) {
              trans[i]
                  .items!
                  .removeWhere((element) => element.name != filterProduct.nama);

              filterTrans.add(trans[i]);
            }
          }
        }

        daily = generateDaily(filterTrans);
      } else if (filterSupplier != null) {
        List<TransactionModel> filterTrans = [];

        for (var i = 0; i < trans.length; i++) {
          for (var j = 0; j < trans[i].items!.length; j++) {
            if (trans[i].items![j].idSupplier == filterSupplier.id) {
              trans[i].items!.removeWhere(
                  (element) => element.idSupplier != filterSupplier.id);

              filterTrans.add(trans[i]);
            }
          }
        }

        daily = generateDaily(filterTrans);
      } else if (filterCashier != null) {
        List<TransactionModel> filterTrans = [];

        for (var i = 0; i < trans.length; i++) {
          if (trans[i].idCashier == filterCashier.id) {
            filterTrans.add(trans[i]);
          }
        }
        daily = generateDaily(filterTrans);
      } else {
        daily = generateDaily(trans);
      }

      daily.sort(
          (a, b) => b.tanggal!.compareTo(num.parse(a.tanggal.toString())));
      daily.sort((a, b) => b.bulan!.compareTo(num.parse(a.bulan.toString())));

      // if (filterProduct != null) {
      //   final foundProduct = daily.where((item) =>
      //       item.items!.any((e) => e.name!.contains(filterProduct.nama!)));

      //   foundProduct.forEach((doc) {
      //     struk.add(FilterModel(
      //       column1: ' ${doc.tanggal} ' + monthString[doc.bulan!.toInt()],
      //       column2: angka.format(doc.totalProducts),
      //       column3: angka.format(doc.items!.length),
      //       column4: rupiah.format(doc.totalTransaction),
      //     ));
      //   });
      // } else {
      //   daily.forEach((doc) {
      //     struk.add(FilterModel(
      //       column1: ' ${doc.tanggal} ' + monthString[doc.bulan!.toInt()],
      //       column2: angka.format(doc.totalProducts),
      //       column3: angka.format(doc.items!.length),
      //       column4: rupiah.format(doc.totalTransaction),
      //     ));
      //   });
      // }

      if (filterProduct != null) {
        daily.forEach((doc) {
          doc.totalTransaction = doc.items![0].quantity! * doc.items![0].price!;
          struk.add(FilterModel(
            column1: ' ${doc.tanggal} ' + monthString[doc.bulan!.toInt()],
            column2: rupiah.format(doc.items![0].price),
            column3: angka.format(doc.items![0].quantity),
            column4:
                rupiah.format(doc.items![0].quantity! * doc.items![0].price!),
            column5: doc,
          ));
        });
      } else {
        daily.forEach((doc) {
          struk.add(FilterModel(
            column1: ' ${doc.tanggal} ' + monthString[doc.bulan!.toInt()],
            column2: angka.format(doc.items!.length),
            column3: angka.format(doc.totalProducts),
            column4: rupiah.format(doc.totalTransaction),
            column5: doc,
          ));
        });
      }

      return struk;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<FilterModel>> getMonthly(
      {ProductModel? filterProduct,
      SupplierModel? filterSupplier,
      EmployeeModel? filterCashier}) async {
    final rupiah = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    final angka = NumberFormat.currency(decimalDigits: 0, symbol: '');

    List<FilterModel> struk = [];

    final monthString = [
      '',
      'Januari',
      'February',
      'Maret',
      'April',
      'Mey',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    try {
      var trans = <TransactionModel>[];
      trans = await retrieveTransactions();

      var monthly = <MonthlyTransactionModel>[];

      // var monthly = generateMonthly(trans);

      //Cara Pertama
      if (filterProduct != null) {
        List<TransactionModel> filterTrans = [];

        for (var i = 0; i < trans.length; i++) {
          for (var j = 0; j < trans[i].items!.length; j++) {
            if (trans[i].items![j].name == filterProduct.nama) {
              trans[i]
                  .items!
                  .removeWhere((value) => value.name != filterProduct.nama);

              filterTrans.add(trans[i]);
            }
          }
        }

        monthly = generateMonthly(filterTrans);
      } else if (filterSupplier != null) {
        List<TransactionModel> filterTrans = [];

        for (var i = 0; i < trans.length; i++) {
          for (var j = 0; j < trans[i].items!.length; j++) {
            if (trans[i].items![j].idSupplier == filterSupplier.id) {
              trans[i].items!.removeWhere(
                  (element) => element.idSupplier != filterSupplier.id);

              filterTrans.add(trans[i]);
            }
          }
        }

        monthly = generateMonthly(filterTrans);
      } else if (filterCashier != null) {
        List<TransactionModel> filterTrans = [];

        for (var i = 0; i < trans.length; i++) {
          if (trans[i].idCashier == filterCashier.id) {
            filterTrans.add(trans[i]);
          }
        }
        monthly = generateMonthly(filterTrans);
      } else {
        monthly = generateMonthly(trans);
      }

      monthly.sort((a, b) => b.tahun!.compareTo(num.parse(a.tahun.toString())));
      monthly.sort((a, b) => b.bulan!.compareTo(num.parse(a.bulan.toString())));

      if (filterProduct != null) {
        monthly.forEach((doc) {
          struk.add(FilterModel(
            column1: monthString[doc.bulan!.toInt()] + ' ${doc.tahun}',
            column2: rupiah.format(doc.items![0].price),
            column3: angka.format(doc.items![0].quantity),
            column4:
                rupiah.format(doc.items![0].quantity! * doc.items![0].price!),
            column5: DailyTransactionModel.fromMonthly(doc),
          ));
        });
      } else {
        monthly.forEach((doc) {
          struk.add(FilterModel(
            column1: monthString[doc.bulan!.toInt()] + ' ${doc.tahun}',
            column2: angka.format(doc.items!.length),
            column3: angka.format(doc.totalProducts),
            column4: rupiah.format(doc.totalTransaction),
            column5: DailyTransactionModel.fromMonthly(doc),
          ));
        });
      }

      return struk;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<FilterModel>> getAnnual(
      {ProductModel? filterProduct,
      SupplierModel? filterSupplier,
      EmployeeModel? filterCashier}) async {
    final rupiah = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    final angka = NumberFormat.currency(decimalDigits: 0, symbol: '');

    try {
      var trans = <TransactionModel>[];
      trans = await retrieveTransactions();

      var annual = <AnnualTransModel>[];

      List<FilterModel> struk = [];

      // var monthly = generateMonthly(trans);

      //Cara Pertama
      if (filterProduct != null) {
        List<TransactionModel> filterTrans = [];

        for (var i = 0; i < trans.length; i++) {
          for (var j = 0; j < trans[i].items!.length; j++) {
            if (trans[i].items![j].name == filterProduct.nama) {
              trans[i]
                  .items!
                  .removeWhere((value) => value.name != filterProduct.nama);

              filterTrans.add(trans[i]);
            }
          }
        }

        annual = generateAnnual(filterTrans);
      } else if (filterSupplier != null) {
        List<TransactionModel> filterTrans = [];

        for (var i = 0; i < trans.length; i++) {
          for (var j = 0; j < trans[i].items!.length; j++) {
            if (trans[i].items![j].idSupplier == filterSupplier.id) {
              trans[i].items!.removeWhere(
                  (element) => element.idSupplier != filterSupplier.id);

              filterTrans.add(trans[i]);
            }
          }
        }

        annual = generateAnnual(filterTrans);
      } else if (filterCashier != null) {
        List<TransactionModel> filterTrans = [];

        for (var i = 0; i < trans.length; i++) {
          if (trans[i].idCashier == filterCashier.id) {
            filterTrans.add(trans[i]);
          }
        }
        annual = generateAnnual(filterTrans);
      } else {
        annual = generateAnnual(trans);
      }

      annual.sort((a, b) => b.tahun!.compareTo(num.parse(a.tahun.toString())));

      if (filterProduct != null) {
        annual.forEach((doc) {
          struk.add(FilterModel(
            column1: '${doc.tahun}',
            column2: rupiah.format(doc.items![0].price),
            column3: angka.format(doc.items![0].quantity),
            column4:
                rupiah.format(doc.items![0].quantity! * doc.items![0].price!),
            column5: DailyTransactionModel.fromAnnual(doc),
          ));
        });
      } else {
        annual.forEach((doc) {
          struk.add(FilterModel(
            column1: '${doc.tahun}',
            column2: angka.format(doc.items!.length),
            column3: angka.format(doc.totalProducts),
            column4: rupiah.format(doc.totalTransaction),
            column5: DailyTransactionModel.fromAnnual(doc),
          ));
        });
      }

      return struk;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  List<DailyTransactionModel> generateDaily(List<TransactionModel> trans) {
    // Buat list baru
    var transDay = <DailyTransactionModel>[];

    // Loops
    for (int i = 0; i < trans.length; i++) {
      // Get tahun dan bulan
      int? tahun = trans[i].date?.year;
      int? bulan = trans[i].date?.month;
      int? tanggal = trans[i].date?.day;
      // print('${trans[i].id} => $tahun $bulan');
      // get index if exist
      int index = -1;
      if (transDay.length > 0) {
        index = (transDay
            .indexWhere((o) => o.bulan == bulan && o.tanggal == tanggal));
      }

      // Adding to transMon
      if (index < 0) {
        // if not exist
        DailyTransactionModel mon = DailyTransactionModel.fromTrans(trans[i]);
        transDay.add(mon);
      } else {
        // if exist
        transDay[index].addTrans(trans[i]);
      }
    }

    transDay.removeWhere((element) => element.tanggal == DateTime.now().day);

    // return
    return transDay;
  }

  List<MonthlyTransactionModel> generateMonthly(List<TransactionModel> trans) {
    // Buat list baru
    var transMon = <MonthlyTransactionModel>[];

    // Loops
    for (int i = 0; i < trans.length; i++) {
      // Get tahun dan bulan
      int? tahun = trans[i].date?.year;
      int? bulan = trans[i].date?.month;
      // print('${trans[i].id} => $tahun $bulan');
      // get index if exist
      int index = -1;
      if (transMon.length > 0) {
        index =
            (transMon.indexWhere((o) => o.tahun == tahun && o.bulan == bulan));
      }

      // Adding to transMon
      if (index < 0) {
        // if not exist
        MonthlyTransactionModel mon =
            MonthlyTransactionModel.fromTrans(trans[i]);
        transMon.add(mon);
      } else {
        // if exist
        transMon[index].addTrans(trans[i]);
      }
    }

    transMon.removeWhere((element) => element.bulan == DateTime.now().month);

    // return
    return transMon;
  }

  List<AnnualTransModel> generateAnnual(List<TransactionModel> trans) {
    // Buat list baru
    var transAnnual = <AnnualTransModel>[];

    // Loops
    for (int i = 0; i < trans.length; i++) {
      // Get tahun dan bulan
      int? tahun = trans[i].date?.year;
      int? bulan = trans[i].date?.month;
      // print('${trans[i].id} => $tahun $bulan');
      // get index if exist
      int index = -1;
      if (transAnnual.length > 0) {
        index = (transAnnual.indexWhere((o) => o.tahun == tahun));
      }

      // Adding to transMon
      if (index < 0) {
        // if not exist
        AnnualTransModel mon = AnnualTransModel.fromTrans(trans[i]);
        transAnnual.add(mon);
      } else {
        // if exist
        transAnnual[index].addTrans(trans[i]);
      }
    }

    transAnnual.removeWhere((element) => element.tahun == DateTime.now().year);

    // return
    return transAnnual;
  }

  Future<List<TransactionModel>> retrieveTransactions() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("transactions")
        .where("status", isEqualTo: "Selesai")
        .get();

    return snapshot.docs.map((docSnashot) {
      TransactionModel trans =
          TransactionModel.fromJson(docSnashot.data() as Map<String, dynamic>);

      return trans;
    }).toList();
  }
}
