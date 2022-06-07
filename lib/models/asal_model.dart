class AsalModel {
  String? alamat;
  String? kecamatan;
  String? kelurahan;
  String? kota;
  String? provinsi;

  AsalModel(
      {this.alamat, this.kecamatan, this.kelurahan, this.kota, this.provinsi});

  AsalModel.fromJson(Map<String, dynamic> json) {
    alamat = json['alamat'];
    kecamatan = json['kecamatan'];
    kelurahan = json['kelurahan'];
    kota = json['kota'];
    provinsi = json['provinsi'];
  }

  Map<String, dynamic> toJson() {
    return {
      'alamat': alamat,
      'kecamatan': kecamatan,
      'kelurahan': kelurahan,
      'kota': kota,
      'provinsi': provinsi,
    };
  }
}
