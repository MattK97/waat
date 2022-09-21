import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:newappc/models/TaskContainer.dart';
import 'package:newappc/models/task.dart';
import 'package:newappc/rest/client/api_client.dart';
import 'package:newappc/rest/response/list_response.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/rest/response/single_response.dart';
import 'package:newappc/views/news_tab/calendar/chosen_day_widgets/task_list.dart';

class TaskServices {
  ApiClient _client = ApiClient(dio: Dio());

  Future<SingleResponse<Map<String, dynamic>>> createTaskContainer(
      String teamId, TaskContainer taskContainer) async {
    try {
      final response = await _client.post(
          endpoint: 'teams/$teamId/task_container', data: taskContainer.toJson());
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

  Future<ListResponse<TaskContainer>> fetchTaskContainer(String teamId) async {
    try {
      final response = await _client.get(endpoint: 'teams/$teamId/task_container');
      final value = ListResponse<TaskContainer>.fromJson(
        response,
        (json) => json == null ? null : TaskContainer.fromJson(json),
      );
      if (value.status != null && value.status.code == ResponseStatus.valid) {
        return value;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<ResponseStatus> deleteTaskContainer(TaskContainer taskContainer, String teamId) async {
    try {
      final response = await _client.delete(
          endpoint: 'teams/$teamId/task_container/${taskContainer.taskContainerID}');
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

  Future<ResponseStatus> updateTaskContainerOrder(
      String teamId, List<Map<String, int>> list) async {
    try {
      final response =
          await _client.put(endpoint: 'teams/$teamId/task_container/order', data: jsonEncode(list));
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

  Future<ResponseStatus> updateTaskContainer(TaskContainer taskContainer, String teamID) async {
    try {
      final response = await _client.put(
          endpoint: 'teams/$teamID/task_container/${taskContainer.taskContainerID}',
          data: taskContainer.toJson());
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

  Future<ListResponse<TaskList>> fetchTaskList(String teamID, int monthNumber) async {
    try {
      final response = await _client
          .get(endpoint: 'teams/$teamID/tasks', header: {'month': monthNumber.toString()});
      final value = ListResponse<TaskList>.fromJson(
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

  Future<SingleResponse<Map<String, dynamic>>> createTask(Task task, String teamId) async {
    try {
      final response = await _client.post(endpoint: 'teams/$teamId/tasks', data: task.toJson());
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

  Future<ResponseStatus> deleteTask(Task task, String teamId) async {
    try {
      final response = await _client.delete(endpoint: 'teams/$teamId/tasks/${task.taskID}');
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

  Future<ResponseStatus> updateTask(Task task, String teamId) async {
    try {
      final response =
          await _client.put(endpoint: 'teams/$teamId/tasks/${task.taskID}', data: task.toJson());
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
