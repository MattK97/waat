import 'package:json_annotation/json_annotation.dart';

import 'response_status.dart';

@JsonSerializable(genericArgumentFactories: true)
class SingleResponse<T> {
  T data;
  ResponseStatus status;

  SingleResponse({
    this.data,
    this.status,
  });

  factory SingleResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) create) {
    return SingleResponse<T>(
      data: create(
        json["data"],
      ),
      status: ResponseStatus.fromJson(json['status']),
    );
  }
}
