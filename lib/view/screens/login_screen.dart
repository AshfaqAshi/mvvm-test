import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_test/model/auth_process.dart';
import 'package:technical_test/model/user.dart';
import 'package:technical_test/util/constants.dart';
import 'package:technical_test/util/helper.dart';
import 'package:technical_test/util/screens.dart';
import 'package:technical_test/view/widgets/all_widgets.dart';
import 'package:technical_test/view/widgets/provider_consumer.dart';
import 'package:technical_test/view_model/auth_view_model.dart';

class LoginScreen extends StatefulWidget{
_ScreenState createState()=>_ScreenState();
}

class _ScreenState extends State<LoginScreen>{

  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtName = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void dispose(){
    txtPhone.dispose();
    txtName.dispose();
    super.dispose();
  }
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Login'),),
      body: Padding(
        padding: const EdgeInsets.all(Constants.SCAFFOLD_PADDING),
        child: ProviderConsumer<AuthViewModel>(
          builder: (context, provider,child){
            return phoneNoBox(provider);
          },
          listener: (context, provider){
            if(provider.authProcessResult!=null){
              //loading
              if(provider.authProcessResult!.success){
                if(provider.authProcessResult!.value!.status==AuthStatus.codeSent){
                  Helper.navigate(context, Screens.CODE_SCREEN,pushReplace: true);
                }
              }else{
                Helper.showSnackBar(context, provider.authProcessResult!.userMessage!,error: true);
              }
            }
          },
        ),
      ),
    );
  }

  Widget phoneNoBox(AuthViewModel provider){
    return  Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomFormField(
              txtController: txtName,
              labelText: 'Name',
              onValidate: (value){
                if(value!=null){
                  if(value.isEmpty){
                    return 'Please provide your name';
                  }
                }
                return null;
              },
            ),
            VerticalSpace(),
            CustomFormField(
              txtController: txtPhone,
              labelText: 'Phone',
              inputType: TextInputType.phone,
              onValidate: (value){
                if(value!=null){
                  if(value.isEmpty){
                    return 'Please provide your phone number';
                  }else{
                    //make sure it includes ccountry code
                    if(!value.startsWith('+')){
                      return 'Please provide your country code, eg: +91';
                    }
                  }
                }
                return null;
              },
            ),

            loginButton(provider)
          ],
        ),
      );
  }

  Widget loginButton(AuthViewModel provider){
    if(provider.authProcessResult==null|| provider.authProcessResult?.success==false){
      //show login button
      return ElevatedButton(
          onPressed: (){
            if(_formKey.currentState!.validate()){
              //create user object
              User user = User(name: txtName.text, phone: txtPhone.text,);
              provider.setUserToSignIn(user);
              provider.verifyPhone(user);
            }
          },
          child: Text('Verify Phone'));
    }else{
      //verification process has started
      String message='Sending Verification code';
      return Center(child: LoadingWidget(message: message,),);
    }
  }
}