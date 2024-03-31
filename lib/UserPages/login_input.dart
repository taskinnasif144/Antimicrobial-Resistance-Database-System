import 'package:doc_patient/homePage/home_page.dart';
import 'package:doc_patient/server_firebase_operations/user_auhtentication.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginInput extends StatefulWidget {
  const LoginInput({super.key});

  @override
  State<LoginInput> createState() => _UserInputState();
}

class _UserInputState extends State<LoginInput> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String userID = '';
    String password = '';

    void saveUserInfo(json) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', json['token']);
      await prefs.setString('userID', json['userData']["userID"]);
      await prefs.setString('name', json['userData']['name']);
      await prefs.setString('designation', json['userData']['designation']);
    }

    Widget loginHeader = Padding(
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

    Widget titleLogin = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "Login",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
        ),
      ],
    );

    Widget fieldUserID = FractionallySizedBox(
      widthFactor: 0.9,
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: "Client ID"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter your Client ID";
          } else {
            userID = value;
          }
        },
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
            password = value;
          }
        },
      ),
    );

    Widget buttonSubmit = FractionallySizedBox(
      widthFactor: 0.8,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
            });
            var userEmail = "$userID@yahoo.com";
            firebaseLoginUser(userEmail, password).then((value) {
              setState(() {
                isLoading = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Center(child: Text(value['message']))));
              if (value['message'] == "User Authorized") {
                saveUserInfo(value);
                Future.delayed(Duration(milliseconds: 300), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                            username: value['userData']['name'],
                            designation: value['userData']['designation'],
                            userID: value['userData']['userID'],
                          )),
                          (Route<dynamic> route) => false);
                });

              }
            });
          }
        },
        child: Text("Login"),
      ),
    );

    Widget space10 = SizedBox(
      height: 20,
    );

    Widget space(double num) => SizedBox(
          height: num,
        );

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            loginHeader,
            Form(
              key: _formKey,
              child: Column(
                children: [
                  titleLogin,
                  space(50),
                  fieldUserID,
                  space10,
                  fieldPassword,
                  space10,
                  if (isLoading) CircularProgressIndicator(),
                  if (isLoading) space10,
                  buttonSubmit
                ],
              ),
            ),
            space10
          ],
        ),
      ),
    );
  }
}
