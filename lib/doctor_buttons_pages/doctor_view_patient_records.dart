import 'package:doc_patient/doctor_buttons_pages/doctor_view_patient_records_details.dart';
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/records_operations.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';

class DoctorViewPatientRecords extends StatefulWidget {
  const DoctorViewPatientRecords({super.key});

  @override
  State<DoctorViewPatientRecords> createState() =>
      _DoctorViewPatientRecordsState();
}

class _DoctorViewPatientRecordsState extends State<DoctorViewPatientRecords> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          headerComponent(context),
          space(40),
          titleRegistration('View Records'),
          space(40),
          Expanded(
            child: FutureBuilder(
                future: getPatientRecords(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Something Went Wrong !"),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: ValueKey<String>(snapshot.data![index]
                            ['_id'],),
                            onDismissed: (DismissDirection direction) {
                              deleteRecord(snapshot.data![index]
                              ['_id']);
                            },
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DoctorViewPatientRecordsDetails(
                                              patientID: snapshot.data![index]
                                                  ['_id'],
                                            )));
                              },
                              selectedTileColor: Colors.orange[100],

                              title:
                                  Text('${snapshot.data![index]["data"]['patientName']}'),
                              subtitle: Text(
                                  '${snapshot.data![index]["data"]['patientUserID']}'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(renderDate(
                                      snapshot.data![index]["data"]['createdAt'])),
                                  Text(renderTime(
                                      snapshot.data![index]["data"]['createdAt'])),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }),
          )
        ],
      )),
    );
  }
}
