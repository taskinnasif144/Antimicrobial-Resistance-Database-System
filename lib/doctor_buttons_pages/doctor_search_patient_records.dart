
import 'package:doc_patient/doctor_buttons_pages/reports_search_list.dart';
import 'package:doc_patient/server_firebase_operations/user_auhtentication.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DoctorSearchPatientRecords extends StatefulWidget {
  const DoctorSearchPatientRecords({super.key});

  @override
  State<DoctorSearchPatientRecords> createState() =>
      _DoctorSearchPatientRecordsState();
}

class _DoctorSearchPatientRecordsState
    extends State<DoctorSearchPatientRecords> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // type ahead
    Widget userIDTypeAhead = FractionallySizedBox(
      widthFactor: 0.9,
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: _controller,
            autofocus: true,
            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14),
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                border: UnderlineInputBorder(),
                labelText: "Search")),
        suggestionsCallback: (pattern) =>
            BackendService.getSuggestions(pattern),
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(suggestion['name']! ?? "inset"),
            subtitle: Text(suggestion['userID']! ?? 0),
          );
        },
        onSuggestionSelected: (suggestion) {
          _controller.text = suggestion['name'];
        },
        noItemsFoundBuilder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'No matches found',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      ),
    );
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          headerComponent(context),
          space(30),
          titleRegistration("Search Records"),
          userIDTypeAhead,
          space(5),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchedReportList(name: _controller.text)));
              },
              child: Text("Search"),
            ),
          )
        ],
      )),
    );
  }
}
