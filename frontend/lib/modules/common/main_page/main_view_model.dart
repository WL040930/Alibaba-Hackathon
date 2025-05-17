import 'dart:convert';

import 'package:finance/core/view_state/view_state_model.dart';
import 'package:finance/modules/common/data_entering/model/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainViewModel extends ViewStateModel {
  List<Item> _items = [];

  List<Item> get items => _items;

  Future<void> init() async {
    await loadItems();
    notifyListeners();
  }

  void addItem(List<Item> itemsToAdd) {
    final existingIds = _items.map((item) => item.id).toSet();
    final newItems =
        itemsToAdd.where((item) => !existingIds.contains(item.id)).toList();

    if (newItems.isNotEmpty) {
      _items.addAll(newItems);
      saveItems();
      notifyListeners();
    }
  }

  void editItem(Item editedItem) {
    final index = _items.indexWhere(
      (item) =>
          item.transactionName == editedItem.transactionName &&
          item.date == editedItem.date,
    );
    if (index != -1) {
      _items[index] = editedItem;
      saveItems();
      notifyListeners();
    }
  }

  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_items.map((item) => item.toJson()).toList());
    await prefs.setString('items', jsonString);
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('items');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _items = jsonList.map((json) => Item.fromJson(json)).toList();
    }
  }
}
