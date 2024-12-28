import 'package:immuglobin/model/user.dart';

class Session {
  static User? user;

  static void setUser(User newUser) {
    user = newUser;
  }

  static User? getUser() {
    return user;
  }
}
