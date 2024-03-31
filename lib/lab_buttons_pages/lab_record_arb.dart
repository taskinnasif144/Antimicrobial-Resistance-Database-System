import 'package:doc_patient/serverSide/user.dart';
import 'package:doc_patient/server_firebase_operations/records_operations.dart';
import 'package:doc_patient/server_firebase_operations/user_auhtentication.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class LabRecordARBResult extends StatefulWidget {
  const LabRecordARBResult({super.key});

  @override
  State<LabRecordARBResult> createState() => _LabRecordARBResultState();
}

class _LabRecordARBResultState extends State<LabRecordARBResult> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _userID = TextEditingController();
  final TextEditingController _amoxycillin = TextEditingController();
  final TextEditingController _azithromycin = TextEditingController();
  final TextEditingController _cefotaxime = TextEditingController();
  final TextEditingController _chloramphenicol = TextEditingController();
  final TextEditingController _doxycycline = TextEditingController();
  final TextEditingController _imipenem = TextEditingController();
  final TextEditingController _levofloxacin = TextEditingController();
  final TextEditingController _meropenem = TextEditingController();
  final TextEditingController _netilmicin = TextEditingController();
  final TextEditingController _nitrofurantoin = TextEditingController();
  final TextEditingController _piperacilin = TextEditingController();
  final TextEditingController _fosfomycin = TextEditingController();
  final TextEditingController _ciprocin = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget userNameTypeAhead = FractionallySizedBox(
      widthFactor: 0.9,
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: _name,
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

    Widget filedUserID = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _userID,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: "UserID"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Client's ID please";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedAmoxycillin = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _amoxycillin,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Amoxycillin"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Amoxycillin please";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedAzithromycin = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _azithromycin,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Azithromycin"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Azithromycin please";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedCefotaxime = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _cefotaxime,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Cefotaxime"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Cefotaxime";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedChloramphenicol = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _chloramphenicol,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Chloramphenicol"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Chloramphenicol";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedDoxycycline = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _doxycycline,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Doxycycline"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Doxycycline";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedImipenem = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _imipenem,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Imipenem"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Imipenem";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedLevofloxacin = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _levofloxacin,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Levofloxacin"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Levofloxacin";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedMeropenem = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _meropenem,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Meropenem"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Meropenem";
          } else {
            return null;
          }
        },
      ),
    );
    Widget fieldNetilmicin = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _netilmicin,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Netilmicin"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Netilmicin";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedNitrofurantoin = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _nitrofurantoin,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Nitrofurantoin"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Nitrofurantoin";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedPiperacilin = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _piperacilin,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Piperacilin-Tazobactam"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Piperacilin-Tazobactam";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedFosfomycin = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _fosfomycin,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Fosfomycin"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Fosfomycin";
          } else {
            return null;
          }
        },
      ),
    );
    Widget filedCiprocin = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        controller: _ciprocin,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Ciprocin"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Ciprocin";
          } else {
            return null;
          }
        },
      ),
    );

    Widget buttonSubmit = FractionallySizedBox(
      widthFactor: 0.8,
      child: ElevatedButton(
        onPressed: () {
          Scrollable.ensureVisible(_formKey.currentContext!);
          if (_formKey.currentState!.validate()) {
            createARBRecord(
                _name.text,
                _userID.text,
                _amoxycillin.text,
                _azithromycin.text,
                _cefotaxime.text,
                _chloramphenicol.text,
                _doxycycline.text,
                _imipenem.text,
                _levofloxacin.text,
                _meropenem.text,
                _netilmicin.text,
                _nitrofurantoin.text,
                _piperacilin.text,
                _fosfomycin.text,
                _ciprocin.text)
                .then((res) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Center(child: Text(res['message']))));
              Navigator.pop(context);
            });
          }
        },
        child: Text("Save"),
      ),
    );

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
        children: [
            space(10),
            headerComponent(context),
            space(30),
            titleRegistration('Record ABR Result'),
            space(30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  userNameTypeAhead,
                  space(15),
                  filedUserID,
                  space(15),
                  filedAmoxycillin,
                  space(15),
                  filedAzithromycin,
                  space(15),
                  filedCefotaxime,
                  space(15),
                  filedChloramphenicol,
                  space(15),
                  filedDoxycycline,
                  space(15),
                  filedImipenem,
                  space(15),
                  filedLevofloxacin,
                  space(15),
                  filedMeropenem,
                  space(15),
                  fieldNetilmicin,
                  space(15),
                  filedNitrofurantoin,
                  space(15),
                  filedPiperacilin,
                  space(15),
                  filedFosfomycin,
                  space(15),
                  filedCiprocin,
                  space(40),
                  buttonSubmit,
                  space(50),
                ],
              ),
            )
        ],
      ),
          )),
    );
  }
}
