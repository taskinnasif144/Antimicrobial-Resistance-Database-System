// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<String> uploadFile(String filePath, String fileName) async {
  var userID = await getUserID();
  var url = await uploadToFirebase(filePath, fileName);
  bool exists = false;
  CollectionReference filesRef = FirebaseFirestore.instance.collection("FilesV2");

  QuerySnapshot querySnapshots = await filesRef.get();

  for (var snapshot in querySnapshots.docs) {
    var file = snapshot.data() as Map<String, dynamic>;
    var nameOfFile = file['fileName'];
    if (nameOfFile == fileName) {
      exists = true;
    }
  }
  var documentBody = <String, dynamic>{
    "fileName": fileName,
    "fileUrl": url,
    "fileOwner": userID,
    'createdAt': FieldValue.serverTimestamp()
  };
  if (url == "") {
    return "Upload Failed";
  }



  if (!exists) {
    await filesRef.add(documentBody);
    return "File Uploaded";
  } else {
    return "File Already Exists";
  }
}

Future<Map<String, dynamic>> getUploadedFiles() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference collections = firestore.collection("FilesV2");
  QuerySnapshot snapshots = await collections.get();

  List<Map<String, dynamic>> jsonSnapshots = [];

  for (var snapshot in snapshots.docs) {
    var file = snapshot.data() as Map<String, dynamic>;
    var fileID = snapshot.id;
    var jsonFile = {"_id": fileID, "file": file};
    jsonSnapshots.add(jsonFile);
  }

  return {"message": "Loaded", 'files': jsonSnapshots};
}

Future<String> deleteUploadedFile(id) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection("FilesV2").doc(id);
  var uid = await getUserID();
  var doc = await docRef.get() ;
  var docData = doc.data() as Map<String, dynamic>;
  var owner = docData["fileOwner"];
  if(owner == uid) {
    await docRef.delete();
    return "deleted";
  }

  return "You are not authorized to delete";
}
