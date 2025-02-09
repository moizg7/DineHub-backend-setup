class Sellers {
  String? sellerUID;
  String? sellerName;
  String? sellerEmail;
  String? phone;
  String? address;
  String? photoUrl;

  Sellers({
    this.sellerUID,
    this.sellerName,
    this.sellerEmail,
    this.phone,
    this.address,
    this.photoUrl,
  });

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerUID = json['_id'];
    sellerName = json['name'];
    sellerEmail = json['email'];
    phone = json['phone'];
    address = json['address'];
    photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sellerUID;
    data['name'] = sellerName;
    data['email'] = sellerEmail;
    data['phone'] = phone;
    data['address'] = address;
    data['photoUrl'] = photoUrl;
    return data;
  }
}
