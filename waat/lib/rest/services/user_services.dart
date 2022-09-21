import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:newappc/models/ColorM.dart';
import 'package:newappc/models/Team.dart';
import 'package:newappc/models/app_version.dart';
import 'package:newappc/rest/client/api_client.dart';
import 'package:newappc/rest/response/list_response.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/rest/response/single_response.dart';

class UserServices {
  ApiClient _client = ApiClient(dio: Dio());

  Future<ResponseStatus> registerUser(String firstName, String lastName, int colorID) async {
    final data = {'first_name': firstName, 'last_name': lastName, 'color': colorID};
    try {
      final response = await _client.post(endpoint: 'register', data: data);
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

  Future<ListResponse<Team>> fetchUserTeams() async {
    var fire = await fb.FirebaseAuth.instance.currentUser;
    try {
      final response = await _client.get(endpoint: 'user/${fire.uid}/teams');

      final value = ListResponse<Team>.fromJson(
        response,
        (json) => json == null ? null : Team.fromJson(json),
      );
      if (value.status != null && value.status.code == ResponseStatus.valid) {
        return value;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<ListResponse<ColorM>> fetchColors() async {
    var fire = await fb.FirebaseAuth.instance.currentUser;
    try {
      final response = await _client.get(endpoint: 'colors');
      final value = ListResponse<ColorM>.fromJson(
        response,
        (json) => json == null ? null : ColorM.fromJson(json),
      );
      if (value.status != null && value.status.code == ResponseStatus.valid) {
        return value;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<SingleResponse<Map<String, dynamic>>> checkExistence() async {
    try {
      final response = await _client.get(endpoint: 'existence');
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

  Future<ResponseStatus> checkToken(String registrationToken) async {
    try {
      final response = await _client.post(
          endpoint: 'token',
          header: {'registration_token': registrationToken, 'locale': Platform.localeName});
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

  Future<ResponseStatus> updateFirstName(String firstName) async {
    try {
      final response =
          await _client.put(endpoint: 'update-first-name', data: {'first_name': firstName});
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

  Future<ResponseStatus> updateLastName(String lastName) async {
    try {
      final response =
          await _client.put(endpoint: 'update-last-name', data: {'last_name': lastName});
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

  Future<ResponseStatus> updateColor(int colorIndex) async {
    try {
      final response = await _client.put(endpoint: 'update-color', data: {'color_id': colorIndex});
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

  Future<ResponseStatus> promoteUser(String teamID, String userToPromoteID) async {
    try {
      final response =
          await _client.put(endpoint: 'teams/${teamID}/members/${userToPromoteID}/promote');
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

  Future<ResponseStatus> degradeUser(String teamID, String userToPromoteID) async {
    try {
      final response =
          await _client.put(endpoint: 'teams/${teamID}/members/${userToPromoteID}/degrade');
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

  Future<ResponseStatus> deleteAccount() async {
    try {
      final response = await _client.put(endpoint: 'delete-account');
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

  Future<ResponseStatus> deleteToken() async {
    try {
      final response = await _client.put(endpoint: 'delete-token');
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

  Future<SingleResponse<AppVersion>> getRecentAppVersion() async {
    try {
      final response = await _client.get(endpoint: 'app/version', header: {'os': 'ios'});
      final value = SingleResponse<AppVersion>.fromJson(
        response,
        (json) => json == null ? null : AppVersion.fromMap(json),
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
