import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<Map<String, dynamic>> createAppointment(doctorID, doctorName, timeString) async {
  const String baseUrl = '$serverURL/appointments/create';
  var patientName = await getUserName();
  var patientID = await getUserID();

  var reqBody = <String, dynamic>{
    "patientName": patientName,
    "patientID": patientID,
    "schedule": timeString,
    "doctorID": doctorID,
    "doctorName":doctorName
  };

  final response = await http.post(Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reqBody));

  if (response.statusCode == 200) {
    String body = response.body;
    Map<String, dynamic> json = jsonDecode(body);

    return json;
  } else {
    throw Exception('Failed to get suggestions.');
  }
}

Future<List<Map<String, dynamic>>> getAppointments() async {
  var userID = await getUserID();
  CollectionReference appointmentsRef = FirebaseFirestore.instance.collection('appointmentsV2');
  QuerySnapshot appointmentsSnaps = await appointmentsRef.get();
  List<Map<String,dynamic>> appointments = appointmentsSnaps.docs.map((doc) => {"_id": doc.id, "data": doc.data() as Map<String,dynamic>}).toList();
  List<Map<String, dynamic>> myAppointments = [];
  for(var appointment in appointments){
    if(appointment["data"]["patientID"] == userID || appointment["data"]["doctorID"] == userID){
      myAppointments.add(appointment);
    }
  }
  List<Map<String, dynamic>> upComing = [];
  for(var appointment in myAppointments) {

    DateTime appointmentDate = DateTime.parse(appointment['data']['date']);
    DateTime currentDate = DateTime.now();

    if(currentDate.isBefore(appointmentDate)){
      upComing.add(appointment);
    }
  }
  return upComing;
}

Future<String> deleteAppointment(id) async {
  DocumentReference docRef = FirebaseFirestore.instance.collection('appointmentsV2').doc(id);
  await docRef.delete();
  return "Appointment Deleted";
}
