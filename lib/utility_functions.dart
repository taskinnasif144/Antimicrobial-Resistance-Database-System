import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:doc_patient/homePage/home_button_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

String renderDate(timestamp) {
  var date =  timestamp.toDate();
  return DateFormat('yyyy-MM-dd').format(date).toString();
}

String renderTime( timestamp) {
  var time =  timestamp.toDate();
  return DateFormat('jm').format(time).toString();
}

Widget headerComponent(context) => Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          notificationButton(context),
        ],
      ),
    );

Widget space(double height) => SizedBox(height: height);

Widget titleRegistration(String title) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400, fontFamily: 'Libre Baskerville' ),
          ),
        ),
      ],
    );

Widget subTitleRegistration(String title) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      ],
    );

Widget customTextType1(String value) => Text(
      value,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );

Widget customTextType2(String value) => Text(value,
    style: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey));

Widget patientRecordDataFields(String key, String value) => Padding(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [customTextType1(key), customTextType2(value)],
      ),
    );

Widget patientRecordMedicineTableHeader(String key, String value) => Padding(
      padding: EdgeInsets.symmetric(vertical: 22, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [customTextType1(key), customTextType1(value)],
      ),
    );

class MedicineData {
  String name;
  int count;
  bool isAntibiotics;

  MedicineData({
    required this.name,
    required this.count,
    required this.isAntibiotics,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicineName': name,
      'quantity': count,
      'isAntibiotic': isAntibiotics,
    };
  }
}

Future<String?> getUserID() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userID = prefs.getString('userID');
  return userID;
}

Future<String?> getUserToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userID = prefs.getString('token');
  return userID;
}


Future<String> resetDoseScheduleDate() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('lastDate', "2023-12-05 18:43:23.159714");
  return "Dose Schedule has been reset";
}

Future<String?> getUserName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? name = prefs.getString('name');
  return name;
}

Future<String?> getUserDesignation() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? name = prefs.getString('designation');
  return name;
}


Future<bool?> matchedUserID(uid) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userID = prefs.getString('userID');
  return userID == uid;
}

String timeRender(timeString) {
  var input = DateTime.parse(timeString);
  input = input.add(Duration(hours: 6));
  var format = DateFormat.jm(); // jm for 12 hour format with AM/PM
  var output = format.format(input);
  return output;
}

String timeRender2(timeString) {
  var input = DateTime.parse(timeString);
  var format = DateFormat.jm(); // jm for 12 hour format with AM/PM
  var output = format.format(input);
  return output;
}

String dateRender2(timeString) {
  var input = DateTime.parse(timeString);
  var format = DateFormat.yMMMd();
  var output = format.format(input);
  return output;
}