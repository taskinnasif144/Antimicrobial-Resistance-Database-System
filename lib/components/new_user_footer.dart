import 'package:doc_patient/UserPages/loginPage.dart';
import '../UserPages//register_page.dart';
import 'package:flutter/material.dart';

class NewUserFooter extends StatefulWidget {
  final String title;

  const NewUserFooter({super.key, required this.title});

  @override
  State<NewUserFooter> createState() => _NewUserFooterState();
}

class _NewUserFooterState extends State<NewUserFooter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.title == "Login"
            ? "Already Have an Account?"
            : "Don't have an Account?"),
        TextButton(
          onPressed: () {
            widget.title == "Login"
                ? Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()))
                : Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Text(
            widget.title,
          ),
        ),
      ],
    );
  }
}
