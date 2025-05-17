import 'dart:io';

import 'package:finance/core/view_state/view_state_model.dart';
import 'package:finance/modules/common/data_entering/model/data_entering_service.dart';
import 'package:finance/modules/common/data_entering/model/item.dart';

class CameraDataViewModel extends ViewStateModel {
  List<Item> newItems = [];

  Future<void> init(File file) async {
    try {
      setState(ViewState.busy);
      notifyListeners();

      newItems = await DataEnteringService.getItems();
      DataEnteringService.uploadImage(file);

      setState(ViewState.idle);
      notifyListeners();
    } catch (e) {
      setState(ViewState.error); // Error handling
      // Optionally log or handle the error
    }
  }
}
