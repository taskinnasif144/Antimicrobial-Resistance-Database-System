
import 'package:doc_patient/doctor_buttons_pages/doctor_view_patient_records_details.dart';
import 'package:doc_patient/homePage/profile_page.dart';
import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/user_auhtentication.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PatientBookAppointmentPage extends StatefulWidget {
  const PatientBookAppointmentPage({super.key});

  @override
  State<PatientBookAppointmentPage> createState() =>
      _PatientBookAppointmentPageState();
}

class _PatientBookAppointmentPageState
    extends State<PatientBookAppointmentPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget doctorTypeAhead = FractionallySizedBox(
      widthFactor: 0.9,
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: _controller,
            autofocus: true,
            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14),
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Telemedicine Officer ID/Name")),
        suggestionsCallback: (pattern) {
          return DoctorSuggestions.getSuggestions(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(suggestion['data']['name']! ?? "inset"),
            subtitle: Text(suggestion['data']['userID']! ?? 0),
          );
        },
        onSuggestionSelected: (suggestion) {
          _controller.text = suggestion['data']['userID'];
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              headerComponent(context),
              space(20),
              titleRegistration("Search For Telemedicine Officers"),
            ],
          ),
          Column(
            children: [
              doctorTypeAhead,
              space(5),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfile(
                                isDoctor: true,
                                userID: _controller.text,
                              )),
                    );
                  },
                  child: Text("Search"),
                ),
              )
            ],
          ),
          space(0),
        ],
      )),
    );
  }
}
