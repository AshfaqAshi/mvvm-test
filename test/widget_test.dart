// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:technical_test/main.dart';
import 'package:technical_test/view_model/auth_view_model.dart';
import 'package:technical_test/view_model/medicine_list_view_model.dart';
import 'package:technical_test/view_model/user_view_model.dart';

void main() {
  testWidgets('To check ProviderConsumer Listener gets removed at dispose', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserViewModel()),
        ChangeNotifierProxyProvider<UserViewModel,AuthViewModel>(
            create: (context)=>AuthViewModel(
                Provider.of<UserViewModel>(context,listen: false)
            ),
            update: (BuildContext context,UserViewModel userViewModel,AuthViewModel? authViewModel){
              authViewModel!.userViewModel=userViewModel;
              return authViewModel;
            }),
        ChangeNotifierProvider(create: (_)=>MedicineListViewModel())
      ],
      child: MyApp(),
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
