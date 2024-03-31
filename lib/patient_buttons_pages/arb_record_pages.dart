import 'package:doc_patient/patient_buttons_pages/partient_arb_report_details.dart';
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/records_operations.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';

class PatientARBRecords extends StatefulWidget {
  const PatientARBRecords({super.key});

  @override
  State<PatientARBRecords> createState() => _PatientARBRecordsState();
}

class _PatientARBRecordsState extends State<PatientARBRecords> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          headerComponent(context),
          space(40),
          titleRegistration("ABR Reports"),
          space(40),
          Expanded(
            child: FutureBuilder(
                future: getAllUserARBRecords(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("SomeThing Went Wrong"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PatientARBDetails(
                                        id: snapshot.data![index]
                                            ['_id'])));
                          },
                          title: Text(snapshot.data![index]['data']['name']),
                          subtitle:
                              Text(snapshot.data![index]['data']['userID']),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(renderDate(snapshot.data![index]['data']
                                  ['createdAt'])),
                              Text(renderTime(snapshot.data![index]['data']
                                  ['createdAt'])),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }),
          )
        ],
      )),
    );
  }
}
