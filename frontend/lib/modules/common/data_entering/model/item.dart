import 'package:finance/modules/common/data_entering/model/category_enum.dart';

class Item {
  String? id;
  String? transactionName;
  num? amount;
  String? category;
  String? date;

  Item({this.id, this.transactionName, this.amount, this.category, this.date});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionName = json['transactionName'];
    amount = json['amount'];
    category = json['category'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id; 
    data['transactionName'] = this.transactionName;
    data['amount'] = this.amount;
    data['category'] = this.category;
    data['date'] = this.date;
    return data;
  }

  CategoryEnum getCategoryEnum() {
    return CategoryEnum.values.firstWhere(
      (categoryEnum) => categoryEnum.name == category,
      orElse: () => CategoryEnum.other,
    );
  }
}
