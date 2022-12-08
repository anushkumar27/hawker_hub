/// ApplicationNetworkException
/// Defines all exceptions related to network activity of this application
class ApplicationNetworkException implements Exception {
  final String _errorMessage;
  final String _prefix;

  ApplicationNetworkException(this._errorMessage, this._prefix);

  @override
  String toString() {
    return "$_prefix$_errorMessage";
  }
}

class FetchDataException extends ApplicationNetworkException {
  FetchDataException([errorMessage])
      : super(errorMessage, "Error During Communication: ");
}

class BadRequestException extends ApplicationNetworkException {
  BadRequestException([errorMessage])
      : super(errorMessage, "Invalid Request: ");
}

class UnauthorisedException extends ApplicationNetworkException {
  UnauthorisedException([errorMessage]) : super(errorMessage, "Unauthorised: ");
}

class InvalidInputException extends ApplicationNetworkException {
  InvalidInputException([errorMessage])
      : super(errorMessage, "Invalid Input: ");
}

class AuthenticationException extends ApplicationNetworkException {
  AuthenticationException([errorMessage])
      : super(errorMessage, "Authentication Failed: ");
}

class ClientTimeoutException extends ApplicationNetworkException {
  ClientTimeoutException([errorMessage])
      : super(errorMessage, "Client Request Timedout: ");
}
