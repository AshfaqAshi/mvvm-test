import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:technical_test/model/auth_process.dart';
import 'package:technical_test/model/result.dart';
import 'package:technical_test/model/user.dart';
import 'package:technical_test/services/auth_service.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([AuthService])
void main(){
  group('Auth Service Test', (){
    var authService = MockAuthService();
    User? dummyUser = User(name: 'Dummy', phone: '');

    when( authService.verifyPhone(dummyUser,
      onVerificationCompleted: anyNamed('onVerificationCompleted'),
      onVerificationFailed: anyNamed('onVerificationFailed'),
      onCodeSent: anyNamed('onCodeSent'),
      onCodeAutoRetrievalTimeout: anyNamed('onCodeAutoRetrievalTimeout'),
    ))
        .thenAnswer((realInvocation) {
      var onVerificationCompleted = realInvocation.namedArguments[Symbol('onVerificationCompleted')] as Function(Auth.PhoneAuthCredential)?;
      final onVerificationFailed = realInvocation.namedArguments[Symbol('onVerificationFailed')] as Function(Auth.FirebaseAuthException)?;
      final onCodeSent = realInvocation.namedArguments[Symbol('onCodeSent')] as Function(String)?;
      final onCodeAutoRetrievalTimeout = realInvocation.namedArguments[Symbol('onCodeAutoRetrievalTimeout')] as Function(String)?;

      //call onVerificationCompleted
          if(onVerificationCompleted!=null)
      onVerificationCompleted(Auth.PhoneAuthProvider.credential(verificationId: '', smsCode: ''));
      //call onVerificationFailed
          if(onVerificationFailed!=null)
      onVerificationFailed(Auth.FirebaseAuthException(code: 'Test exception'));
      //call onCodeSent
          if(onCodeSent!=null)
      onCodeSent('');
      //call onCodeAutoRetrievalTimeout
          if(onCodeAutoRetrievalTimeout!=null)
      onCodeAutoRetrievalTimeout('');

      return Result(value: AuthProcess());
    });

    test('Ensure onVerificationCompleted callback is triggered',()async{

      bool callBackTriggered=false;


      authService.verifyPhone(dummyUser,
        onVerificationCompleted: (_){
        callBackTriggered = true;
        }
      );

      expect(callBackTriggered,true);
    });

    test('Ensure onVerificationFailed callback is triggered',()async{

      bool callBackTriggered=false;


      authService.verifyPhone(dummyUser,
          onVerificationFailed: (_){
            callBackTriggered = true;
          }
      );

      expect(callBackTriggered,true);
    });

    test('Ensure onCodeSent callback is triggered',()async{

      bool callBackTriggered=false;


      authService.verifyPhone(dummyUser,
          onCodeSent: (_){
            callBackTriggered = true;
          }
      );

      expect(callBackTriggered,true);
    });

    test('Ensure onCodeAutoRetrievalTimeout callback is triggered',()async{

      bool callBackTriggered=false;


      authService.verifyPhone(dummyUser,
          onCodeAutoRetrievalTimeout: (_){
            callBackTriggered = true;
          }
      );

      expect(callBackTriggered,true);
    });
  });
}