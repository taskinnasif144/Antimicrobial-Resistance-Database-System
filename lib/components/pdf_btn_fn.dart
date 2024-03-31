import 'package:doc_patient/utility_functions.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:doc_patient/server_firebase_operations/records_operations.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:material_dialogs/material_dialogs.dart';



class DownloadPDF extends StatefulWidget {
  const DownloadPDF({super.key});

  @override
  State<DownloadPDF> createState() => _DownloadPDFState();
}

class _DownloadPDFState extends State<DownloadPDF> {
  @override
  Widget build(BuildContext context) {


    Future<void> requestPermission() async {
      var status = await Permission.manageExternalStorage.status;
      if (status != PermissionStatus.granted) {
        if(status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted) {
          // openAppSettings();
        //   todo: remove the comment
        }
       Permission.manageExternalStorage.request();
      }
    }




    Future<String> pdfOperation(data) async {
      final font = await PdfGoogleFonts.nunitoExtraLight();
      final excel.Workbook workbook = excel.Workbook();
      final excel.Worksheet sheet = workbook.worksheets[0];

      List<String> headers = [ "createdAt", "name","userID", "meropenem", "azithromycin", "piperacilin", "doxycycline", "nitrofurantoin", "amoxycillin", "netilmicin",  "cefotaxime", "levofloxacin", "imipenem",  "chloramphenicol", "ciprocin", "fosfomycin"];
     for(var i = 0; i < headers.length; i++ ){
       var index = i+1;
       sheet.getRangeByIndex(1, index).setText(headers[i]);
     }
      for(var i = 0; i < data.length; i++ ){
        var abrData = data[i]['data'];
        for(var j = 0; j < headers.length; j++ ){
          if(headers[j] == "createdAt" ){
            sheet.getRangeByIndex((i+2), (j+1)).setText(renderDate(abrData[headers[j]]));
          } else {
            sheet.getRangeByIndex((i+2), (j+1)).setText(abrData[headers[j]].toString());
          }
         
        }
      }


      requestPermission();
      final directory = Directory('/storage/emulated/0/Antimicrobial Resistance Database System');

      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final List<int> bytes = workbook.saveAsStream();
      // var fileBytes = excel.save();
      File('/storage/emulated/0/Antimicrobial Resistance Database System/excel.xlsx')..createSync(recursive: true)
        ..writeAsBytesSync(bytes);


      return '/storage/emulated/0/Antimicrobial Resistance Database System/excel.xlsx';
    }

    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
             
              getAllARBRecords().then((value) {
                pdfOperation(value).then((value) {
                  Dialogs.bottomMaterialDialog(
                      msg: 'File saved in $value',
                      title: '',
                      color: Colors.black,
                      context: context,
                      actions: [
                        IconsButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: 'Okay',
                          iconData: Icons.check,
                          color: Colors.blue,
                          textStyle: TextStyle(color: Colors.white),
                          iconColor: Colors.white,
                        ),
                      ]);
                });
              });
            },
            child: Text("Download Data")),
      ],
    );
  }
}
