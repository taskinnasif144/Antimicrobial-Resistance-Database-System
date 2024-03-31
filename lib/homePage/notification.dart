import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/notification_operations.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          headerComponent(context),
          space(20),
          titleRegistration('Notifications'),
          space(20),
          Expanded(
            child: FutureBuilder(
              future: getNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error ${snapshot.error}"),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(child: Text("No notifications to display"),);
                }

                else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: ValueKey<String>(
                              snapshot.data![index]['_id']),
                          onDismissed: (DismissDirection direction) async {
                            await deleteNotification(
                                snapshot.data![index]['_id']);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Color(0xFF304D30).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5)),
                            child: ListTile(
                              title: Text(snapshot.data![index]
                                      ['data']['data'] ??
                                  "inset"),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(renderDate(snapshot.data![index]['data']['createdAt'])),
                                  Text(renderTime(snapshot.data![index]['data']['createdAt']))
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}
