import '../helpers/user_info.dart';

class LoginService {
  Future<bool> login(String username, String password) async {
    bool isLogin = false;
    if (username == 'user' && password == 'user') {
      await UserInfo().setToken("user");
      await UserInfo().setUserID("1");
      await UserInfo().setUsername("user");
      isLogin = true;
    }
    return isLogin;
  }
}
