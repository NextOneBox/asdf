

import 'package:mines_mines/mines.dart';

import 'addfunds.dart';
import 'login.dart';
import 'navbar.dart';



class AuthService {
  handleAuthState()  {
    if (login!.isNotEmpty) {
      return Bottomapp();
    } else {
      return RegisterWithPhoneNumber();
    }
   
  }
}
