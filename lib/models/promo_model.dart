class PromoModel {
  int? id;
  String? imageUrl;
  String? title;
  String? description;

  PromoModel({this.id, this.imageUrl, this.title, this.description});
}

List<PromoModel> mockPromo = [
  PromoModel(
    id: 1,
    imageUrl:
        'https://img.freepik.com/free-vector/3d-elegant-promotion-banner-promote-your-business-offer_127609-95.jpg',
    title: 'Promo 50% Bulan ini',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque fringilla sapien. Quisque vestibulum, diam eget tincidunt elementum, enim risus pretium orci, nec imperdiet orci nunc sed quam. Donec volutpat diam sed libero fermentum, sed imperdiet risus faucibus. Sed nunc metus, pellentesque et libero id, sodales consectetur lectus.',
  ),
  PromoModel(
    id: 2,
    imageUrl:
        'https://png.pngtree.com/png-clipart/20200701/original/pngtree-sale-promotion-banner-design-png-image_5383284.jpg',
    title: 'Promo 70% Besar-besaran',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque fringilla sapien. Quisque vestibulum, diam eget tincidunt elementum, enim risus pretium orci, nec imperdiet orci nunc sed quam. Donec volutpat diam sed libero fermentum, sed imperdiet risus faucibus. Sed nunc metus, pellentesque et libero id, sodales consectetur lectus.',
  ),
  PromoModel(
    id: 3,
    imageUrl:
        'https://image.shutterstock.com/image-vector/50-percent-off-discount-sticker-260nw-1653559666.jpg',
    title: 'Mega Big Sale',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque pellentesque fringilla sapien. Quisque vestibulum, diam eget tincidunt elementum, enim risus pretium orci, nec imperdiet orci nunc sed quam. Donec volutpat diam sed libero fermentum, sed imperdiet risus faucibus. Sed nunc metus, pellentesque et libero id, sodales consectetur lectus.',
  ),
];
