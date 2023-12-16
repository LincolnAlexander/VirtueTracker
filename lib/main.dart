import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/navController.dart';
import 'firebase_options.dart';
// Imported both pages from screens folder.
import 'package:virtuetracker/screens/signUpPage.dart';
import 'package:virtuetracker/screens/signInPage.dart';
import 'package:virtuetracker/screens/homePage.dart';
import 'package:virtuetracker/api/communities.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Communities c = Communities();
    c.getQuadrantList();
    return MaterialApp(
      title: 'Virtue Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInPage(), // closed for testing
      //home: NavControllerPage(),
    );
  }
}
