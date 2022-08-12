import 'package:flutter/material.dart';
import 'package:gerai_lam_app/providers/filter_provider.dart';
import 'package:provider/provider.dart';

import '../../models/filter_model.dart';

class TransactionFilterPage extends StatelessWidget {
  const TransactionFilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FilterProvider fProvider = Provider.of<FilterProvider>(context);
    List<FilterModel>? trans = fProvider.dataTable;
    DTS dts = DTS(transDTS: trans);

    return Expanded(
      child: ListView(
        children: [
          PaginatedDataTable(
              header: const Text('Transaksi per Struk'),
              rowsPerPage: 10,
              columns: [
                DataColumn(label: Text('Tanggal')),
                DataColumn(label: Text('Total')),
                DataColumn(label: Text('Total Barang')),
                DataColumn(label: Text('Bayar')),
              ],
              source: dts),
        ],
      ),
    );
  }
}

class DTS extends DataTableSource {
  List<FilterModel>? transDTS;
  DTS({this.transDTS});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text('${transDTS![index].column1}')),
      DataCell(Text('${transDTS![index].column2}')),
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
