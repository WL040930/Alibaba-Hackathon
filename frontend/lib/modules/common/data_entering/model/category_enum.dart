import 'package:flutter/material.dart';

enum CategoryEnum {
  food('Food', Icons.fastfood),
  transport('Transport', Icons.directions_car),
  shopping('Shopping', Icons.shopping_bag),
  entertainment('Entertainment', Icons.movie),
  utilities('Utilities', Icons.lightbulb),
  health('Health', Icons.local_hospital),
  education('Education', Icons.school),
  travel('Travel', Icons.flight),
  bills('Bills', Icons.receipt_long),
  groceries('Groceries', Icons.shopping_cart),
  dining('Dining Out', Icons.restaurant),
  other('Other', Icons.category);

  final String name;
  final IconData icon;

  const CategoryEnum(this.name, this.icon);
}
