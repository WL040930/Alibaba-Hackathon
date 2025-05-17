import 'dart:convert';
import 'dart:io';

import 'package:finance/modules/common/data_entering/model/item.dart';

class DataEnteringService {
  static Future<List<Item>> getItems() async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));

    return [
      Item(
        id: '1',
        transactionName: "Nasi Lemak",
        amount: 12.21,
        category: "Food",
        date: "2025-05-17",
      ),
      Item(
        id: '2',
        transactionName: "Chicken Rice",
        amount: 8.50,
        category: "Food",
        date: "2025-05-16",
      ),
      Item(
        id: '3',
        transactionName: "Kopi O",
        amount: 1.80,
        category: "Beverage",
        date: "2025-05-16",
      ),
      Item(
        id: '4',
        transactionName: "MRT Ride",
        amount: 2.10,
        category: "Transport",
        date: "2025-05-15",
      ),
      Item(
        id: '5',
        transactionName: "Roti Canai",
        amount: 3.00,
        category: "Food",
        date: "2025-05-14",
      ),
    ];
  }

  static Future uploadImage(File image) async {
    final bytes = await image.readAsBytes();
    final base64String = base64Encode(bytes);

    print(base64String);
    print("Image bytes: $bytes");
  }
}
