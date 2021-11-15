
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:technical_test/main.dart';
import 'package:technical_test/model/result.dart';
import 'package:technical_test/model/user.dart';
import 'package:technical_test/services/localdb_service.dart';
import 'package:technical_test/util/screens.dart';
import 'package:technical_test/view/screens/home_screen.dart';
import 'package:technical_test/view/screens/loading_screen.dart';
import 'package:technical_test/view/screens/login_screen.dart';
import 'package:technical_test/view_model/user_view_model.dart';

import 'local_db_test.mocks.dart';

@GenerateMocks([LocalDBService])
void main(){
  group('Local Storage Test', (){
    var localDb = MockLocalDBService();
    test('Return failed result if no user found locally',()async{
      when(localDb.getLoggedInUser()).thenAnswer((realInvocation)async => Result(userMessage: 'User not logged in'));
      var result = await localDb.getLoggedInUser();
      expect(result.value,null);
    });

    test('Return saved user if user found locally',()async{
      when(localDb.getLoggedInUser()).thenAnswer((realInvocation)async => Result(value: User(name: 'Test',phone: '')));
      var result = await localDb.getLoggedInUser();
      expect(result.value==null,false);
    });

  });
}