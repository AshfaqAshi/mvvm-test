
import 'dart:convert';

import 'package:technical_test/model/result.dart';
import 'package:technical_test/view_model/medicine_view_model.dart';
import 'package:http/http.dart' as http;

class ApiService{

  static ApiService? _instance;

  ApiService._();

  static ApiService get instance{
    if(_instance==null){
      _instance = ApiService._();
    }
    return _instance!;
  }

  static const MEDICINE_URL='https://run.mocky.io/v3/d497251a-8a41-4df1-8712-c567ec9adf3c';

   Future<Result<Map<String,dynamic>>> getMedicines()async{
    try{
      var response = await http.get(Uri.parse(MEDICINE_URL));
      if(response.statusCode==200){
        return Result(value: jsonDecode(response.body));
      }else{
        return Result(message: ErrorMessage('${response.body}',null));
      }
    }catch(ex,stack){
      return Result(message: ErrorMessage(ex.toString(),stack));
    }
  }
}