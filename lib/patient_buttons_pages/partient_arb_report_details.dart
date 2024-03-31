import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/records_operations.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';

class PatientARBDetails extends StatefulWidget {
  final String id;
  const PatientARBDetails({super.key, required this.id});


  @override
  State<PatientARBDetails> createState() => _PatientARBDetailsState();
}

class _PatientARBDetailsState extends State<PatientARBDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(
        children: [
          headerComponent(context),
          space(30),
          Expanded(
            child: FutureBuilder(
              future: getSngleARBReport(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                }
                else if (snapshot.hasError) {
                  return Center(child:  Text('This is an error ${snapshot.hasError}'),);
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        titleRegistration(snapshot.data!['name']),
                        space(20),
                        subTitleRegistration(snapshot.data!['userID']),
                      space(20),
                        patientRecordDataFields(
                            "amoxycillin", snapshot.data!['amoxycillin'].toString()),
                        patientRecordDataFields(
                            "azithromycin", snapshot.data!['azithromycin'].toString()),
                        patientRecordDataFields(
                            "cefotaxime", snapshot.data!['cefotaxime'].toString()),
                        patientRecordDataFields(
                            "chloramphenicol", snapshot.data!['chloramphenicol'].toString()),
                        patientRecordDataFields(
                            "doxycycline", snapshot.data!['doxycycline'].toString()),
                        patientRecordDataFields(
                            "imipenem", snapshot.data!['imipenem'].toString()),
                        patientRecordDataFields(
                            "levofloxacin", snapshot.data!['levofloxacin'].toString()),
                        patientRecordDataFields(
                            "meropenem", snapshot.data!['meropenem'].toString()),
                        patientRecordDataFields(
                            "netilmicin", snapshot.data!['netilmicin'].toString()),
                        patientRecordDataFields(
                            "nitrofurantoin", snapshot.data!['nitrofurantoin'].toString()),
                        patientRecordDataFields(
                            "piperacilin-tazobactam", snapshot.data!['piperacilin'].toString()),
                        patientRecordDataFields(
                            "fosfomycin", snapshot.data!['fosfomycin'].toString()),
                        patientRecordDataFields(
                            "ciprocin", snapshot.data!['ciprocin'].toString()),
                        patientRecordDataFields(
                            "Date&Time", renderDate(snapshot.data!['createdAt'])),
                        
                      ],
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    ));
  }
}
