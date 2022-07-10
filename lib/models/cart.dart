// ignore_for_file: non_constant_identifier_names

class Cart {
  String? cart_id;
  String? subject_id;
  String? cart_qty;
  String? cart_status;
  String? payment_id;
  String? cart_date;
  String? subject_name;
  String? subject_price;
  String? pricetotal;

  Cart(
      {this.cart_id,
      this.subject_id,
      this.cart_qty,
      this.cart_status,
      this.payment_id,
      this.cart_date,
      this.subject_name,
      this.subject_price,
      this.pricetotal});

  Cart.fromJson(Map<String, dynamic> json) {
    cart_id = json["cart_id"];
    subject_id = json["subject_id"];
    cart_qty = json["cart_qty"];
    cart_status = json["cart_status"];
    payment_id = json["payment_id"];
    cart_date = json["cart_date"];
    subject_name = json["subject_name"];
    subject_price = json["subject_price"];
    pricetotal = json["pricetotal"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cart_id;
    data['subject_id'] = subject_id;
    data['cart_qty'] = cart_qty;
    data['cart_status'] = cart_status;
    data['payment_id'] = payment_id;
    data['cart_date'] = cart_date;
    data['subject_name'] = subject_name;
    data['subject_price'] = subject_price;
    data['pricetotal'] = pricetotal;
    return data;
  }
}