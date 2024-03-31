import 'package:doc_patient/serverSide/appointment.dart';
import 'package:doc_patient/server_firebase_operations/appointment_operation.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';

class ProfileAppointment extends StatefulWidget {
  const ProfileAppointment({super.key, required this.isPatient});

  final bool isPatient;

  @override
  State<ProfileAppointment> createState() => _ProfileAppointmentState();
}

class _ProfileAppointmentState extends State<ProfileAppointment> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something Went Wrong"),
            );
          } else if(snapshot.data!.isEmpty){
            return Center(
              child: Text("No upcoming Appointments"),
            );
          }
          else {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // number of items in each row
                  mainAxisSpacing: 18.0, // spacing between rows
                  crossAxisSpacing: 18.0, // spacing between columns
                ),
                padding: EdgeInsets.all(8.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {

                  DateTime appointmentDate = DateTime.parse(snapshot.data![index]['data']['date']);
                  DateTime currentDate = DateTime.now();


                  return GestureDetector(
                    onLongPress: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text('Are you sure you want to delete?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () {
                                  deleteAppointment(snapshot.data![index]['_id']).then((value) {
                                    setState(() {

                                    });

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Center(child: Text(value))));
                                    Navigator.pop(context);
                                  });

                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                          // color: currentDate.isAfter(appointmentDate)?Colors.red: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple,
                          ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.isPatient
                                ? "Dr. ${snapshot.data![index]['data']['doctorName']}"
                                : "${snapshot.data![index]['data']['patientName']}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                fontFamily: "Inter"),
                          ),
                          space(20),
                          Text(
                            dateRender2(snapshot.data![index]['data']['date']),
                            style: TextStyle(fontFamily: "Inter", fontSize: 14),
                          ),
                          space(10),
                          Text(timeRender2(snapshot.data![index]['data']['date']),
                              style:
                              TextStyle(fontFamily: "Inter", fontSize: 14)),
                        ],
                      ),
                    ),
                  );

                });
          }
        });
  }
}
