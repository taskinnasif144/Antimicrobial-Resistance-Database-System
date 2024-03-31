import 'dart:convert';

import 'package:doc_patient/utility_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> createFirebaseUser(email, password, name, userID, designation,
    hospitalName, departmentName) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim());

    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('usersV2')
        .doc(userCredential.user?.uid);
    userDoc.set({
      'name': name,
      'userID': userID,
      'designation': designation,
      'hospitalName': hospitalName,
      'departmentName': departmentName
    });


    return "User Created"; // return true if user creation is successful
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
    }
  } catch (e) {
    return 'An unexpected error occurred: ${e.toString()}';
  }
  return 'An unexpected error occurred.';
}

Future<Map<String, dynamic>> firebaseLoginUser(email, password) async {
  try {
    final UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    final User? user = credential.user;

    final idToken = await user?.getIdToken();

    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('usersV2')
        .doc(user?.uid)
        .get();

    Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;

    return {
      'message': "User Authorized",
      'token': idToken,
      'userData': userData
    };
  } on FirebaseAuthException catch (e) {
    return {'message': e.code};
  }
}

class BackendService {
  static Future<List<Map<String, dynamic>>> getSuggestions(String query) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot result = await firestore.collection('usersV2').get();
    List<Map<String, dynamic>> users = [];
    List<Map<String, dynamic>> suggestedUsers = [];
    for (var doc in result.docs) {
      users.add(doc.data() as Map<String, dynamic>);
    }

    for (var user in users) {
      if (query != '') {
        if (user['designation'] == 'Client') {
          if (user['name'].toLowerCase().contains(query.toLowerCase()) ||
              user['userID'].contains(query)) {
            suggestedUsers.add(user);
          }
        }
      }
    }

    return suggestedUsers;
  }
}

class DoctorSuggestions {
  static Future<List<Map<String, dynamic>>> getSuggestions(String query) async {
    if (query == "") return [];
    CollectionReference userRef =
        FirebaseFirestore.instance.collection('usersV2');
    QuerySnapshot userDocs = await userRef.get();
    final userData = userDocs.docs
        .map((doc) =>
            {"_id": doc.id, "data": doc.data() as Map<String, dynamic>})
        .toList();
    List<Map<String, dynamic>> doctorsArray = [];
    for (var user in userData) {
      final object = user["data"] as Map<String, dynamic>;
      if (object['designation'] == "Telemedicine Officer") {
        doctorsArray.add(user);
      }
    }
    return doctorsArray;
  }
}

Future<Map<String, dynamic>> getUserDetails(id) async {
  CollectionReference userRef =
      FirebaseFirestore.instance.collection('usersV2');
  QuerySnapshot userDocs = await userRef.get();
  final userData = userDocs.docs
      .map((doc) => {"_id": doc.id, "data": doc.data() as Map<String, dynamic>})
      .toList();
  List<Map<String, dynamic>> doctorsArray = [];
  for (var user in userData) {
    final object = user["data"] as Map<String, dynamic>;
    if (object['userID'] == id) {
      if(object['designation'] == "Telemedicine Officer"){
        doctorsArray.add(user);
      }

    }
  }

  return doctorsArray[0];
}

Future<Map<String, dynamic>> getSingleUser() async {
  var id = await getUserID();
  CollectionReference userRef =
      FirebaseFirestore.instance.collection('usersV2');
  QuerySnapshot userDocs = await userRef.get();
  final userData = userDocs.docs
      .map((doc) => {"_id": doc.id, "data": doc.data() as Map<String, dynamic>})
      .toList();
  List<Map<String, dynamic>> doctorsArray = [];
  for (var user in userData) {
    final object = user["data"] as Map<String, dynamic>;
    if (object['userID'] == id) {
      doctorsArray.add(user);
    }
  }
  return doctorsArray[0];
}
