class Menus {
  String? menuId;
  String? sellerUID;
  String? menuTitle;
  String? menuInfo;
  String? thumbnailUrl;
  String? status;

  Menus({
    this.menuId,
    this.sellerUID,
    this.menuTitle,
    this.menuInfo,
    this.thumbnailUrl,
    this.status,
  });

  Menus.fromJson(Map<String, dynamic> json) {
    menuId = json["_id"];
    sellerUID = json["sellerUID"];
    menuTitle = json["menuTitle"];
    menuInfo = json["menuInfo"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
    print("Menus.fromJson: menuId = $menuId"); // Debug print
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["_id"] = menuId;
    data["sellerUID"] = sellerUID;
    data["menuTitle"] = menuTitle;
    data["menuInfo"] = menuInfo;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;
    return data;
  }
}
