import 'package:dio/dio.dart';
import 'package:newappc/models/meeting.dart';
import 'package:newappc/rest/client/api_client.dart';
import 'package:newappc/rest/response/list_response.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/rest/response/single_response.dart';

class MeetingServices {
  ApiClient _client = ApiClient(dio: Dio());

  Future<ListResponse<Meeting>> fetchMeetings(String teamID, int monthNumber) async {
    try {
      final response = await _client
          .get(endpoint: 'teams/$teamID/meetings', header: {'month': monthNumber.toString()});
      final value = ListResponse<Meeting>.fromJson(
        response,
        (json) => json == null ? null : Meeting.fromJson(json),
      );
      if (value.status != null && value.status.code == ResponseStatus.valid) {
        return value;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<SingleResponse<Map<String, dynamic>>> createMeeting(String teamId, Meeting meeting) async {
    try {
      final response =
          await _client.post(endpoint: 'teams/$teamId/meetings', data: meeting.toJson());
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

  Future<ResponseStatus> updateMeeting(String teamId, Meeting meeting) async {
    try {
      final response = await _client.put(
          endpoint: 'teams/$teamId/meetings/${meeting.meetingID}', data: meeting.toJson());
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

  Future<ResponseStatus> deleteMeeting(String teamId, Meeting meeting) async {
    try {
      final response =
          await _client.delete(endpoint: 'teams/$teamId/meetings/${meeting.meetingID}');
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
