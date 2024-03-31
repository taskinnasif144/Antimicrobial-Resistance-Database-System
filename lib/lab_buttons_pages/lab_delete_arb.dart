import 'package:doc_patient/components/pdf_btn_fn.dart';

import 'package:doc_patient/patient_buttons_pages/partient_arb_report_details.dart';
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/records_operations.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';

class LabDeleteARBResult extends StatefulWidget {
  const LabDeleteARBResult({super.key});

  @override
  State<LabDeleteARBResult> createState() => _LabDeleteARBResultState();
}

class _LabDeleteARBResultState extends State<LabDeleteARBResult> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            headerComponent(context),
            space(20),
            titleRegistration("All ABR Reports"),
            space(20),
            Expanded(
              child: FutureBuilder(
                future: getAllARBRecords(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: ValueKey<String>(snapshot.data![index]["_id"]),
                          onDismissed: (DismissDirection direction) async {
                            await deleteArb(snapshot.data![index]["_id"])
                                .then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Center(
                                          child: Text(
                               value,
                              ))));
                            });
                          },
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientARBDetails(
                                      id: snapshot.data![index]["_id"]),
                                ),
                              );
                            },

                            title: Text(snapshot.data![index]["data"]["name"]),
                            subtitle: Text(snapshot.data![index]["data"]["userID"]),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(renderDate(
                                    snapshot.data![index]["data"]['createdAt'])),
                                Text(renderTime(
                                    snapshot.data![index]["data"]['createdAt'])),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                  }
                },
              ),

            ),
            DownloadPDF(),
            space(40),
          ],
        ),
      ),
    );
  }
}
