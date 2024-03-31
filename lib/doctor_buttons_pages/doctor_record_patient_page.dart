import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/records_operations.dart';
import 'package:doc_patient/server_firebase_operations/user_auhtentication.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:quantity_input/quantity_input.dart';

class DoctorRecordPatient extends StatefulWidget {
  const DoctorRecordPatient({super.key});

  @override
  State<DoctorRecordPatient> createState() => _DoctorRecordPatientState();
}

class _DoctorRecordPatientState extends State<DoctorRecordPatient> {
  int medicineCount = 0;
  int antibioticCount = 0;
  bool? isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _userID = TextEditingController();
  final TextEditingController _batch = TextEditingController();
  final TextEditingController _session = TextEditingController();
  final TextEditingController _department = TextEditingController();
  final TextEditingController _disease = TextEditingController();
  final List<MedicineData> _medicineDataList = [];
  final List<TextEditingController>  _controllers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    //custom widgets starts from here

    Widget filedName = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _name,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: "Name"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Patient's name please";
          } else {}
        },
      ),
    );
    Widget filedBatch = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _batch,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: "Batch"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter department's name";
          } else {}
        },
      ),
    );

    Widget filedSession = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _session,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: "Session"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter department's name";
          } else {}
        },
      ),
    );

    Widget filedDepartment = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _department,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Department"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter department's name";
          } else {}
        },
      ),
    );

    Widget filedDisease = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _disease,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: "Disease"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter department's name";
          } else {

          }
        },
      ),
    );


    bool hasRepeatedMedicine(List<Map<String, dynamic>> medicines) {
      var medicineNames = <String>{};
      for (var medicine in medicines) {
        if (medicine['medicineName'] == '' || medicine['quantity'] == 0) {
          return true;
        }
        if (medicineNames.contains(medicine['medicineName'])) {
          return true;
        } else {
          medicineNames.add(medicine['medicineName']);
        }
      }
      return false;
    }


    Widget buttonSubmit = FractionallySizedBox(
      widthFactor: 0.8,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final meds = _medicineDataList.map((medicine) => medicine.toJson()).toList();
            if(hasRepeatedMedicine(meds)){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Center(child: Text("Check the Medicines"))));
            } else {
              getUserID().then((id) {
                createRecord(
                  _userID.text,
                  _name.text,
                  _batch.text,
                  _session.text,
                  _department.text,
                  _disease.text,
                  meds,
                  id,
                ).then((res) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Center(child: Text(res['message']))));
                  Navigator.pop(context);
                });
              });
            }


          }
        },
        child: Text("Save"),
      ),
    );

    Widget userIDTypeAhead = FractionallySizedBox(
      widthFactor: 0.9,
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: _userID,
            autofocus: true,
            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 14),
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Client ID/Client Name")),
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
          setState(() {
            _name.text = suggestion['name'];
            _userID.text = suggestion['userID'];
          });
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

    Widget space(double height) => SizedBox(height: height);
    //
    // dynamic medicine input box
    //
    Widget medicineBoxList = _medicineDataList.isNotEmpty? Column(
      children: _medicineDataList
          .asMap()
          .entries
          .map(
            (entry) => FractionallySizedBox(

              widthFactor: 0.9,
              child: Column(
                children: [
                  TextFormField(
                    controller: _controllers[entry.key],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Medicine Name",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _medicineDataList[entry.key].name = _controllers[entry.key].text;
                      });
                    },
                  ),
                  space(15),
                  QuantityInput(
                    value: entry.value.count,
                    onChanged: (value) {
                      setState(() {
                        entry.value.count =
                            int.parse(value.replaceAll(',', ''));
                      });
                    },
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: CheckboxListTile(
                      value: entry.value.isAntibiotics,
                      activeColor: Colors.purple,
                      title: Text(
                          "${_controllers[entry.key].text.isEmpty ? "Medicine Name" : _controllers[entry.key].text} is Antibiotics"),
                      onChanged: (value) {
                        setState(() {
                          entry.value.isAntibiotics = value!;
                        });
                      },
                    ),
                  ),
                  if (entry.key < _medicineDataList.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _medicineDataList.removeAt(entry.key);
                          _controllers.removeAt(entry.key);
                        });
                      },
                      child: Text("Remove Medicine"),
                    ),
                  space(15),
                ],
              ),
            ),
          )
          .toList(),
    ) : Container();

    Widget addMedicineButton = FractionallySizedBox(
      widthFactor: 0.8,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _medicineDataList
                .add(MedicineData(name: "", count: 0, isAntibiotics: false));
            _controllers.add(TextEditingController());
          });
        },
        child: Text("Add Medicine"),
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            headerComponent(context),
            space(50),
            titleRegistration('Record'),
            space(50),
            userIDTypeAhead,
            space(15),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  filedName,
                  space(15),
                  filedBatch,
                  space(15),
                  filedSession,
                  space(15),
                  filedDepartment,
                  space(15),
                  filedDisease,
                  space(15),
                  space(25),
                  medicineBoxList,
                  addMedicineButton,
                  buttonSubmit,
                  space(45)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
