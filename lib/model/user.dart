import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  Map<String, dynamic>? _user;

  Map<String, dynamic>? get user => _user;

  void setUser(Map<String, dynamic>? userData) {
    _user = userData;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
