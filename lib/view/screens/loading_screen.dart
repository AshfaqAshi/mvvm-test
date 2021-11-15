import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_test/util/helper.dart';
import 'package:technical_test/util/screens.dart';
import 'package:technical_test/view/widgets/all_widgets.dart';
import 'package:technical_test/view/widgets/provider_consumer.dart';
import 'package:technical_test/view_model/user_view_model.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  void initState(){
    super.initState();
    context.read<UserViewModel>().getLoggedInUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProviderConsumer<UserViewModel>(
        builder: (context,provider,child){


          return Center(
            child: LoadingWidget(
              message: 'Authenticating',
            ),
          );
        },
        listener: (context, provider){
          if(provider.loggedInUserResult!=null){
            if(provider.loggedInUserResult!.success){
              //user logged in navigate to home screen
              Helper.navigate(context, Screens.HOME,pushReplace: true);
            }else{
              //user not logged in. Navigate to login screen
              Helper.navigate(context, Screens.LOGIN,pushReplace: true);
            }
          }
        },
      ),
    );
  }
}
