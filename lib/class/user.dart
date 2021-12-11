class User {
  int iduser;
  String email;
  String password;
  String fullname;
  String date;

  User({this.iduser, this.email, this.password, this.fullname, this.date});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        iduser: json['iduser'],
        email: json['email'],
        password: json['password'],
        fullname: json['fullname'],
        date: json['birth_date']);
  }
}
