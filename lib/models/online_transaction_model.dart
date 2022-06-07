class OnlineTransactionModel {
  String? noTransaksi;
  int? ongkir;
  int? totalBarang;
  int? totalHarga;
  String? status;

  OnlineTransactionModel({
    this.noTransaksi,
    this.ongkir,
    this.totalBarang,
    this.totalHarga,
    this.status,
  });

  OnlineTransactionModel.fromJson(Map<String, dynamic> json) {
    noTransaksi = json['id'];
    ongkir = json['ongkir'];
    totalBarang = json['total_produk'];
    totalHarga = json['total_transaksi'];
    status = json['status'];
  }
}
