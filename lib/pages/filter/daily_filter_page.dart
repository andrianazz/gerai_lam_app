import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/employee_model.dart';
import '../../models/filter_model.dart';
import '../../providers/filter_provider.dart';

class DailyFilterPage extends StatefulWidget {
  List<EmployeeModel>? cashiers;
  DailyFilterPage({Key? key, this.cashiers}) : super(key: key);

  @override
  State<DailyFilterPage> createState() => _DailyFilterPageState();
}

class _DailyFilterPageState extends State<DailyFilterPage> {
  @override
  Widget build(BuildContext context) {
    FilterProvider fProvider = Provider.of<FilterProvider>(context);
    List<FilterModel>? trans = fProvider.dataTable;

    DTS dts = DTS(transDTS: trans, kasir: widget.cashiers);

    return Expanded(
      child: ListView(
        children: [
          PaginatedDataTable(
              header: const Text('Transaksi Harian'),
              rowsPerPage: 10,
              columns: [
                DataColumn(label: Text('Tanggal')),
                DataColumn(label: Text('Kasir')),
                DataColumn(label: Text('Total Barang')),
                DataColumn(label: Text('Total Global')),
              ],
              source: dts),
        ],
      ),
    );
  }
}

class DTS extends DataTableSource {
  List<FilterModel>? transDTS;
  List<EmployeeModel>? kasir;

  DTS({this.transDTS, this.kasir});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text('${transDTS![index].column1}')),
      DataCell(Text(kasir!
          .where((element) => element.id == transDTS![index].column2)
          .map((e) => e.name)
          .toString())),
      DataCell(Text('${transDTS![index].column3}')),
      DataCell(Text('${transDTS![index].column4}')),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => transDTS!.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
