import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'register_page.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Hero(
                tag: "HeroLogo",
                child: CircleAvatar(

                  backgroundImage: AssetImage(
                    'assets/logo.jpg',
                  ),
                  radius: 60,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text("Telemedicine Service", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20,
          ),
          FractionallySizedBox(
            widthFactor: 0.8, // 80% of screen width
            child: ElevatedButton(

              // style: OutlinedButton.styleFrom(
              //   backgroundColor: Theme.of(context).primaryColor,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return  LoginPage();
                }));
              },
              child: Text('Login'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FractionallySizedBox(
            widthFactor: 0.8,
            // 80% of screen width
            child: OutlinedButton(
              // style: OutlinedButton.styleFrom(
              //   backgroundColor: Theme.of(context).secondaryHeaderColor,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RegisterPage();
                }));
              },
              child: Text('Register'),
            ),
          ),
        ],
      ),
    );
  }
}

