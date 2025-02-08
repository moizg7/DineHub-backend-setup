class Sellers {
  String? sellerUID;
  String? sellerName;
  String? sellerEmail;
  String? phone;
  String? address;
  String? photoUrl;
  DateTime? createdAt;

  Sellers({
    this.sellerUID,
    this.sellerName,
    this.sellerEmail,
    this.phone,
    this.address,
    this.photoUrl,
    this.createdAt,
  });

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerUID = json['_id'];
    sellerName = json['name'];
    sellerEmail = json['email'];
    phone = json['phone'];
    address = json['address'];
    photoUrl = json['photoUrl'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sellerUID;
    data['name'] = sellerName;
    data['email'] = sellerEmail;
    data['phone'] = phone;
    data['address'] = address;
    data['photoUrl'] = photoUrl;
    data['createdAt'] = createdAt?.toIso8601String();
    return data;
  }
}
