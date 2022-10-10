class ItemRecapModel{
    int? capital;
    int? price;
    String? idProduk;
    String? idSupplier;
    int? qty;
    int? nett;
    int? total;

    ItemRecapModel({
        this.capital, 
        this.price, 
        this.idProduk, 
        this.idSupplier, 
        this.qty, 
        this.nett, 
        this.total
    });

    ItemRecapModel.fromJson(Map<String, dynamic> json){
        capital = json['harga_modal']; 
        price = json['harga_jual']; 
        idProduk = json['id_produk']; 
        idSupplier = json['id_supplier']; 
        qty = json['jumlah']; 
        nett = json['nett']; 
        total = json['total'];
    }

    Map<String, dynamic> toJson(){
        return {
            'harga_jual' : capital,
            'harga_modal' : price,
            'id_produk' : idProduk,
            'id_supplier' : idSupplier,
            'jumlah' : qty,
            'nett' : nett,
            'total' : total,
        };
    }
}