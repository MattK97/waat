import 'package:dio/dio.dart';
import 'package:newappc/models/User.dart';
import 'package:newappc/rest/client/api_client.dart';
import 'package:newappc/rest/response/list_response.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/rest/response/single_response.dart';

class TeamServices {
  ApiClient _client = ApiClient(dio: Dio());

  Future<SingleResponse<Map<String, dynamic>>> createTeam(String teamName) async {
    try {
      final response = await _client.post(endpoint: 'team', data: {'team_name': teamName});
      final value = SingleResponse<Map<String, dynamic>>.fromJson(
        response,
        (json) => json == null ? null : Map.from(json),
      );
      if (value.status != null && value.status.code == ResponseStatus.valid) {
        return value;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<ResponseStatus> joinTeam(String teamId) async {
    try {
      final response = await _client.post(endpoint: 'teams/$teamId/join');
      final value = SingleResponse<Map<String, dynamic>>.fromJson(
        response,
        (json) => json == null ? null : Map.from(json),
      );
      if (value.status != null && value.status.code == ResponseStatus.valid) {
        return value.status;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<ListResponse<User>> fetchTeamMembers(String teamId) async {
    try {
      final response = await _client.get(endpoint: 'teams/$teamId/members');
      final value = ListResponse<User>.fromJson(
        response,
        (json) => json == null ? null : User.fromJson(json),
      );
      if (value.status != null && value.status.code == ResponseStatus.valid) {
        return value;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<ResponseStatus> deleteTeam(String teamId) async {
    try {
      final response = await _client.post(endpoint: 'teams/$teamId/delete-team');
      final value = SingleResponse<Map<String, dynamic>>.fromJson(
        response,
        (json) => json == null ? null : Map.from(json),
      );
      if (value.status != null && value.status.code == ResponseStatus.valid) {
        return value.status;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
