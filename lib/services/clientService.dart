import 'dart:collection';

import 'package:accounting/commons/resources.dart';
import 'package:accounting/models/user.dart';
import 'package:accounting/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientService {
  final Firestore _firestore = Firestore.instance;
  final AuthService _authService = AuthService();

  Future<dynamic> addClient(HashMap<String, String> clientDetails) async {
    dynamic result = await _authService.getCurrentUserId();
    String response = '';
    if (result is UserId) {
      clientDetails.putIfAbsent('userUID', () => result.uid);
      HashMap<String, dynamic> clientMap = HashMap();
      clientMap.addAll(clientDetails);
      clientMap.putIfAbsent('createdAt', () => FieldValue.serverTimestamp());
      clientMap.putIfAbsent('updatedAt', () => FieldValue.serverTimestamp());
      await _firestore
          .collection(CLIENTS_COLLECTION)
          .add(clientMap)
          .catchError((e) => {response = e.toString()});
      if (response.isNotEmpty) {
        return response;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<List<dynamic>> getClients() async {
    dynamic user = await _authService.getCurrentUserId();
    List<Map<String, dynamic>> clients = List();
    if (user is UserId) {
      QuerySnapshot clientsSnapshot = await _firestore
          .collection(CLIENTS_COLLECTION)
          .where('userUID', isEqualTo: user.uid)
          .orderBy('updatedAt', descending: true)
          .getDocuments();
      clientsSnapshot.documents.forEach((element) {
        Map<String, dynamic> client = element.data;
        client.putIfAbsent('clientUID', () => element.documentID);
        clients.add(client);
      });
    } else {
      return null;
    }
    return clients;
  }

  Stream<QuerySnapshot> getClientStream(UserId user) {
    return _firestore
        .collection(CLIENTS_COLLECTION)
        .where('userUID', isEqualTo: user.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }

  Future updateClient(Map<String, dynamic> clientDetails) async {
    dynamic result = await _authService.getCurrentUserId();
    String response = '';
    if (result is UserId) {
      clientDetails.putIfAbsent('userUID', () => result.uid);
      Map<String, dynamic> clientMap = clientDetails;
      clientMap.update('updatedAt', (val) => FieldValue.serverTimestamp());
      String clientUID = clientMap['clientUID'];
      clientMap.remove('clientUID');
      await _firestore
          .collection(CLIENTS_COLLECTION)
          .document(clientUID)
          .setData(clientMap)
          .catchError((e) => {response = e.toString()});
      if (response.isNotEmpty) {
        return response;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> getClientById(String clientId) async {
    dynamic user = await _authService.getCurrentUserId();

    if (user is UserId) {
      DocumentSnapshot clientDocument = await _firestore
          .collection(CLIENTS_COLLECTION)
          .document(clientId)
          .get();
      return clientDocument.data;
    } else {
      return null;
    }
  }

  Future<HashMap<String, String>> getClientNamesByUserId(String userUID) async {
    QuerySnapshot clientSnapshots = await _firestore
        .collection(CLIENTS_COLLECTION)
        .where('userUID', isEqualTo: userUID)
        .getDocuments();

    HashMap<String, String> clientUIDvsClientName = HashMap();
    clientSnapshots.documents.forEach((element) {
      clientUIDvsClientName.putIfAbsent(
          element.documentID, () => element.data['name']);
    });
    return clientUIDvsClientName;
  }

  Future<bool> deleteClient(String clientUID) async {
    // also delete invoices with this client
    bool isSuccess = true;
    await _firestore
        .collection(CLIENTS_COLLECTION)
        .document(clientUID)
        .delete()
        .catchError((e) => isSuccess = false);
    return isSuccess;
  }
}
