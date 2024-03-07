import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/communityShared.dart';
import 'package:virtuetracker/api/settings.dart';
import 'package:virtuetracker/api/stats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/app_router/app_navigation.dart';
import 'package:virtuetracker/screens/analysisPage.dart';
import 'package:virtuetracker/screens/forgotPasswordPage.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/screens/navController.dart';
import 'package:virtuetracker/screens/nearbyPage.dart';
import 'package:virtuetracker/screens/resourcePage.dart';
import 'package:virtuetracker/screens/settingsScreen/changepassword.dart';
import 'package:virtuetracker/screens/settingsScreen/settings.dart';
import 'package:virtuetracker/screens/settingsScreen/privacypolicy.dart';
import 'package:virtuetracker/screens/settingsScreen/editprofile.dart';
import 'package:virtuetracker/screens/settingsScreen/termofuse.dart';
import 'package:virtuetracker/screens/settingsScreen/privacy.dart';
import 'package:virtuetracker/screens/settingsScreen/changepassword.dart';
import 'package:virtuetracker/screens/settingsScreen/notifications.dart';
import 'package:virtuetracker/screens/surveyPage.dart';
import 'package:virtuetracker/screens/resourcePage.dart';
import 'package:virtuetracker/screens/surveyPage.dart';
import 'package:virtuetracker/screens/tutorialPage.dart';
import 'package:virtuetracker/widgets/Calendar.dart';
import 'firebase_options.dart';
// Imported both pages from screens folder.
import 'package:virtuetracker/screens/signUpPage.dart';
import 'package:virtuetracker/screens/signInPage.dart';
import 'package:virtuetracker/screens/nearbyPage.dart';
import 'package:virtuetracker/screens/homePage.dart';
import 'package:virtuetracker/api/communities.dart';
import 'package:geolocator/geolocator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));

  // await Geolocator.openAppSettings();
  // await Geolocator.openLocationSettings();
  testingApi();
  setSharedPreferences();
}

Future setSharedPreferences() async {
  final Users user = Users();
  final result = await user.getUserInfo();
  if (result['Success']) {
    final userInfo = result['response'];
    String currentCommunity = userInfo['currentCommunity'];
    bool shareLocation = userInfo['shareLocation'];
    bool shareEntries = userInfo['shareEntries'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentCommunity', currentCommunity);
    await prefs.setBool('shareLocation', shareLocation);
    await prefs.setBool('shareEntries', shareEntries);

    print(
        'main shared pref \n currentCommunity: $currentCommunity, shareLocation: $shareLocation, shareEntries: $shareEntries');
  }
}

Future testingApi() async {
// Testing api

  final Communities c = Communities();
  final Users u = Users();
  final CommunityShared shared = CommunityShared();
  final Stats stats = Stats();
  final Auth auth = Auth();
  final Settings settings = Settings();
  // await stats
  //     .getQuadrantsUsedList("legal")
  //     .then((value) => print('main: $value'));
  await stats
      .buildCalendar()
      .then((value) => print(value['response'].toString()));
  // await auth.forgotPassword("tyyee@gmail.com").then((value) => print(value));
  // await u.findUsersNear().catchError((e) => print(e));

  // await settings
  //     .updateProfile(
  //         "testio1234@gmail.com", "TESTIOOOO", "newCareer", "legal", "4 Years")
  //     .catchError((e) => print(e));

  // await settings.updatePrivacy(true, false).catchError((e) => print(e));

  // await settings
  //     .updateNotificationPreferences(false, "12:01pm")
  //     .catchError((e) => print(e));

  // Finished Testing addVirtue api
  // u
  //     .addVirtueEntry("legal", "Integrity", "0xFFF3A3CA",
  //         ["Answer 1", "Answer 2", "Answer 3sss", "Anserssssss"], true, true)
  //     .then((value) => {print(value["Success"])})
  //     .catchError((error) => {print('error in main: $error')});

  // Finished Testing surveyInfo api, need to add more
  // u
  //     .surveyInfo(
  //         "best attorney ever in the world, even better than saul",
  //         "3 years",
  //         "legal",
  //         "I need to a",
  //         true,
  //         true,
  //         true,
  //         123 - 456 - 789,
  //         "12:18pm")
  //     .catchError((error) => {print('error in main: $error')});

  // await u
  //     .getUpdatedLocation(true)
  //     .then((value) => print(value))
  //     .catchError((e) => print(e));
  // await u.addUserLocation().then((value) => print(value));
  // await shared
  //     .addSharedVirtueEntry("Honesty", "0xFFF3A3CA", true, "legal")
  //     .then((val) => print(val))
  //     .catchError((e) => print(e));
  // u.getUserLocation();
  // u.getMostRecentEntries("legal");
  // dynamic userObject = await u.getUserInfo();
  // auth.signInWithGoogle();
  // print(userObject);

  // Tested and working
  // await u.updateQuadrantsUsed("legal", "Compassion");
  // auth.signOutUser();

  // stats.getQuadrantsUsedList("legal");
  // Testing api ending
}

// Test screens and widgets with this
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Virtue Tracker',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),

//       // routerConfig: AppRouter.router,
//       // home: HomePage(), // closed for testing
//       home: SurveyPage(),
//     );
//   }
// }

// This widget has the navigation with routes
class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final goRouter = ref.watch(goRouterProvider);
    final goRouter = ref.watch(AppNavigation.router);

    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Virtue Tacker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
