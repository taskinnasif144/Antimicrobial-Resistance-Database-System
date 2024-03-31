// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadToFirebase(String filePath, String fileName) async {
  final storageRef = FirebaseStorage.instance.ref();
  final mountainsRef = storageRef.child(fileName);
  final mountainFileRef = storageRef.child("files/$fileName");
  assert(mountainsRef.name == mountainFileRef.name);
  assert(mountainsRef.fullPath != mountainFileRef.fullPath);
  var file = File(filePath);
  String url = "";
  try {
    var token = await getUserToken();
    await mountainsRef.putFile(
        file, SettableMetadata(customMetadata: {'token': token!}));
    url = await mountainsRef.getDownloadURL();
  } catch (e) {
    // ...
  }
  return url;
}



// Future<Map<String,dynamic>> deleteUploadedFile(id) async {
//   var  baseUrl = '$serverURL/files/delete/$id';
//
//   final response = await http.delete(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
//   if (response.statusCode == 200) {
//     String body = response.body;
//     Map<String, dynamic> json = jsonDecode(body);
//     print(json);
//     return json;
//   } else {
//     throw Exception('Failed to delete file.');
//   }
// }


