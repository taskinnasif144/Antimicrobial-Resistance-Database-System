// ignore_for_file: library_prefixes

import "package:doc_patient/serverSide/socket_connections.dart";
import "package:doc_patient/utility_functions.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:permission_handler/permission_handler.dart';
import "package:doc_patient/homePage/home_button_widgets.dart";
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key, required this.username, required this.designation, required this.userID});

  final String username;
  final String designation;
  final String userID;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    requestPermission();
    setupSocketConnection(widget.userID);
  }

  Future<void> requestPermission() async {
    var status = await Permission.notification.status;
    if (status != PermissionStatus.granted) {
      if(status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted) {
        // openAppSettings();
        //   todo: remove the comment
      }
      Permission.notification.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    // main return function starts from here
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        key: scaffoldKey,
        drawer: drawer(context),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            homePageHeader(context, scaffoldKey),
            Text(
              "Welcome ${widget.username}",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 26,
              ),
            ),
            if (widget.designation == 'Client')
              Column(
                children: [
                  patientHomeButtons("Update Does Schedule", context),
                  patientHomeButtons("View Records", context),
                  patientHomeButtons('See ABR records', context),
                  patientHomeButtons('Client Support', context),
                ],
              ),
            if (widget.designation == "Telemedicine Officer")
              Column(
                children: [
                  doctorHomeButtons('Record', context),
                  doctorHomeButtons('View Records', context),
                  doctorHomeButtons('View ABR Records', context),
                  doctorHomeButtons('Search Records', context),
                ],
              ),
            if (widget.designation == 'Antimicrobial Resistance Database System')
              Column(
                children: [
                  labHomeButtons('Record ABR Result', context),
                  // labHomeButtons('Update', context),
                  labHomeButtons('All ABR', context),
                  labHomeButtons("Survey", context)
                ],
              ),
            SizedBox(),
          ],
        )),
      ),
    );
  }
}
