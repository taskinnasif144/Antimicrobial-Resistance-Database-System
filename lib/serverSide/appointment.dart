import 'dart:convert';
import 'dart:math';
import 'package:doc_patient/UserPages/welcome.dart';
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


// Future<Map<String, dynamic>> createAppointment(doctorID, doctorName, timeString) async {
//   const String baseUrl = '$serverURL/appointments/create';
//   var patientName = await getUserName();
//   var patientID = await getUserID();
//
//   var reqBody = <String, dynamic>{
//     "patientName": patientName,
//     "patientID": patientID,
//     "schedule": timeString,
//     "doctorID": doctorID,
//     "doctorName":doctorName
//   };
//
//   final response = await http.post(Uri.parse(baseUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(reqBody));
//
//   if (response.statusCode == 200) {
//     String body = response.body;
//     Map<String, dynamic> json = jsonDecode(body);
//
//     return json;
//   } else {
//     throw Exception('Failed to get suggestions.');
//   }
// }


// Future<Map<String, dynamic>> getAppointments() async {
//   var userID = await getUserID();
//   var userDesignation = await getUserDesignation();
//   String baseUrl = '$serverURL/appointments/get/$userDesignation/$userID';
//
//   final response = await http.get(Uri.parse(baseUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//      );
//
//   if (response.statusCode == 200) {
//     String body = response.body;
//     Map<String, dynamic> json = jsonDecode(body);
//     return json;
//   } else {
//     throw Exception('Failed to get suggestions.');
//   }
// }


// Future<String> deleteAppointment(id) async {
//   var baseUrl = "$serverURL/appointments/delete/$id";
//   final response = await http.delete(Uri.parse(baseUrl),
//       headers: <String, String>{
//         "Content-Type": "application/json; charset=UFT-8"
//       });
//   if (response.statusCode == 200) {
//     String body = response.body;
//     Map<String, dynamic> jsonBody = jsonDecode(body);
//     return jsonBody['message'];
//   } else {
//     throw Exception("Something went wrong");
//   }
// }