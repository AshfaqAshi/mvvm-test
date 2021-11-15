import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_test/util/constants.dart';
import 'package:technical_test/util/helper.dart';
import 'package:technical_test/util/screens.dart';
import 'package:technical_test/view/widgets/all_widgets.dart';
import 'package:technical_test/view/widgets/provider_consumer.dart';
import 'package:technical_test/view/widgets/provider_consumer_2.dart';
import 'package:technical_test/view_model/auth_view_model.dart';
import 'package:technical_test/view_model/medicine_list_view_model.dart';
import 'package:technical_test/view_model/medicine_view_model.dart';
import 'package:technical_test/view_model/user_view_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void initState(){
    super.initState();
    context.read<MedicineListViewModel>().getMedicinesList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(Constants.SCAFFOLD_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProviderConsumer<UserViewModel>(
              builder: (context,provider,child){
                if(provider.status==UserStatus.loggingOut ||
                    provider.status==UserStatus.loggedOut){
                  return Center(
                    child: LoadingWidget(message: 'Logging Out',),
                  );
                }
                return Row(
                  children: [
                    Text('${Helper.greeting()} ${provider.loggedInUserResult!.value!.name}'),
                    HorizontalSpace(),
                    TextButton(
                      onPressed: (){
                       provider.logoutUser();
                      },
                      child: Text('Logout'),
                    )
                  ],
                );
              },

              listener: (context, provider){
                if(provider.status==UserStatus.loggedOut){
                  //user logged out
                  //reset auth process
                  context.read<AuthViewModel>().resetAuthProcess();
                  Helper.navigate(context, Screens.LOGIN,pushReplace: true);
                }
              },
            ),

            Text('Medicines',style: Theme.of(context).textTheme.headline5,),
            ProviderConsumer<MedicineListViewModel>(
              builder: (context,provider,child){
                if(provider.medicinesResult==null){
                  //loading
                  return Center(
                    child: LoadingWidget(
                      message: 'Fetching Medicine Data',
                    ),
                  );
                }
                if(provider.medicinesResult!.success){
                  if(provider.medicinesResult!.value!.isEmpty){
                    return Center(
                      child: Text('No data retrieved'),
                    );
                  }else{
                    return Expanded(
                      child: ListView.builder(
                        itemCount:provider.medicinesResult!.value!.length,
                        itemBuilder: (context,index){
                          MedicineViewModel medicine = provider.medicinesResult!.value![index];
                          return MedicineItem(medicine);
                        },
                      ),
                    );
                  }
                }else{
                  return Center(
                    child: Text(provider.medicinesResult!.userMessage!),
                  );
                }
              },

              listener: (context, provider){

              },
            )
          ],
        ),
      ),
    );
  }
}
