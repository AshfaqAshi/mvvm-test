
class AuthProcess{
  ///[status]
  ///Determines at what state the current auth flow is
  AuthStatus status;
  AuthProcess():status=AuthStatus.started;
}

enum AuthStatus{
  started,
  codeSent,
  autoRetrievalTimedOut,
  signingIn,
  signedIn,
  error,
  completed
}