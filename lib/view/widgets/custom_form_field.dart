import 'package:flutter/material.dart';
import 'package:technical_test/util/constants.dart';

class CustomFormField extends StatelessWidget{
  TextEditingController? txtController;
  String? helperText;
  String? labelText;
  String? prefixText;
  bool? multiline;
  TextInputType? inputType;
  Function(String?)? onValidate;
  Function(String?)? onChange;

  CustomFormField({this.txtController, this.onValidate,this.onChange,this.helperText,this.labelText,this.prefixText,
    this.multiline=false,this.inputType});
  Widget build(BuildContext context){
    return TextFormField(
      controller: txtController,
      onChanged: onChange!=null?onChange:null,
      validator: (value)=>onValidate!(value),
      maxLines: multiline!?null:1,
      keyboardType: inputType,
      decoration: InputDecoration(
          labelText: labelText,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          filled: true,
          prefixText: prefixText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(Constants.TEXT_FIELD_BORDER_RADIUS),borderSide: BorderSide(
              width: 1
          )),
          contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 10)
      ),
    );
  }
}