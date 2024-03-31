import 'package:doc_patient/components/app_theme_data.dart';
import 'package:doc_patient/homePage/home_page.dart';
import 'package:doc_patient/notification_file.dart';
import 'package:doc_patient/state_management/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserPages/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService().init(); //
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(
     ChangeNotifierProvider(create: (context)=> NotificationModel(), child: const MyApp(),)
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final navigatorKey =  GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  Future<Map<String, dynamic>> _tokenExists() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? name = prefs.getString('name');
    final String? designation = prefs.getString('designation');
    final String? userID = prefs.getString('userID');
    if (token == null || token.isEmpty) {
      return {'name': name, 'hasToken': false, 'designation':designation, "userID":userID };
    }
    return {'name': name, 'hasToken': true, 'designation': designation, "userID":userID};
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: purpleTheme,

        home: FutureBuilder<Map<String, dynamic>>(
        future: _tokenExists(),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center( child: CircularProgressIndicator(),);
          } else {
            if(snapshot.hasError) {
              return  Center(child: Text('Error: ${snapshot.error}'),);
            } else {
              return snapshot.data!['hasToken']? HomePage(username: snapshot.data!['name'], designation:snapshot.data!['designation'] ,userID: snapshot.data!['userID'],) : const SafeArea(child: Welcome());
            }
          }
        },
      )
    );
  }
}


