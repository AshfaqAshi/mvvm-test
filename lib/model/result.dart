
class Result<T>{
  T? value;
  late bool _success;
  ///[message]
  ///The actual message containing complete details
  ///and stack of the error
  ErrorMessage? message;

  ///[userMessage]
  ///The message to be displayed to the user
  String? userMessage;

  bool get success=>_success;

   Result({this.value, this.message,this.userMessage}){
    ///initialize [_success] accordingly
     if(this.value==null){
       ///No value, which means an error has occurred
       _success = false;
     }else{
       ///[value] is non-null, therefore successful operation
       _success = true;
     }
  }
}

class ErrorMessage{
  String exception;
  StackTrace? stack;
  ErrorMessage(this.exception,this.stack);
}