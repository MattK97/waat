import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:newappc/rest/client/api_client.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/rest/response/single_response.dart';

class ChatServices {
  ApiClient _client = ApiClient(dio: Dio());

  Future<String> initChat(String appUserID, String interlocutorID) async {
    final databaseReference = FirebaseFirestore.instance;

    Map<String, dynamic> initialChatMeta = {
      "users": [appUserID, interlocutorID],
      "read": [],
      "typing": [],
      "last_sender_id": null,
      "last_message_timestamp": null,
      "last_message": null,
      "last_message_id": null,
      "last_message_type": "text",
      "is_group_chat": false
    };

    DocumentReference docRef = await databaseReference.collection('chat_info').add(initialChatMeta);
    await databaseReference.collection('chats').doc('${docRef.id}').set({});
    return docRef.id;
  }

  Future<void> updateChatInfo(String chatId, Map<String, dynamic> details) async {
    print("SENDING");
    await FirebaseFirestore.instance.collection('chat_info').doc(chatId).update(details);
  }

  Future<String> sendPrivateMessage(String chatID, Map<String, dynamic> message) async {
    final databaseReference = FirebaseFirestore.instance;
    final docRef =
        await databaseReference.collection('chats').doc(chatID).collection("messages").add(message);
    return docRef.id;
  }

  Future<void> notifyChat(String message, String teamID) async {
    try {
      final response = await _client.post(endpoint: 'teams/$teamID/messages', data: {
        "message_content": message,
      });
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

  Future<void> notifyPrivateChat(String message, String notifiedUserID) async {
    try {
      final response = await _client.post(endpoint: 'users/$notifiedUserID/messages', data: {
        "message_content": message,
      });
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
}
