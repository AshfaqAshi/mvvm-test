import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_test/model/auth_process.dart';
import 'package:technical_test/util/constants.dart';
import 'package:technical_test/util/helper.dart';
import 'package:technical_test/util/screens.dart';
import 'package:technical_test/view/widgets/all_widgets.dart';
import 'package:technical_test/view/widgets/provider_consumer.dart';
import 'package:technical_test/view_model/auth_view_model.dart';
class CodeScreen extends StatefulWidget {
  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {

  TextEditingController txtVerificationCode = TextEditingController();

  void dispose(){
    txtVerificationCode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Verification Code'),
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.SCAFFOLD_PADDING),
        child: ProviderConsumer<AuthViewModel>(
          builder: (context, provider,child){
            /*if(provider.authProcessResult!.value!.status==AuthStatus.signingIn){
              return Center(
                child: LoadingWidget(
                  message: 'Signing in',
                ),
              );
            }*/

            return Column(
              children: [
                Text('Enter the verification code'),
                CustomFormField(
                  txtController: txtVerificationCode,
                  onValidate: (value){
                    if(value!=null){
                      if(value.isEmpty){
                        return 'Please provide the verification code';
                      }
                    }
                    return null;
                  },
                ),

                (provider.authProcessResult!.value!.status==AuthStatus.signingIn)?
                    Center(
                      child: LoadingWidget(
                        message: 'Verifying and signing in',
                      ),
                    ):
                ElevatedButton(
                    onPressed:(){
                      provider.signInUser(
                        smsCode:txtVerificationCode.text
                      );
                    },
                    child: Text('Verify'))
              ],
            );
          },
          listener: (context, provider){
            if(provider.signedInUserResult!=null){
              if(provider.signedInUserResult!.success && provider.authProcessResult!.value!.status==AuthStatus.signedIn){
                //user successfully signed in
                Helper.navigate(context, Screens.HOME,pushReplace: true);
                provider.markAuthProcessCompleted();
              }else{
                //an error occurred
                Helper.showSnackBar(context, provider.signedInUserResult!.userMessage!,error: true);
                provider.markAuthProcessCompleted();
              }
            }
            //capture verification errors
            if(!provider.authProcessResult!.success){
              Helper.showSnackBar(context, provider.authProcessResult!.userMessage!,error: true);
            }
          },
        ),
      ),
    );
  }

}
