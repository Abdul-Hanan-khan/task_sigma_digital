class SeatingPlanModel {
  List<Rows>? rows;

  SeatingPlanModel({this.rows});

  SeatingPlanModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rows {
  int? id;
  String? seatingPlan;
  String? category;
  int? price;
  String? status;
  String? row;
  String ? seatNumber;

  Rows(
      {this.id,
        this.seatingPlan,
        this.category,
        this.price,
        this.status,
        this.row,
      this.seatNumber});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    seatingPlan = json['seating_plan'];
    category = json['category'];
    price = json['price'];
    status = json['status'];
    row = json['row'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seating_plan'] = this.seatingPlan;
    data['category'] = this.category;
    data['price'] = this.price;
    data['status'] = this.status;
    data['row'] = this.row;
    return data;
  }
}
