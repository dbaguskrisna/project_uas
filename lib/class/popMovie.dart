class PopMovie {
  int id;
  String name;
  String description;
  String price;
  String image;

  PopMovie({this.id, this.name, this.description, this.price, this.image});
  factory PopMovie.fromJson(Map<String, dynamic> json) {
    return PopMovie(
        id: json['idhotel'],
        name: json['name'],
        description: json['overview'],
        price: json['price'],
        image: json['image']);
  }
}
