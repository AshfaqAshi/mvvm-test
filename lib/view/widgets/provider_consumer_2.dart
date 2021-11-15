import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderConsumer2<T extends ChangeNotifier, T2 extends ChangeNotifier> extends StatefulWidget{
  final Widget Function(BuildContext,T,T2,Widget?) builder;
  final Function(BuildContext,T, T2) listener;
  ProviderConsumer2({required this.builder, required this.listener});

  _ConsumerState<T,T2> createState()=>_ConsumerState<T,T2>();
}

class _ConsumerState<T extends ChangeNotifier, T2 extends ChangeNotifier> extends State<ProviderConsumer2<T, T2>>{

  late T provider1;
  late T2 provider2;

  void initState(){
    super.initState();
    provider1 = Provider.of<T>(context,listen: false);
    provider2 = Provider.of<T2>(context,listen: false);
    provider1.addListener(_listener);
    provider2.addListener(_listener);
  }

  void dispose(){
    provider1.removeListener(_listener);
    provider2.removeListener(_listener);
    super.dispose();
  }

  _listener(){
    //notify the listener
    widget.listener(context,provider1,provider2);
  }

  Widget build(BuildContext context){
    return Consumer2<T,T2>(
      builder: (context, t, t2, child){
        return widget.builder(context,t,t2,child);

      },
    );
  }
}