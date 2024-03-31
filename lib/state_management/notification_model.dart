import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class NotificationModel extends ChangeNotifier {

  bool _hasNotification = false;

  bool get hasNotification => _hasNotification;

  void setNotification(val){
    _hasNotification = val;
    notifyListeners();
  }
}