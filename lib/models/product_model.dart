class ProductModel {
  int? id;
  String? nama;
  String? kode;
  int? harga_jual;
  int? harga_modal;
  String? deskripsi;
  String? imageUrl;
  int? stok;
  int? stok_awal;
  DateTime? stok_tanggal;
  List<dynamic>? tag;
  Map<String, dynamic>? supplier;

  ProductModel({
    this.id,
    this.nama,
    this.kode,
    this.harga_jual,
    this.harga_modal,
    this.deskripsi,
    this.imageUrl,
    this.stok,
    this.stok_awal,
    this.stok_tanggal,
    this.tag,
    this.supplier,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    kode = json['kode'];
    harga_jual = json['harga_jual'];
    harga_modal = json['harga_modal'];
    deskripsi = json['deskripsi'];
    imageUrl = json['imageUrl'];
    stok = json['sisa_stok'];
    stok_awal = json['stok_awal'];
    stok_tanggal = json['stok_tanggal'].toDate();
    tag = json['tag'];
    supplier = json['supplier'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kode': kode,
      'harga_jual': harga_jual,
      'harga_modal': harga_modal,
      'deskripsi': deskripsi,
      'imageUrl': imageUrl,
      'sisa_stok': stok,
      'stok_awal': stok_awal,
      'stok_tanggal': stok_tanggal.toString(),
      'tag': tag,
      'supplier': supplier,
    };
  }
}

List<ProductModel> mockProduct = [
  ProductModel(
    nama: 'Wortel Segar',
    kode: 'WS-001',
    harga_jual: 14000,
    harga_modal: 12000,
    deskripsi:
        'Wortel merupakan sayuran berwarna oranye yang banyak digemari, karena rasanya yang enak dan manfaat wortel yang melimpah. Wortel bisa dimakan mentah, direbus, atau digoreng, dibuat jus, atau campuran puding.',
    imageUrl:
        'https://ik.imagekit.io/10tn5i0v1n/article/f7868cd4c1339025ba7656df2175e9d4.jpeg',
    stok: 100,
    stok_tanggal: DateTime.now(),
  ),
  ProductModel(
    nama: 'Cabe Segar',
    kode: 'CS-001',
    harga_jual: 35000,
    harga_modal: 30000,
    deskripsi:
        'Cabai adalah buah dan tumbuhan anggota genus Capsicum. Buahnya dapat digolongkan sebagai sayuran maupun bumbu, tergantung bagaimana pemanfaatannya. Sebagai bumbu, buah cabai yang pedas sangat populer di Asia Tenggara sebagai penguat rasa makanan.',
    imageUrl: 'https://kbu-cdn.com/bc/wp-content/uploads/cabe-cabai.jpg',
    stok: 40,
    stok_tanggal: DateTime.now(),
  ),
  ProductModel(
    nama: 'Beras Belida Edisi Spesial',
    kode: 'BB-001',
    harga_jual: 50000,
    harga_modal: 45000,
    deskripsi:
        'Beras adalah bagian bulir padi (gabah) yang telah dipisah dari sekam. Sekam (Jawa merang) secara anatomi disebut palea (bagian yang ditutupi) dan lemma (bagian yang menutupi).',
    imageUrl:
        'https://media.suara.com/pictures/653x366/2014/10/24/o_1950dm43f1fr910u51bme1jkk9ibq.jpg',
    stok: 80,
    stok_tanggal: DateTime.now(),
  ),
  ProductModel(
    nama: 'Roti Lapis',
    kode: 'RL-001',
    harga_jual: 4000,
    harga_modal: 3000,
    deskripsi:
        'BRoti lapis atau roti isi (bahasa Inggris: sandwich), adalah makanan yang biasanya terdiri dari sayuran, keju atau daging yang diiris',
    imageUrl:
        'https://statik.tempo.co/data/2019/10/06/id_878322/878322_720.jpg',
    stok: 45,
    stok_tanggal: DateTime.now(),
  ),
  ProductModel(
    nama: 'Shampoo Unilever',
    kode: 'SU-001',
    harga_jual: 4000,
    harga_modal: 3500,
    deskripsi:
        'Sampo (bahasa Inggris: shampoo) adalah sejenis cairan, seperti sabun, yang berfungsi untuk meningkatkan tegangan permukaan kulit (umumnya kulit kepala) sehingga dapat meluruhkan kotoran (membersihkan).',
    imageUrl:
        'https://www.paulaschoice-eu.com/on/demandware.static/-/Sites-paulaschoice-catalog/default/dw4fa91958/images/5000-lifestyle.jpg',
    stok: 55,
    stok_tanggal: DateTime.now(),
  ),
];
