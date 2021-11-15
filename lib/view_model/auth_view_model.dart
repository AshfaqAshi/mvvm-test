
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/cupertino.dart';
import 'package:technical_test/model/auth_process.dart';
import 'package:technical_test/model/result.dart';
import 'package:technical_test/model/user.dart';
import 'package:technical_test/services/auth_service.dart';
import 'package:technical_test/view_model/user_view_model.dart';

class AuthViewModel extends ChangeNotifier{

  UserViewModel userViewModel;

  Result<AuthProcess>? _authProcessResult;
  Result<User>? _signedInUserResult;
  ///[userToSignIn]
  ///the user object created from the login screen
  ///containing name, and phone
  late User _userToSignIn;
  late String _verificationId;

  Result<AuthProcess>? get authProcessResult=>_authProcessResult;
  Result<User>? get signedInUserResult=>_signedInUserResult;
  User get userToSignIn=>_userToSignIn;
  String get verificationId=>_verificationId;

  AuthViewModel(this.userViewModel);

  void verifyPhone(User user){
    _authProcessResult = AuthService.instance.verifyPhone(user,
        onVerificationCompleted: (credential){
     // print('code auto retrieved');
          ///Code auto retrieved and phone verified. Sign in user
          if(_authProcessResult!.value!.status==AuthStatus.codeSent){
            print('sending listenres');
            _authProcessResult!.value!.status=AuthStatus.signingIn;
            notifyListeners();
            signInUser(credential: credential);
          }
        },
        onVerificationFailed: (exception){
         _authProcessResult=Result(message:ErrorMessage(exception.message??'',exception.stackTrace),
         userMessage: 'Failed to verify your phone number. Error Code: ${exception.code}');
         notifyListeners();
        },
        onCodeSent: (verificationId){
         ///Code sent to device. Inform user about it
          _authProcessResult!.value!.status=AuthStatus.codeSent;
          _verificationId=verificationId;
          notifyListeners();
        },
        onCodeAutoRetrievalTimeout: (verificationId){
          ///Auto retrieval timed out. First check if verification is
          ///already completed. notify listeners only if verification status
          ///is still [codeSent]
          if(_authProcessResult!.value!.status==AuthStatus.codeSent){
            _authProcessResult!.value!.status=AuthStatus.autoRetrievalTimedOut;
            _verificationId = verificationId;
            notifyListeners();
          }
        });

    notifyListeners();
  }

  void signInUser({Auth.PhoneAuthCredential? credential,
    String? smsCode})async{
    _signedInUserResult=null;
    _authProcessResult!.value!.status=AuthStatus.signingIn;
    notifyListeners();
    _signedInUserResult = await AuthService.instance.signInUser(_userToSignIn,
    verificationId: _verificationId, credential: credential, smsCode: smsCode);
    ///set loggedInUser
    userViewModel.setLoggedInUserResult(_signedInUserResult!);
    if(_signedInUserResult!.success){
      //save user locally
      userViewModel.saveLoggedInUser();
      //change status
      _authProcessResult!.value!.status=AuthStatus.signedIn;
    }
    notifyListeners();

  }

  void setUserToSignIn(User user){
    _userToSignIn = user;
  }

  void markAuthProcessCompleted(){
    _authProcessResult!.value!.status=AuthStatus.completed;
  }

  void resetAuthProcess(){
    _signedInUserResult=null;
    _authProcessResult=null;
  }

  void mockListeners(){
    //for testing purpose
    notifyListeners();
  }
}