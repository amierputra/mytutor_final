class Users {
  String? id;
  String? useremail;
  String? username;
  String? phone;
  String? address;
  String? datereg;
  String? cart;

  Users(
      {this.id,
      this.useremail,
      this.username,
      this.phone,
      this.address,
      this.datereg,
      this.cart});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    useremail = json['email'];
    username = json['name'];
    phone = json['phone'];
    address = json['address'];
    datereg = json['datereg'];
    cart = json["cart"].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = useremail;
    data['name'] = username;
    data['phone'] = phone;
    data['address'] = address;
    data['datereg'] = datereg;
    data['cart'] = cart.toString();
    return data;
  }
}
