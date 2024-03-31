import 'package:doc_patient/components/profile_appointments.dart';
import 'package:doc_patient/patient_buttons_pages/fix_appointment.dart';
import 'package:doc_patient/serverSide/appointment.dart';
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/user_auhtentication.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:doc_patient/notification_file.dart';
import 'package:doc_patient/patient_buttons_pages/patient_update_dose_page.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key, required this.isDoctor, this.userID, this.isLab});

  final bool isDoctor;
  final String? userID;
  final bool? isLab;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  DateTime scheduleTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Future<bool> isPatient() async {
      var designation = await getUserDesignation();
      if(designation == "Client"){
        return true;
      } else {
        return false;
      }
    }

    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
        future:
            widget.isDoctor ? getUserDetails(widget.userID) : getSingleUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${widget.userID} Does not Exist'),
            );
          }
          else if (snapshot.data!.isEmpty){
            return Center(child: Text('${widget.userID} Does not Exist'),);
          }
          else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                          Color(0xFF401F71), // Your first color
                          Color(0xFF6420AA), // Your second color
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      )),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 10,
                          top: 20,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF836FFF).withOpacity(0.3),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -10,
                          bottom: 5,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF7AA2E3).withOpacity(0.3),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${snapshot.data!['data']['name']}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                            Text(
                              "${snapshot.data!['data']['userID']}",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 20),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                if (widget.isDoctor)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            ListTile(
                              title: Text("designation"),
                              trailing:
                                  Text("${snapshot.data!['data']['designation']}"),
                            ),
                            ListTile(
                              title: Text("Hospital Name"),
                              trailing:
                                  Text("${snapshot.data!['data']['hospitalName']}"),
                            ),
                            ListTile(
                              title: Text("Department"),
                              trailing: Text("${snapshot.data!['data']['departmentName']}"),
                            ),
                          ],
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.9,
                          child: ElevatedButton(
                            child: Text("Request Client Support"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FixAppointment(json: snapshot.data!)),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                if (!widget.isDoctor)
                Expanded(
                  child: FutureBuilder(
                    future: getUserDesignation(),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return SingleChildScrollView(child: CircularProgressIndicator(),);
                      } else {
                        if(snapshot.data == "Antimicrobial Resistance Database System"){
                          return Text("");
                        } else {
                          return Column(
                            children: [
                              space(10),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Text("Your Appointments", style: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.bold, fontSize: 20),)),
                              Expanded(
                                  child: FutureBuilder(
                                    future: isPatient(),
                                    builder: (context,snapshot){
                                      if(snapshot.connectionState == ConnectionState.waiting) {
                                        return SingleChildScrollView(child: CircularProgressIndicator());
                                      } else {
                                        return ProfileAppointment(isPatient: snapshot.data!,);
                                      }
                                    },
                                  )

                              ),


                            ],
                          );
                        }
                      }
                    },
                  )
                )
               

              ],
            );
          }
        },
      )),
    );
  }
}
