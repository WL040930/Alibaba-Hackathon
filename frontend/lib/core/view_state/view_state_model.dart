import 'package:flutter/material.dart';

enum ViewState { idle, busy, empty, error }

class ViewStateModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  bool get isIdle => _state == ViewState.idle;
  bool get isBusy => _state == ViewState.busy;
  bool get isEmpty => _state == ViewState.empty;
  bool get isError => _state == ViewState.error;

  @override
  void dispose() {
    print("ViewStateModel disposed");
    super.dispose();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
