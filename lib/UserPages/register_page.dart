import 'package:doc_patient/UserPages/loginPage.dart';
import 'package:doc_patient/components/new_user_footer.dart';
import 'package:doc_patient/global_styles.dart';
import 'package:doc_patient/server_firebase_operations/user_auhtentication.dart';
import 'package:doc_patient/utility_functions.dart';
import 'package:flutter/material.dart';

const List<String> dropDownList = [
  "Client",
  "Telemedicine Officer",
  "Antimicrobial Resistance Database System"
];

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String dropDownValue = dropDownList.first;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String name = "";
    String email = '';
    String userID = "";
    String designation = dropDownValue;
    String password = "";
    String hospitalName = "";
    String department = "";

    // From Here Components Starts

    Widget registrationHeader = Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          Hero(
            tag: "HeroLogo",
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/logo.jpg'),
              radius: 30,
            ),
          )
        ],
      ),
    );

    Widget fieldName = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: "Name"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter your Name";
          } else {
            setState(() {
              name = value;
            });
          }
        },
      ),
    );

    Widget filedEmail = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: "Email"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter your email";
          } else {
            email = value;
          }
        },
      ),
    );

    Widget fieldUserID = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: "Client ID"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter client ID";
          } else {
            userID = value;
          }
        },
      ),
    );

    Widget fieldDesignation = FractionallySizedBox(
      widthFactor: 0.9,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(
                color: Color.fromRGBO(155, 155, 155, 0.5), width: 2)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: const Text("Select a Designation",),
            isExpanded: true,
            value: dropDownValue,
            items: dropDownList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: designationTextStyle,),
              );
            }).toList(),
            onChanged: (String? value) {
              // This is called when the user selects an item.

              setState(() {
                dropDownValue = value!;
                designation = dropDownValue;
              });
            },
          ),
        ),
      ),
    );

    Widget fieldPassword = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Password"),
        validator: (value) {
          String pattern = r'^[a-zA-Z0-9]+$';
          RegExp regex = RegExp(pattern);

          if (value == null || value.isEmpty) {
            // If the field is empty
            return 'Please enter a password';
          } else if (!regex.hasMatch(value)) {
            // If the password does not match the criteria
            return 'Please enter a strong password';
          } else {
            // If the password is valid
            password = value;
          }
        },
      ),
    );

    Widget fieldHospitalName = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Hospital Name"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter Hospital Name";
          } else {
            hospitalName = value;
          }
        },
      ),
    );

    Widget fieldDepartment = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Department"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter department's name";
          } else {
            department = value;
          }
        },
      ),
    );



    Widget buttonSubmit = FractionallySizedBox(
      widthFactor: 0.8,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            var email = "$userID@yahoo.com";
            setState(() {
              isLoading = true;
            });
            createFirebaseUser(email, password, name, userID,
                designation, hospitalName, department)
                .then((value) {
              setState(() {
                isLoading = false;
              });
              if (value == "User Created") {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Center(child: Text(value))));
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Center(child: Text(value))));
              }
            });
          }
        },
        child: Text("Register"),
      ),
    );

    Widget space10 = SizedBox(
      height: 20,
    );
    // From Here Components Ends

    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            registrationHeader,
            space10,
            titleRegistration('Registration'),
            space10,
            Form(
              key: _formKey,
              child: Column(
                children: [
                  fieldName,
                  space10,
                  fieldUserID,
                  space10,
                  // filedEmail,
                  // space10,
                  fieldDesignation,
                  space10,
                  if (dropDownValue == 'Telemedicine Officer')
                    Column(
                      children: [
                        fieldHospitalName,
                        space10,
                        fieldDepartment,
                        space10
                      ],
                    ),
                  fieldPassword,
                  space10,
                  if(isLoading) CircularProgressIndicator(),
                  if(isLoading) space(10),
                  buttonSubmit
                ],
              ),
            ),
            NewUserFooter(
              title: "Login",
            )
          ],
        ),
      ),
    );
  }
}
