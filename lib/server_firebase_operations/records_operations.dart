import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> createARBRecord(
    name,
    userID,
    amoxycillin,
    azithromycin,
    cefotaxime,
    chloramphenicol,
    doxycycline,
    imipenem,
    levofloxacin,
    meropenem,
    netilmicin,
    nitrofurantoin,
    piperacilin,
    fosfomycin,
    ciprocin) async {
  var abrData = <String, dynamic>{
    "userID": userID,
    "name": name,
    "amoxycillin": amoxycillin,
    "azithromycin": azithromycin,
    "cefotaxime": cefotaxime,
    "chloramphenicol": chloramphenicol,
    "doxycycline": doxycycline,
    "imipenem": imipenem,
    "levofloxacin": levofloxacin,
    "meropenem": meropenem,
    "netilmicin": netilmicin,
    "nitrofurantoin": nitrofurantoin,
    "piperacilin": piperacilin,
    "fosfomycin": fosfomycin,
    "ciprocin": ciprocin,
    'createdAt': FieldValue.serverTimestamp(),
  };
  try {
    CollectionReference abrCollection =
        FirebaseFirestore.instance.collection("ABR Records V2");
    abrCollection.add(abrData);
    return {"message": "record created"};
  } catch (e) {
    return {"message": "Unexpected Error Occured"};
  }
}

Future<String> deleteABR(id) async {
  DocumentReference docRef = FirebaseFirestore.instance.collection('ABR Records V2').doc(id);
  await docRef.delete();
  return "ABR Report deleted";
}

Future<List<Map<String, dynamic>>> getAllARBRecords() async {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('ABR Records V2');
  QuerySnapshot querysnapshot = await collectionRef.get();
  final allAbrReports = querysnapshot.docs
      .map((doc) => {"_id": doc.id, "data": doc.data()})
      .toList();
  return allAbrReports;
}

Future<List<Map<String, dynamic>>> getAllUserARBRecords() async {
  var userID = await getUserID();
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('ABR Records V2');
  QuerySnapshot querysnapshot = await collectionRef.get();
  final allAbrReports = querysnapshot.docs
      .map((doc) => {"_id": doc.id, "data": doc.data()})
      .toList();
  List<Map<String, dynamic>> userArbReport = [];

  for (var report in allAbrReports) {
    Map<String, dynamic> data = report['data'] as Map<String, dynamic>;
    if (data['userID'] == userID) {
      userArbReport.add(report);
    }
  }

  return userArbReport;
}

Future<Map<String, dynamic>> getSngleARBReport(id) async {
  final docRef =
      FirebaseFirestore.instance.collection('ABR Records V2').doc(id);
  final document = await docRef.get();
  final returnableDoc = document.data();
  return returnableDoc!;
}

Future<Map<String, dynamic>> createRecord(userID, name, batch, session,
    department, disease, medicines, doctorID) async {
  const String baseUrl = '$serverURL/patient/create-record';
  var docName = await getUserName();
  var reqBody = <String, dynamic>{
    "userID": userID,
    "name": name,
    "batch": batch,
    "session": session,
    "department": department,
    "disease": disease,
    "medicines": medicines,
    "doctorID": doctorID,
    "doctorName": docName,
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

Future<List<Map<String, dynamic>>> getPatientRecords() async {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("patientRecordV2");
  QuerySnapshot snapshot = await collectionRef.get();
  final patientRecords =
      snapshot.docs.map((e) => {"_id": e.id, "data": e.data()}).toList();
  return patientRecords;
}

Future<Map<String, dynamic>> getSinglePatientRecords(id) async {
  DocumentReference patientDocRef =
      FirebaseFirestore.instance.collection('patientRecordV2').doc(id);
  final document = await patientDocRef.get();
  final data = document.data() as Map<String, dynamic>;
  return data;
}

Future<List<Map<String, dynamic>>> getNamedPatientRecords(name) async {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('patientRecordV2');
  final query = await collectionReference.get();
  List<Map<String, dynamic>> newData = [];
  final docs =
      query.docs.map((doc) => {"_id": doc.id, "data": doc.data()}).toList();
  for (var doc in docs) {
    final mapDoc = doc['data'] as Map<String, dynamic>;
    if (mapDoc['patientName'].toLowerCase().contains(name.toLowerCase())) {
      newData.add(doc);
    }
  }
  return newData;
}

Future<List<Map<String, dynamic>>> getPatientPersonalRecords() async {
  final userID = await getUserID();
  CollectionReference recordCollection =
      FirebaseFirestore.instance.collection('patientRecordV2');
  final query = await recordCollection.get();
  List<Map<String, dynamic>> newData = [];
  final docs =
      query.docs.map((doc) => {"_id": doc.id, "data": doc.data()}).toList();
  for (var doc in docs) {
    final mapDoc = doc['data'] as Map<String, dynamic>;
    if (mapDoc['patientUserID'] == userID) {
      newData.add(doc);
    }
  }

  final reversedData = newData.reversed;

  return reversedData.toList();
}

Future<String> deleteRecord(id) async {
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('patientRecordV2').doc(id);
  await docRef.delete();
  return "Deleted";
}

Future<bool> isActive() async {
  final userID = await getUserID();
  CollectionReference reportsRef =
      FirebaseFirestore.instance.collection('patientRecordV2');
  QuerySnapshot reportsSnapshot = await reportsRef.get();
  List<Map<String, dynamic>> reports = reportsSnapshot.docs
      .map((e) => {"_id": e.id, "data": e.data() as Map<String, dynamic>})
      .toList()
      .reversed
      .toList();
  var speceficReports = [];

  for (var report in reports) {
    if (report['data']['patientUserID'] == userID) {
      speceficReports.add(report);
    }
  }
  Map<String, dynamic> report = speceficReports[0];
  final medicines = report['data']['medicines'];
  var active = false;
  for (var med in medicines) {
    if (med['isAntibiotic']) {
      if (med['quantity'] > 0) {
        active = true;
      }
    }
  }
  return active;
}

Future<void> updateDose() async {
  final userID = await getUserID();
  CollectionReference reportsRef =
  FirebaseFirestore.instance.collection('patientRecordV2');
  QuerySnapshot reportsSnapshot = await reportsRef.get();
  List<Map<String, dynamic>> reports = reportsSnapshot.docs
      .map((e) => {"_id": e.id, "data": e.data() as Map<String, dynamic>})
      .toList()
      .reversed
      .toList();
  var speceficReports = [];

  for (var report in reports) {
    if (report['data']['patientUserID'] == userID) {
      speceficReports.add(report);
    }
  }

  Map<String, dynamic> report = speceficReports[0];
  final medicines = report['data']['medicines'];
  final docId = report["_id"];
  var updatedMedicine = [];
  for (var med in medicines) {
    if (med['quantity'] > 0) {
      med['quantity']--;
      updatedMedicine.add(med);
    }
  }
  reportsRef.doc(docId).update(
     {
     'medicines': updatedMedicine,
     }
  );
}
