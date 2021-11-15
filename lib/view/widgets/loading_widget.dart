import 'package:flutter/material.dart';
import 'package:technical_test/util/constants.dart';
import 'package:technical_test/view/widgets/all_widgets.dart';
class LoadingWidget extends StatelessWidget {

  final String? message;

  LoadingWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Constants.CONTAINER_MARGIN),
      padding: EdgeInsets.all(Constants.CONTAINER_PADDING),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.CONTAINER_BORDER_RADIUS),
        color: Theme.of(context).primaryColorLight
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          if(message!=null)
          VerticalSpace(),
          if(message!=null)
            Text(message!)
        ],
      ),
    );
  }
}
