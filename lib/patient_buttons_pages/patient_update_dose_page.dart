import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/records_operations.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientUpdateDose extends StatefulWidget {

  const PatientUpdateDose({super.key});

  @override
  State<PatientUpdateDose> createState() => _UpdateDosePageState();
}

class _UpdateDosePageState extends State<PatientUpdateDose> {
  bool renderPage = false;
  Map<String, dynamic>? nextDateRender;

  @override
  void initState() {
    super.initState();
    nextDate().then((value) => nextDateRender = value);
    checkActiveStatus().then((value) {
      if (value) {
        _loadMedicationStatus();
      }
    });
  }

  void _loadMedicationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? lastDateString = prefs.getString('lastDate');
    DateTime? lastDate;

    if (lastDateString != null && lastDateString.isNotEmpty) {
      lastDate = DateTime.parse(lastDateString);


      if (lastDate.day != DateTime.now().day) {
        setState(() {
          renderPage = true;
        });
      } else {
        setState(() {
          renderPage = false;
        });
      }

    } else {
      setState(() {
        renderPage = true;
      });
    }




    print(renderPage);
  }

  Future<Map<String, dynamic>> nextDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastDateString = prefs.getString('lastDate');
    DateTime? lastDate;

    if (lastDateString != null && lastDateString.isNotEmpty) {
      lastDate = DateTime.parse(lastDateString).add(Duration(days: 1));
      var newDate = lastDate.toString();

      return {"val": true, "date": newDate};
    }
    return {"val": false};
  }

  void _updateMedicationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('lastDate', DateTime.now().toString());
  }

  Future<bool> checkActiveStatus() async {
    try {
      bool active = await isActive();
      return active;
    } catch (err) {
      // Consider showing a dialog to the user here.
      return false;
    }
  }

  void updateState() async {
    await updateDose();
    _updateMedicationStatus();
  }

  @override
  Widget build(BuildContext context) {
    Widget updateDoseWidget = SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            headerComponent(context),
            titleRegistration("Update Dose Schedule"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  titleRegistration(
                      "Have You Completed your Antibiotics Dose?"),
                  ListTile(
                    onTap: () {
                      updateState();
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.done),
                    title: Text("Yes"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.close),
                    title: Text("No"),
                  )
                ],
              ),
            ),
            space(10),
            space(0)
          ],
        ),
      ),
    );

    Widget blankPage = SafeArea(
        child: Scaffold(
            body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "You have no doses left for today",
                textAlign: TextAlign.center,
                textScaleFactor: 1.25,
                style: TextStyle(fontSize: 20),
              )),
          if(nextDateRender != null)
          if(nextDateRender!['val'])
            Text("Next Date ${dateRender2(nextDateRender!['date'])}")
        ],
      ),
    )));
    if (renderPage) {
      return updateDoseWidget;
    } else {
      return blankPage;
    }
  }
}
