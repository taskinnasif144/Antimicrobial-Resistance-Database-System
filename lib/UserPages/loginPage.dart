import 'package:doc_patient/UserPages/login_input.dart';
import 'package:flutter/material.dart';
import '../components/new_user_footer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {


    Widget loginPageButton(String title) => FractionallySizedBox(
          widthFactor: 0.8,
          child: ElevatedButton(
            // style: ButtonStyle(
            //   backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            //   shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
            //   elevation: MaterialStateProperty.all(5),
            //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //     RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            //   ),
            // ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginInput()));
            },
            child: Text(title),
          ),
        );


    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Hero(
                    tag: "HeroLogo",
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/logo.jpg'),
                      radius: 60,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  loginPageButton('Telemedicine Officer'),
                  loginPageButton('Client'),
                  loginPageButton('Antimicrobial Resistance Database System'),
                ],
              ),
              NewUserFooter(title: "Register")
            ],
          ),
        ),
      ),
    );
  }
}
