import 'package:flutter/material.dart';

class User{
  String userId;
  String password;
  String email;
  String name;
  String role;

  User(this.userId, this.password, this.email, this.name, this.role);
}

class UserProvider with ChangeNotifier{
  late User _user;

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}

class SiteIncharge extends User{

  SiteIncharge(super.userId, super.password, super.email, super.name, super.role);

}

class Supervisor extends User{

  List<User> siteIncharges;
  Supervisor(super.userId, super.password, super.email, super.name, super.role, this.siteIncharges);

}