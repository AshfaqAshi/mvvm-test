
import 'package:flutter/material.dart';
import 'package:technical_test/model/result.dart';
import 'package:technical_test/model/user.dart';
import 'package:technical_test/services/localdb_service.dart';

class UserViewModel extends ChangeNotifier{

  Result<User>? _loggedInUserResult;
  UserStatus? _status;

  Result<User>? get loggedInUserResult=>_loggedInUserResult;
  UserStatus? get status=>_status;

  void getLoggedInUser()async{
    _loggedInUserResult = await LocalDBService.instance.getLoggedInUser();
    _status=UserStatus.loggedIn;
    notifyListeners();
  }

  void saveLoggedInUser()async{
    await LocalDBService.instance.saveLoggedInUser(_loggedInUserResult!.value!);
    _status = UserStatus.loggedIn;
    notifyListeners();
  }

  void logoutUser()async{
    _status=UserStatus.loggingOut;
    notifyListeners();
    var result = await LocalDBService.instance.logoutUser();
    _loggedInUserResult = null;
    _status = UserStatus.loggedOut;
    notifyListeners();
  }



  void setLoggedInUserResult(Result<User> userResult){
    _loggedInUserResult = userResult;
    if(userResult.success){
      _status = UserStatus.loggedIn;
    }else{
      _status = UserStatus.loginFailed;
    }
    notifyListeners();
  }
}

enum UserStatus{
  loggingOut,
  loggedOut,
  loggedIn,
  loginFailed
}

