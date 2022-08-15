class ItemModel {
  int? id;
  String? idProduk;
  String? barcode;
  String? name;
  String? imageUrl;
  int? capital;
  int? nett;
  int? price;
  int? quantity;
  int? total;
  String? idSupplier;
  String? zone;

  ItemModel({
    this.id,
    this.idProduk,
    this.barcode,
    this.name,
    this.imageUrl,
    this.capital,
    this.nett,
    this.price,
    this.quantity,
    this.total,
    this.idSupplier,
    this.zone,
  });

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idProduk = json['id_produk'];
    barcode = json['barcode'];
    name = json['nama_produk'];
    imageUrl = json['imageUrl'] ?? '';
    capital = json['harga_modal'];
    nett = json['nett'];
    price = json['harga_jual'];
    quantity = json['jumlah'];
    total = json['total'];
    idSupplier = json['id_supplier'];
    zone = json['daerah'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_produk': idProduk,
      'nama_produk': name,
      'barcode': barcode,
      'imageUrl': imageUrl ?? '',
      'harga_modal': capital,
      'nett': nett,
      'harga_jual': price,
      'jumlah': quantity,
      'total': total,
      'id_supplier': idSupplier,
      'daerah': zone,
    };
  }
}
