class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

class WebServiceException extends AppException {
  WebServiceException(super.message);
}
