import 'package:finance/core/view_state/view_state_model.dart';
import 'package:finance/modules/common/data_entering/model/data_entering_service.dart';
import 'package:finance/modules/common/data_entering/model/item.dart';

class DataAddingViewModel extends ViewStateModel {
  List<Item> newItems = [];

  Future<void> init(String text) async {
    try {
      print("Initializing with text: $text");
      setState(ViewState.busy); // Set loading state
      newItems = await DataEnteringService.getItems();
      setState(ViewState.idle); // Done loading
    } catch (e) {
      setState(ViewState.error); // Error handling
      // Optionally log or handle the error
    }
  }

  void editItem(Item editedItem) {
    final index = newItems.indexWhere((i) => i.id == editedItem.id);
    if (index != -1) {
      newItems[index] = editedItem;
      notifyListeners();
    }
  }
}
