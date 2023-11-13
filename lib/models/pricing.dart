
class Pricing {
  String? id;
  String? dealer_id;
  String? name;
  String? from;
  String? to;
  String? indent_price;
  String? nozel_price;
  String? created_at;
  String? created_by;
  String? update_time;

  Pricing({this.id, this.dealer_id, this.name, this.from, this.to,
    this.indent_price, this.nozel_price, this.created_at, this.created_by,
    this.update_time,
  });

  Pricing.fromJson(Map<String, dynamic> json) {
    id= json['id'];
    dealer_id= json['dealer_id'];
    name= json['name'];
    from= json['from'];
    to= json['to'];
    indent_price=json['indent_price'];
    nozel_price=json['nozel_price'];
    created_at=json['created_at'];
    created_by=json['created_by'];
    update_time=json['update_time'];
  }



}