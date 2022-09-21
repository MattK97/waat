class ResponseStatus {
  static const int valid = 200;
  static const int noData = 204;
  static const int invalid = 401;
  static const int notFound = 404;
  static const int badRequest = 400;
  static const int internalServerError = 500;

  String message;
  int code;

  ResponseStatus({this.message, this.code});

  factory ResponseStatus.fromJson(Map<String, dynamic> json) {
    return ResponseStatus(code: json['code'], message: json['message']);
  }
}

extension ResponseStatusX on ResponseStatus {
  bool get hasError => this == null || this.code >= 400;
}
