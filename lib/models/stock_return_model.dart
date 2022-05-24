class StockReturnModel {
  int? harga;
  String? kode;
  String? nama;
  int? stok;
  int? total;

  StockReturnModel({this.harga, this.kode, this.nama, this.stok, this.total});

  StockReturnModel.fromJson(Map<String, dynamic> json) {
    harga = json['harga'];
    kode = json['kode'];
    nama = json['nama'];
    stok = json['stok'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    return {
      'harga': harga,
      'kode': kode,
      'nama': nama,
      'stok': stok,
      'total': total,
    };
  }
}

List<StockReturnModel> mockStockReturn = [
  StockReturnModel(
    harga: 2000,
    kode: 'WS-001',
    nama: 'Wortel Segar',
    stok: 4,
    total: 8000,
  ),
];
