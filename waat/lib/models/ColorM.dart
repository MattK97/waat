class ColorM {
  int colorID;
  String colorHex;


  ColorM({this.colorID, this.colorHex});

  ColorM.fromJson(Map<String, dynamic> json) {
    colorID = json['color_id'];
    colorHex = json['color_hex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color_id'] = this.colorID;
    data['color_hex'] = this.colorHex;
    return data;
  }
}