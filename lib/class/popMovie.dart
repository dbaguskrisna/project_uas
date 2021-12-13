class HotelList {
  int id;
  String name;
  String description;
  String price;
  String image;
  final List review;
  final List user;

  HotelList(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.image,
      this.review,
      this.user});
  factory HotelList.fromJson(Map<String, dynamic> json) {
    return HotelList(
        id: json['idhotel'],
        name: json['name'],
        description: json['description'],
        price: json['price'],
        image: json['image'],
        review: json['review'],
        user: json['user']);
  }
}
