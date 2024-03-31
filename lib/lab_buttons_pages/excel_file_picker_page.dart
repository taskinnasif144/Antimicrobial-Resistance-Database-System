import 'package:doc_patient/lab_buttons_pages/excel_storage_page.dart';
import 'package:doc_patient/serverSide/file_upload_functions.dart';
import 'package:doc_patient/server_firebase_operations/file_operations.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ExcelFilePickerPage extends StatefulWidget {
  const ExcelFilePickerPage({super.key});

  @override
  State<ExcelFilePickerPage> createState() => _ExcelFilePickerPageState();
}

class _ExcelFilePickerPageState extends State<ExcelFilePickerPage> {
  PlatformFile? file;
  String? fileName;
  String? filePath;
  bool loadIndicator = false;

  void getFilePath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = result.files.first;
        fileName = file!.name;
        filePath = file!.path;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    String showSize(s) {
      double size = s / (1024 * 1024);
      String str = "MB";
      if (size < 1) {
        size = s / 1024;
        str = "KB";
      }
      return "${size.toStringAsFixed(2)} $str";
    }

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            headerComponent(context),
            file != null
                ? ListTile(
                    title: Text(file!.name),
                    subtitle: Text(showSize(file!.size)),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          file = null;
                        });
                      },
                    ),
                  )
                : Container(),
            if (loadIndicator) CircularProgressIndicator(),
            space(20),
            file != null && fileName != null && filePath != null
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loadIndicator = true;
                      });
                      uploadFile(filePath!, fileName!).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Center(child: Text(value))));
                        setState(() {
                          loadIndicator = false;
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExcelStoragePage()),
                        );
                      });
                    },
                    child: Text("Upload File"))
                : ElevatedButton(
                    onPressed: () {
                      getFilePath();
                    },
                    child: Text("pick a file"))
          ],
        ),
      ),
    ));
  }
}
