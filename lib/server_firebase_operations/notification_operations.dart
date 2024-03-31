import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<List<Map<String, dynamic>>> getNotifications() async {
  var userID = await getUserID();
  CollectionReference notiRef = FirebaseFirestore.instance.collection('notificationsV2');
  QuerySnapshot notiSnaps = await notiRef.get();
  List<Map<String,dynamic>> myNoti = [];
  final notiDocs = notiSnaps.docs.map((doc) => {"_id": doc.id, "data": doc.data() as Map<String, dynamic>}).toList();
  for(var noti in notiDocs){
   final notiData = noti['data'] as Map<String, dynamic>;
   if(notiData['recieverID'] == userID){
     myNoti.add(noti);
   }
  }
  return myNoti;
}

Future<String> deleteNotification(id) async {
  DocumentReference docRef = FirebaseFirestore.instance.collection("notificationsV2").doc(id);
  await docRef.delete();
  return "deleted";
}