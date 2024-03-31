import 'dart:io';
import 'package:doc_patient/server_firebase_operations/file_operations.dart';
import 'package:open_file/open_file.dart';
import 'package:doc_patient/lab_buttons_pages/excel_file_picker_page.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class ExcelStoragePage extends StatefulWidget {
  const ExcelStoragePage({super.key});

  @override
  State<ExcelStoragePage> createState() => _ExcelStoragePageState();
}

class _ExcelStoragePageState extends State<ExcelStoragePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Column(
            children: [
              headerComponent(context),
              Expanded(
                  child: FutureBuilder(
                future: getUploadedFiles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("${snapshot.error}"),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.access_time_outlined),
                        ],
                      )
                    );
                  }
                  if (snapshot.data!["files"].length == 0) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('No Files uploaded'),
                          Icon(Icons.hourglass_empty)
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!['files'].length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Delete'),
                                  content:
                                      Text('Are you sure you want to delete?'),
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
                                        //todo implement delete feature
                                        deleteUploadedFile(snapshot
                                                .data!['files'][index]['_id'])
                                            .then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Center(
                                                      child: Text(value))));

                                          deleteFileFromFirebase(
                                              snapshot.data!['files'][index]
                                                  ['file']['fileUrl']);
                                        });

                                        Future.delayed(
                                            Duration(milliseconds: 750), () {
                                          if (mounted) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExcelStoragePage()),
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: ListTile(
                            onTap: () {
                              downloadFile(
                                  snapshot.data!['files'][index]['file']
                                      ['fileName'],
                                  snapshot.data!['files'][index]['file']
                                      ['fileUrl'],
                                  context);
                            },
                            leading: CircleAvatar(
                              child: Image.asset('assets/exel.png'),
                            ),
                            title: Text(snapshot.data!['files'][index]['file']
                                ['fileName']),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(renderDate(snapshot.data!['files'][index]
                                    ['file']['createdAt'])),
                                Text(renderTime(snapshot.data!['files'][index]
                                    ['file']['createdAt']))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              )),
            ],
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExcelFilePickerPage()));
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      )),
    );
  }

  Future<void> requestPermission() async {
    var status = await Permission.manageExternalStorage.status;
    if (status != PermissionStatus.granted) {
      Permission.manageExternalStorage.request();
    }
  }

  Future<void> downloadFile(name, url, context) async {
    final ref = FirebaseStorage.instance.refFromURL(url);

    requestPermission();
    String path = "/storage/emulated/0/DocPatient";
    final directory = Directory(path);

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final tempFile = File('$path/$name');

    try {
      await ref.writeToFile(tempFile);
      await tempFile.create();
      await OpenFile.open(tempFile.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: Text("file Downloading Failed"))));
    }
  }

  Future<void> deleteFileFromFirebase(url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
  }
}

//

//
