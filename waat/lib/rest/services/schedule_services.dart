import 'package:dio/dio.dart';
import 'package:newappc/models/Schedule.dart';
import 'package:newappc/models/ScheduleSwap.dart';
import 'package:newappc/models/ScheduleSwapHistory.dart';
import 'package:newappc/rest/client/api_client.dart';
import 'package:newappc/rest/response/list_response.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/rest/response/single_response.dart';

class ScheduleServices {
  ApiClient _client = ApiClient(dio: Dio());

  Future<ListResponse<Schedule>> fetchSchedules(String teamId, int monthNumber, int year) async {
    try {
      final response = await _client.get(
          endpoint: 'teams/$teamId/schedules',
          header: {'month': monthNumber.toString(), 'year': year.toString()});
      final value = ListResponse<Schedule>.fromJson(
        response,
        (json) => json == null ? null : Schedule.fromJson(json),
      );
      if (value.status != null && value.status.code == ResponseStatus.valid) {
        return value;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<SingleResponse<Map<String, dynamic>>> createSchedule(
      String teamId, Schedule schedule) async {
    try {
      final response =
          await _client.post(endpoint: 'teams/$teamId/schedules', data: schedule.toJson());
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

  Future<ResponseStatus> updateSchedule(String teamID, Schedule schedule) async {
    try {
      final response =
          await _client.put(endpoint: 'teams/$teamID/schedules/update', data: schedule.toJson());
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

  Future<ResponseStatus> deleteSchedule(String teamId, int scheduleId) async {
    try {
      final response = await _client.delete(endpoint: 'teams/$teamId/schedule/$scheduleId');
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

  Future<SingleResponse<Map<String, dynamic>>> createScheduleSwap(
      String teamId, ScheduleSwap scheduleSwap) async {
    try {
      final response =
          await _client.post(endpoint: 'teams/$teamId/schedules/swap', data: scheduleSwap.toJson());
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

  Future<ResponseStatus> deleteScheduleSwap(String teamId, int ScheduleSwapId) async {
    try {
      final response = await _client.post(endpoint: 'teams/$teamId/schedules/swap/$ScheduleSwapId');
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

  Future<ResponseStatus> updateScheduleSwap(
      String teamId, int ScheduleSwapId, bool agreement) async {
    try {
      final response = await _client.put(
          endpoint: 'teams/$teamId/schedules/swap/$ScheduleSwapId', data: {'agreement': agreement});
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

  Future<ListResponse<ScheduleSwapHistory>> fetchScheduleSwapHistory(
      String teamID, int monthNumber) async {
    try {
      final response = await _client.get(
          endpoint: 'teams/$teamID/schedules/swap/history',
          header: {'month': monthNumber.toString()});
      final value = ListResponse<ScheduleSwapHistory>.fromJson(
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
}
