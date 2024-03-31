import 'package:doc_patient/doctor_buttons_pages/doctor_view_patient_records_details.dart';
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/records_operations.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';

class SearchedReportList extends StatefulWidget {
  const SearchedReportList({super.key, required this.name});

  final String name;

  @override
  State<SearchedReportList> createState() => _SearchedReportListState();
}

class _SearchedReportListState extends State<SearchedReportList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            headerComponent(context),
            space(20),
            titleRegistration("Reports"),
            space(20),
            Expanded(
              child: FutureBuilder(
                future: getNamedPatientRecords(widget.name),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SingleChildScrollView(
                        child: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.error_outline),
                          Text("Something Went Wrong")
                        ],
                      ),
                    );
                  }
                  else if (snapshot.data!.isEmpty){
                    return Center(child: Text('${widget.name} Does not Exist'),);
                  }
                  else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DoctorViewPatientRecordsDetails(
                                            patientID: snapshot.data![index]
                                                ['_id'])));
                          },
                          title: Text(snapshot.data![index]['data']['patientName']),
                          subtitle:
                              Text(snapshot.data![index]['data']['patientUserID']),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(renderDate(
                                  snapshot.data![index]['data']['createdAt'])),
                              Text(renderTime(
                                  snapshot.data![index]['data']['createdAt']))
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
