import 'package:hive/hive.dart';
import 'package:technical_test/model/result.dart';
import 'package:technical_test/model/user.dart';
class LocalDBService{

  static LocalDBService? _instance;

  LocalDBService._();

  static LocalDBService get instance{
    if(_instance==null){
      _instance = LocalDBService._();
    }
    return _instance!;
  }

  static const String LOGGED_IN_USER_KEY='logged_in_user';

   Box<User>? _userBox;

  Future<Box<User>> _getUserBox()async{
    if(_userBox==null){
      _userBox = await Hive.openBox<User>('user');
    }
    return _userBox!;
  }

  Future<Result<User>> getLoggedInUser()async{
      await _getUserBox();
      User? user = _userBox!.get(LOGGED_IN_USER_KEY);
      if(user==null){
        return Result(userMessage: 'User not logged in' );
      }else{
        return Result(value: user);
      }
  }

  Future<Result<User>> saveLoggedInUser(User user)async{
    await _getUserBox();
    await _userBox!.put(LOGGED_IN_USER_KEY, user);
      return Result(value: user);

  }

  Future<Result<bool>> logoutUser()async{
    await _getUserBox();
    await _userBox!.delete(LOGGED_IN_USER_KEY);
    return Result(value: true);

  }
}