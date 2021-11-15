import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderConsumer<T extends ChangeNotifier> extends StatefulWidget{
  final Widget Function(BuildContext,T,Widget?) builder;
  final Function(BuildContext,T) listener;
  ProviderConsumer({required this.builder, required this.listener});

  _ConsumerState<T> createState()=>_ConsumerState<T>();
}

class _ConsumerState<T extends ChangeNotifier> extends State<ProviderConsumer<T>>{

  late T provider;

  void initState(){
    super.initState();
    provider = Provider.of<T>(context,listen: false);
    provider.addListener(_listener);
  }

  void dispose(){
    //dispose the listener
    provider.removeListener(_listener);
    super.dispose();
  }

  _listener(){
    //call the listener callback
    widget.listener(context,provider);
  }
  Widget build(BuildContext context){
    return Consumer<T>(
      builder: (context, T t, child){
         return widget.builder(context,t,child);
      },
    );
  }
}