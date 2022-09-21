import 'package:json_annotation/json_annotation.dart';
import 'package:newappc/rest/response/response_status.dart';

@JsonSerializable(genericArgumentFactories: true)
class ListResponse<T> {
  List<T> data;
  ResponseStatus status;

  ListResponse({
    this.status,
    this.data,
  });

  factory ListResponse.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    List<T> data = <T>[];
    if (json['data'] == null) {
      data = [];
    } else {
      json['data'].forEach((v) {
        data.add(create(v));
      });
    }
    return ListResponse<T>(
      data: data,
      status: ResponseStatus.fromJson(
        json['status'],
      ),
    );
  }
}

extension ListResponseX<T> on ListResponse<T> {
  bool get hasError {
    return this == null ||
        (this.data == null &&
            (this.status.code >= ResponseStatus.badRequest &&
                this.status.code < ResponseStatus.internalServerError));
  }

  bool get isEmpty {
    return this.status.code == ResponseStatus.noData ||
        (this.data == null && this.status.code == ResponseStatus.valid);
  }
}
