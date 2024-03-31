import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/records_operations.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';

class DoctorViewPatientRecordsDetails extends StatefulWidget {
  const DoctorViewPatientRecordsDetails({super.key, required this.patientID});

  final String patientID;

  @override
  State<DoctorViewPatientRecordsDetails> createState() =>
      _DoctorViewPatientRecordsDetailsState();
}

class _DoctorViewPatientRecordsDetailsState
    extends State<DoctorViewPatientRecordsDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
        future: getSinglePatientRecords(widget.patientID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error ${snapshot.error}"),
            );
          } else {
            return Column(
              children: [
                headerComponent(context),
                space(40),
                titleRegistration(snapshot.data!['patientName']),
                space(20),
                subTitleRegistration(snapshot.data!['patientUserID']),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        patientRecordDataFields(
                            "Batch", snapshot.data!['batch'].toString()),
                        patientRecordDataFields(
                            "Session", snapshot.data!['session'].toString()),
                        patientRecordDataFields(
                            "Department", snapshot.data!['department'].toString()),
                        patientRecordDataFields(
                            "Disease", snapshot.data!['disease'].toString()),
                        patientRecordMedicineTableHeader(
                            "Medicine Names", "Days to Continue"),
                        ...snapshot.data!['medicines'].map((e) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                              child: patientRecordDataFields(
                                  e['medicineName'], e["quantity"].toString()));
                        }).toList(),
                        patientRecordDataFields(
                            "Telemedicine Officer ID", snapshot.data!['doctorID']),
                        patientRecordDataFields(
                            "Date&Time", renderDate(snapshot.data!['createdAt'])),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      )),
    );
  }
}
