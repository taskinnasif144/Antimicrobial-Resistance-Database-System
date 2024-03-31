// ignore_for_file: library_prefixes


import "package:doc_patient/main.dart";
import "package:doc_patient/state_management/notification_model.dart";
import 'package:flutter_app_badger/flutter_app_badger.dart';
import "package:provider/provider.dart";
import 'package:socket_io_client/socket_io_client.dart' as IO;
import "package:doc_patient/notification_file.dart";
import "package:doc_patient/serverSide/user.dart";
import "package:doc_patient/utility_functions.dart";

IO.Socket? socket;


void setupSocketConnection(userID) {

  socket = IO.io(serverURL, <String, dynamic>{
    'transports': ['websocket'],
    'force new connection': true,
    'query': {
      'userID': userID,
    }
  });

  socket!.connect();

  socket!.on('connect', (_) {
    print('connected');
  });
  socket!.on('disconnect', (_) {
    print('disconnected');
  });

  socket!.on('notification', (data) {
    matchedUserID(data['userID']).then((value) async {
      if (value == null) {
      } else {
        if (value) {
          Provider.of<NotificationModel>(MyApp.navigatorKey.currentContext!, listen: false).setNotification(true);
          FlutterAppBadger.updateBadgeCount(1);
          await NotificationService().showNotifications(180, data);
          await NotificationService().scheduleNotifications(
              0, 12, 00, data['daysToContinue'], "Have you taken your dose?");
        }
      }
    });
  });
  socket!.on('Appointment', (data) {
    matchedUserID(data['userID']).then((value) async {
      if (value == null) {
      } else {
        if (value) {
          Provider.of<NotificationModel>(MyApp.navigatorKey.currentContext!, listen: false).setNotification(true);
          FlutterAppBadger.updateBadgeCount(1);
          await NotificationService().showNotifications(360, data);
          await NotificationService().scheduleAppointment(760, 12, 00,
              data['daysToContinue'], "You have an appointment today");
        }
      }
    });
  });
}

void disconnectSocket() {
  socket!.disconnect();
}
