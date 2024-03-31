import 'package:doc_patient/doctor_buttons_pages/doctor_record_patient_page.dart';
import 'package:doc_patient/doctor_buttons_pages/doctor_search_patient_records.dart';
import 'package:doc_patient/doctor_buttons_pages/doctor_view_patient_records.dart';
import 'package:doc_patient/doctor_buttons_pages/view_arb_records.dart';
import 'package:doc_patient/homePage/notification.dart';
import 'package:doc_patient/homePage/profile_page.dart';
import 'package:doc_patient/lab_buttons_pages/excel_storage_page.dart';
import 'package:doc_patient/lab_buttons_pages/lab_delete_arb.dart';
import 'package:doc_patient/lab_buttons_pages/lab_record_arb.dart';
import 'package:doc_patient/lab_buttons_pages/lab_update_arb.dart';
import 'package:doc_patient/patient_buttons_pages/arb_record_pages.dart';
import 'package:doc_patient/patient_buttons_pages/patient_book_appointment_page.dart';
import 'package:doc_patient/patient_buttons_pages/patient_update_dose_page.dart';
import 'package:doc_patient/patient_buttons_pages/patient_view_records_page.dart';
import 'package:doc_patient/serverSide/socket_connections.dart';
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/state_management/notification_model.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:doc_patient/homePage/home_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';


Widget notificationButton(context) =>  Consumer<NotificationModel>(builder: (context, value, child ){
  return IconButton(
    icon: Stack(
      children:  [
        Icon(Icons.notifications),
        if (value.hasNotification)
          Positioned(
            top: -1.0,
            right: 2.0,
            child: Container(
              width: 9.0, // Adjust size as needed
              height: 9.0, // Adjust size as needed
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
      ],
    ),
    onPressed: () {
      Provider.of<NotificationModel>(context, listen: false).setNotification(false);
      FlutterAppBadger.removeBadge();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NotificationPage()));
    },
  );
});

Widget drawer(context) => Drawer(
  backgroundColor: Theme.of(context).primaryColor,
  child: FutureBuilder(
    future: getUserDesignation(),
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting) {
        return SingleChildScrollView(child: CircularProgressIndicator(),);
      } else if (snapshot.hasError) {
        return Text('');
      }

      else {
        return ListView(
          children: [
            Container(
              height: 100,
            ),
            if(snapshot.data == "Client" || snapshot.data == "Telemedicine Officer")
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyProfile(isDoctor: false)));
              },
            ),
            if(snapshot.data == "Client")
              Column(
                children: [
                  ListTile(
                    title: const Text('Update Dose Schedule'),
                    onTap: ()  {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PatientUpdateDose()));
                    },
                  ),
                  ListTile(
                    title: const Text('Reset Schedule'),
                    onTap: ()  {
                      resetDoseScheduleDate().then((value) =>  ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Center(child: Text(value)))));
                    },
                  ),
                  ListTile(
                    title: const Text('View Records'),
                    onTap: ()  {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PatientViewRecordsPage()));
                    },
                  ),
                  ListTile(
                    title: const Text('See ABR Records'),
                    onTap: ()  {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientARBRecords()));
                    },
                  ),
                  ListTile(
                    title: const Text('Client Support'),
                    onTap: ()  {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientBookAppointmentPage()));
                    },
                  ),
                ],
              ),

            if(snapshot.data == "Telemedicine Officer")
              Column(
                children: [
                  ListTile(
                    title: const Text('Record'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorRecordPatient()));
                    },
                  ),
                  ListTile(
                    title: const Text('View Patient Record'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorViewPatientRecords()));
                    },
                  ),
                  ListTile(
                    title: const Text('View ABR Records'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorViewARBReports()));
                    },
                  ),
                  ListTile(
                    title: const Text('Search Records'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorSearchPatientRecords()));
                    },
                  ),
                ],
              ),
            if(snapshot.data == "Antimicrobial Resistance Database System")
              Column(
                children: [
                  ListTile(
                    title: const Text('Record ABR Result'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LabRecordARBResult()));
                    },
                  ),
                  ListTile(
                    title: const Text('All ABR'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LabDeleteARBResult()));
                    },
                  ),
                ],
              ),



            ListTile(
              title: const Text('Logout'),
              onTap: () {
               disconnectSocket();
                logoutUser(context);
              },
            ),
          ],
        );
      }
    },
  )
);

Widget homePageHeader(context, scaffoldKey) => Padding(
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
       notificationButton(context),
      ],
    ));



Widget patientHomeButtons(String title, context) => FractionallySizedBox(
  widthFactor: 0.8,
  child: ElevatedButton(
    // style: ButtonStyle(
    //   backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    //   shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
    //   elevation: MaterialStateProperty.all(5),
    //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //     RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //     ),
    //   ),
    // ),
    onPressed: () {
      if (title == 'Update Does Schedule') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientUpdateDose()));
      } else if (title == "View Records") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientViewRecordsPage()));
      } else if (title == 'Client Support') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientBookAppointmentPage()));
      }  else if (title == 'See ABR records') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientARBRecords()));
      }
    },
    child: Text(title,),
  ),
);

Widget doctorHomeButtons(String title, context) => FractionallySizedBox(
  widthFactor: 0.8,
  child: ElevatedButton(
    // style: ButtonStyle(
    //   backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    //   shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
    //   elevation: MaterialStateProperty.all(5),
    //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //     RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //     ),
    //   ),
    // ),
    onPressed: () {
      if (title == 'Record') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorRecordPatient()));
      } else if (title == "View Records") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorViewPatientRecords()));
      } else if (title == 'Search Records') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorSearchPatientRecords()));

      }
      else if (title == 'View ABR Records') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorViewARBReports()));
      }
    },
    child: Text(title,),
  ),
);

Widget labHomeButtons(String title, context) => FractionallySizedBox(
  widthFactor: 0.8,
  child: ElevatedButton(
    // style: ButtonStyle(
    //   backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    //   shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
    //   elevation: MaterialStateProperty.all(5),
    //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //     RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //     ),
    //   ),
    // ),
    onPressed: () {
      if (title == 'Record ABR Result') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LabRecordARBResult()));
      } else if (title == "Update") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LabUpdateARBResult()));
      } else if (title == 'All ABR') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LabDeleteARBResult()));
      } else if(title == 'Survey'){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ExcelStoragePage()));
      }
    },
    child: Text(title),
  ),
);
