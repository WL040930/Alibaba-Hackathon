import 'package:flutter/material.dart';

class ViewStateModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}

enum ViewState { idle, busy, empty, error }
