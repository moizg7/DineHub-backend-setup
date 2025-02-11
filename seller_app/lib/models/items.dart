class Items {
  String? itemId;
  String? itemName;
  String? thumbnailUrl;
  String? longDescription;
  double? price;

  Items(
      {this.itemId,
      this.itemName,
      this.thumbnailUrl,
      this.longDescription,
      this.price});

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      itemId: json['_id'],
      itemName: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      longDescription: json['longDescription'],
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': itemId,
      'title': itemName,
      'thumbnailUrl': thumbnailUrl,
      'longDescription': longDescription,
      'price': price,
    };
  }
}
