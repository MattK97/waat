import 'package:dio/dio.dart';
import 'package:newappc/models/announcement.dart';
import 'package:newappc/models/announcement_comment.dart';
import 'package:newappc/rest/client/api_client.dart';
import 'package:newappc/rest/response/list_response.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/rest/response/single_response.dart';

class AnnouncementServices {
  ApiClient _client = ApiClient(dio: Dio());

  Future<SingleResponse<Map<String, dynamic>>> createAnnouncement(
      String teamID, Announcement announcement) async {
    try {
      final response =
          await _client.post(endpoint: 'teams/$teamID/announcements', data: announcement.toJson());
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

  Future<ResponseStatus> deleteAnnouncement(String teamId, Announcement announcement) async {
    try {
      final response = await _client.delete(
          endpoint: 'teams/$teamId/announcements/${announcement.announcementID}');
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

  Future<SingleResponse<Map<String, dynamic>>> updateAnnouncement(
      String teamId, Announcement announcement) async {
    try {
      final response = await _client.put(
          endpoint: 'teams/$teamId/announcements/${announcement.announcementID}',
          data: announcement.toJson());
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

  Future<ResponseStatus> updateAnnouncementOrder(String teamId, List<Map<String, int>> list) async {
    try {
      final response = await _client.put(endpoint: 'teams/$teamId/announcement/order', data: list);
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

  Future<ListResponse<Announcement>> fetchAnnouncements(String teamID, int monthNumber) async {
    try {
      final response = await _client
          .get(endpoint: 'teams/$teamID/announcements', header: {'month': monthNumber.toString()});
      print(response);
      final value = ListResponse<Announcement>.fromJson(
        response,
        (json) => json == null ? null : Announcement.fromJson(json),
      );
      if (value.status != null && value.status.code == ResponseStatus.valid) {
        return value;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<SingleResponse<Map<String, dynamic>>> createAnnouncementComment(
      String teamID, AnnouncementComment announcementComment) async {
    try {
      final response = await _client.post(
          endpoint: 'teams/$teamID/announcement/comment', data: announcementComment.toMap());
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

  Future<ResponseStatus> updateAnnouncementComment(
      String teamId, AnnouncementComment announcementComment) async {
    try {
      final response = await _client.put(
          endpoint: 'teams/$teamId/announcement/comment/${announcementComment.id}',
          data: announcementComment.toMap());
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

  Future<ResponseStatus> deleteAnnouncementComment(
      String teamId, AnnouncementComment announcementComment) async {
    try {
      final response = await _client.delete(
          endpoint: 'teams/$teamId/announcement/comment/${announcementComment.id}');
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
