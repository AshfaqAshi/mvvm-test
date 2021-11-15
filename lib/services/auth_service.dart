import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/foundation.dart';
import 'package:technical_test/model/auth_process.dart';
import 'package:technical_test/model/result.dart';
import 'package:technical_test/model/user.dart';

class AuthService{
  static AuthService? _instance;

  AuthService._();

  static AuthService get instance{
    if(_instance==null){
      _instance = AuthService._();
    }
    return _instance!;
  }


   Result<AuthProcess> verifyPhone(User user,{ required onVerificationCompleted(Auth.PhoneAuthCredential credential),
   required onVerificationFailed(Auth.FirebaseAuthException exception), required onCodeSent(String verificationId),
   required onCodeAutoRetrievalTimeout(String verificationId)}){
    try{
       //first verify phone number
        Auth.FirebaseAuth.instance.verifyPhoneNumber(
           phoneNumber: user.phone,
           verificationCompleted: (authCredential){
             onVerificationCompleted(authCredential);
           },
           verificationFailed: (exception){
             onVerificationFailed(exception);
           },
           codeSent: (verificationId,token){
             onCodeSent(verificationId);
           },
           codeAutoRetrievalTimeout: (verificationId){
             onCodeAutoRetrievalTimeout(verificationId);
           });
        return Result(value: AuthProcess());
    }catch(ex,stack){
      return Result(message: ErrorMessage(ex.toString(),stack));
    }
  }

  Future<Result<User>> signInUser(User user,{String? verificationId,Auth.PhoneAuthCredential? credential,
  String? smsCode})async{
    if(credential!=null){
      //credential provided
      return await _signInWithCredential(user, credential);
    }else{
      //credential not provided.
      Auth.PhoneAuthCredential phoneAuthCredential = Auth.PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: smsCode!);
      return await _signInWithCredential(user, phoneAuthCredential);
    }
  }

  Future<Result<User>> _signInWithCredential(User user,Auth.PhoneAuthCredential credential)async{
    try{
     Auth.UserCredential userCredential = await  Auth.FirebaseAuth.instance.signInWithCredential(credential);
     if(userCredential.user!=null){
       user.uid = userCredential.user!.uid;
       return Result(value: user);
     }else{
       return Result(userMessage: 'Failed to sign in user');
     }
    }catch(ex,stack){
      return Result(message: ErrorMessage(ex.toString(),stack),userMessage: 'Failed to sign in user');
    }
  }




}