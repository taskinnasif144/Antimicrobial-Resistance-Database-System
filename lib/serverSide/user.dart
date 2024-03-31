import 'dart:convert';
import 'dart:math';
import 'package:doc_patient/UserPages/welcome.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const serverURL = 'https://doc-patient.onrender.com';
// const serverURL = 'http://192.168.0.106:3000';

// Future<String> registerUser(
//     name, userID, password, designation, hospitalName, department) async {
//   const String baseUrl = '$serverURL/auth/createNewUser';
//
//   var reqBody = <String, String>{
//     'name': name,
//     'userID': userID,
//     'password': password,
//     'designation': designation,
//     'hospitalName': hospitalName,
//     'department': department,
//   };
//
//   final response = await http.post(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(reqBody),
//   );
//   if (response.statusCode == 200) {
//     String body = response.body;
//     Map<String, dynamic> json = jsonDecode(body);
//     return json['message'];
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to create album.');
//   }
// }

// Future<Map<String, dynamic>> loginUser(userID, password) async {
//   const String baseUrl = '$serverURL/auth/userLogin';
//
//   var reqBody = <String, String>{
//     "userID": userID,
//     "password": password,
//   };
//
//   final response = await http.post(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(reqBody),
//   );
//
//   if (response.statusCode == 200) {
//     String body = response.body;
//     Map<String, dynamic> json = jsonDecode(body);
//     return json;
//   } else {
//     throw Exception('Failed to create album.');
//   }
// }

void logoutUser(context) async {
  FirebaseAuth.instance.signOut();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('userID');
  await prefs.remove('name');
  await prefs.remove('designation');
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Welcome()),
      (Route<dynamic> route) => false);
}



// class DoctorSuggestions {
//   static Future<List<Map<String, dynamic>>> getSuggestions(String query) async {
//     const String baseUrl = '$serverURL/auth/doctors';
//     var reqBody = <String, String>{"query": query};
//
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(reqBody),
//     );
//
//     if (response.statusCode == 200) {
//       String body = response.body;
//       List<dynamic> jsonList = jsonDecode(body);
//       List<Map<String, dynamic>> suggestions =
//           jsonList.cast<Map<String, dynamic>>();
//       return suggestions;
//     } else {
//       throw Exception('Failed to get suggestions.');
//     }
//   }
// }

class SearchPatientReports {
  static Future<List<Map<String, dynamic>>> getSuggestions(String query) async {
    const String baseUrl = '$serverURL/patient/get-suggestions';

    var reqBody = <String, String>{"query": query};

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reqBody),
    );

    if (response.statusCode == 200) {
      String body = response.body;
      List<dynamic> jsonList = jsonDecode(body);
      List<Map<String, dynamic>> suggestions =
          jsonList.cast<Map<String, dynamic>>();
      return suggestions;
    } else {
      throw Exception('Failed to get suggestions.');
    }
  }
}



// Future<List<Map<String, dynamic>>> getPatientRecords() async {
//   const baseUrl = "$serverURL/patient/get-records";
//
//   final response = await http.get(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
//
//   if (response.statusCode == 200) {
//     String body = response.body;
//
//     // Use `List<dynamic>` instead of `List<Map<String, dynamic>>`
//     List<dynamic> json = jsonDecode(body);
//
//     // Check if every item in the list is a map
//     if (json.every((item) => item is Map<String, dynamic>)) {
//       // If every item is a map, cast the list to `List<Map<String, dynamic>>`
//       return json.cast<Map<String, dynamic>>();
//     } else {
//       throw Exception('Invalid data format.');
//     }
//   } else {
//     throw Exception('Failed to get suggestions.');
//   }
// }

// Future<Map<String, dynamic>> getSinglePatientRecords(id) async {
//   var baseUrl = "$serverURL/patient/get-record/$id";
//
//   final response = await http.get(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
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

// Future<Map<String, dynamic>> getSingleUser() async {
//   var id = await getUserID();
//   var baseUrl = "$serverURL/auth/get-record/$id";
//
//   final response = await http.get(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
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

// Future<Map<String, dynamic>> getUserDetails(id) async {
//   var baseUrl = "$serverURL/auth/get-record/$id";
//
//   final response = await http.get(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
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



// Future<Map<String, dynamic>> getPatientPersonalRecords() async {
//   var uid = await getUserID();
//   var baseUrl = "$serverURL/auth/get-my-records/$uid";
//
//   final response = await http.get(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
//
//   if (response.statusCode == 200) {
//     String body = response.body;
//
//     // Use `List<dynamic>` instead of `List<Map<String, dynamic>>`
//     Map<String, dynamic> json = jsonDecode(body);
//     return json;
//   } else {
//     throw Exception('Failed to get suggestions.');
//   }
// }

// Future<Map<String, dynamic>> getNotifications() async {
//   var uid = await getUserID();
//   var baseUrl = "$serverURL/noti/$uid";
//   final response = await http.get(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
//
//   if (response.statusCode == 200) {
//     String body = response.body;
//     Map<String, dynamic> json = jsonDecode(body);
//     return json;
//   } else {
//     throw Exception("Failed to get Notifications");
//   }
// }

// Future<String> deleteNotification(id) async {
//   var baseUrl = "$serverURL/noti/delete/$id";
//
//   final response = await http.delete(Uri.parse(baseUrl),
//       headers: <String, String>{
//         "Content-Type": "application/json; charset=UFT-8"
//       });
//
//   if (response.statusCode == 200) {
//     String body = response.body;
//     Map<String, dynamic> jsonBody = jsonDecode(body);
//     return jsonBody['message'];
//   } else {
//     throw Exception("Something went wrong");
//   }
// }

// Future<Map<String, dynamic>> getARBReports() async {
//   var uid = await getUserID();
//   var baseUrl = "$serverURL/lab/get-arb-records/$uid";
//   final response = await http.get(Uri.parse(baseUrl), headers: <String, String>{
//     'Content-Type': "application/json; charset=UFT-8"
//   });
//
//   if (response.statusCode == 200) {
//     String body = response.body;
//     Map<String, dynamic> json = jsonDecode(body);
//
//     return json;
//   } else {
//     throw Exception("Something Went Wrong");
//   }
// }





// Future<void> updateDose() async {
//   var userID = await getUserID();
//   var baseUrl = "$serverURL/patient/update-dose";
//
//   var jsonBody = {"pid": userID};
//
//   final response = await http.put(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(jsonBody),
//   );
//
//   if (response.statusCode == 200) {
//     String body = response.body;
//     Map<String, dynamic> json = jsonDecode(body);
//
//     return json['message'];
//   } else {
//     throw Exception("Something Went Wrong");
//   }
// }

// Future<String> deleteRecord(id) async {
//   var baseUrl = "$serverURL/patient/delete-record/$id";
//
//   final response = await http.delete(
//     Uri.parse(baseUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
//
//   if (response.statusCode == 200) {
//     String resBody = response.body;
//     Map<String, dynamic> jsonBody = jsonDecode(resBody);
//     return jsonBody['message'];
//   } else {
//     throw Exception("Something went wrong");
//   }
// }

Future<String> deleteArb(id) async {
  var baseUrl = "$serverURL/lab/delete-arb/$id";

  final response = await http.delete(
    Uri.parse(baseUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    String resBody = response.body;
    Map<String, dynamic> jsonBody = jsonDecode(resBody);

    return jsonBody['message'];
  } else {
    throw Exception("Something went wrong");
  }
}
