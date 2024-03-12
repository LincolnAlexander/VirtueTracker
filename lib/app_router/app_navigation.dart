import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/screens/settingsScreen/changepassword.dart';
import 'package:virtuetracker/screens/settingsScreen/changephone.dart';
import 'package:virtuetracker/screens/settingsScreen/editprofile.dart';
import 'package:virtuetracker/screens/forgotPasswordPage.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/app_router/scaffoldWithNavBar.dart';
import 'package:virtuetracker/screens/analysisPage.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/homePage.dart';
import 'package:virtuetracker/screens/landingPage.dart';
import 'package:virtuetracker/screens/nearbyPage.dart';
import 'package:virtuetracker/screens/resourcePage.dart';
import 'package:virtuetracker/screens/settingsScreen/settings.dart';
import 'package:virtuetracker/screens/signInPage.dart';
import 'package:virtuetracker/screens/signUpPage.dart';
import 'package:virtuetracker/screens/surveyPage.dart';
import 'package:virtuetracker/screens/tutorialPage.dart';
import 'package:virtuetracker/screens/virtueEntry.dart';

import '../screens/settingsScreen/notifications.dart';
import '../screens/settingsScreen/privacy.dart';
import '../screens/settingsScreen/privacypolicy.dart';
import '../screens/settingsScreen/termofuse.dart';

String initial(ref) {
  try {
    print('time to nvgate');
    final user = ref.watch(authStateChangesProvider).value;
    // final fisrtTimey = ref.watch(isFirstTimeSignInProvider);
    // final dynamic userInfo = ref.watch(currentUserInfo);
    // final Future<Map<String, dynamic>> userInfoFuture =
    //     ref.read(currentUserInfo);
    Auth auth = Auth();

    final creationTime = user.metadata.creationTime;
    final lastSignInTime = user.metadata.lastSignInTime;
    // var surveyInfo;
    print('use ${user} and meta');
    // print('userInfo: ${userInfoFuture}');
    // userInfoFuture.then((Map<String, dynamic> userInfo) {
    //   print('userInfo: ${userInfo["response"]}');
    //   // surveyInfo = userInfo['response']['currentCommunity'];
    //   // print('sirveyInfo $surveyInfo');
    //   // if (userInfo['response']['currentCommunity'] != null) return '/analysis';
    // }).catchError((error) {
    //   print('Error fetching user information: $error');
    //   // Handle the error case
    // });
    // print('cure $fisrtTimey');

    if (user != null) {
      if (creationTime == lastSignInTime) {
        print('welcome new user, first time creating account ');
        return '/signIn';
      }

      return '/home';
    } else {
      // User is not signed in, redirect to the sign-in page
      return '/signIn';
    }
  } catch (e) {
    return '/signIn';
  }
}

class AppNavigation {
  AppNavigation._();

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final _shellNavigatorAnalyze =
      GlobalKey<NavigatorState>(debugLabel: 'shellAnalyze');
  static final _shellNavigatorNearby =
      GlobalKey<NavigatorState>(debugLabel: 'shellNearby');
  static final _shellNavigatorResources =
      GlobalKey<NavigatorState>(debugLabel: 'shellResources');
  // GoRouter configuration

  // Call the navigation function after the build is complete
  // WidgetsBinding.instance?.addPostFrameCallback((_) => navigate());

  static final router = Provider<GoRouter>((ref) {
    return GoRouter(
      // initialLocation: initial(ref),
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
          path: '/',
          name: 'LandingPage',
          builder: (context, state) => LandingPageTest(),
        ),
        GoRoute(
            path: '/signIn',
            name: 'signIn',
            builder: (context, state) => SignInPage(),
            routes: [
              GoRoute(
                path: 'signUp',
                name: 'signUp',
                builder: (context, state) => SignUpPage(),
              ),
              GoRoute(
                path: 'forgotPassword',
                name: 'forgotPassword',
                builder: (context, state) => ForgotPasswordPage(),
              ),
            ]),
        GoRoute(
          path: '/signUp',
          name: 'signUps',
          builder: (context, state) => SignUpPage(),
        ),

        GoRoute(
            path: '/survey',
            name: 'SurveyPage',
            builder: (context, state) => SurveyPage(),
            routes: [
              GoRoute(
                path: 'tutorial',
                name: 'tutorial',
                builder: (context, state) => TutorialPage(),
              ),
            ]),

        /// MainWrapper
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNavBar(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
            /// Brach Home
            StatefulShellBranch(
              navigatorKey: _shellNavigatorHome,
              routes: <RouteBase>[
                GoRoute(
                  path: "/home",
                  name: "Home",
                  builder: (BuildContext context, GoRouterState state) =>
                      const HomePage(),
                  routes: [
                    GoRoute(
                      path: 'gridPage',
                      name: 'GridPage',
                      routes: [
                        GoRoute(
                          path:
                              'virtueEntry/:quadrantName/:quadrantDefinition/:quadrantColor',
                          name: 'VirtueEntryPage',
                          builder: (context, state) {
                            // final quadrantName = Families.family(state.params['fid']!);
                            final quadrantName =
                                state.pathParameters['quadrantName'];
                            final quadrantDefinition =
                                state.pathParameters['quadrantDefinition'];
                            final quadrantColor =
                                state.pathParameters['quadrantColor'];

                            return VirtueEntry(
                              quadrantName: quadrantName,
                              definition: quadrantDefinition,
                              color: quadrantColor,
                            );
                          },
                        )
                      ],
                      pageBuilder: (context, state) =>
                          CustomTransitionPage<void>(
                        key: state.pageKey,
                        child: const GridPagey(appBarChoice: 'arrow'),
                        transitionsBuilder: (context, animation,
                                secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                    path: '/SettingsPage',
                    name: 'SettingsPage',
                    builder: (context, state) => SettingsPage(),
                    routes: [
                      GoRoute(
                        path: 'EditProfilePage',
                        name: 'EditProfilePage',
                        builder: (context, state) => EditProfilePage(),
                      ),
                      GoRoute(
                          path: 'NotificationsPage',
                          name: 'NotificationsPage',
                          builder: (context, state) => NotificationsPage(),
                          routes: [
                            GoRoute(
                              path: 'UpdatePhoneNumber',
                              name: 'UpdatePhoneNumber',
                              builder: (context, state) => ChangePhonePage(),
                            ),
                          ]),
                      GoRoute(
                        path: 'ChangePasswordPage',
                        name: 'ChangePasswordPage',
                        builder: (context, state) => ChangePasswordPage(),
                      ),
                      GoRoute(
                        path: 'PrivacyPage',
                        name: 'PrivacyPage',
                        builder: (context, state) => PrivacyPage(),
                      ),
                      GoRoute(
                        path: 'TermOfUsePage',
                        name: 'TermOfUsePage',
                        builder: (context, state) => TermOfUsePage(),
                      ),
                      GoRoute(
                        path: 'PrivacyPolicyPage',
                        name: 'PrivacyPolicyPage',
                        builder: (context, state) => PrivacyPolicyPage(),
                      ),
                    ]),
              ],
            ),

            // Branch Analyze
            StatefulShellBranch(
              navigatorKey: _shellNavigatorAnalyze,
              routes: <RouteBase>[
                GoRoute(
                  path: "/analysis",
                  name: "Analysis",
                  builder: (BuildContext context, GoRouterState state) =>
                      const AnalysisPage(),
                  routes: [],
                ),
              ],
            ),

            // Branch Nearby
            StatefulShellBranch(
              navigatorKey: _shellNavigatorNearby,
              routes: <RouteBase>[
                GoRoute(
                  path: "/nearby",
                  name: "Nearby",
                  builder: (BuildContext context, GoRouterState state) =>
                      const NearbyPage(),
                  routes: [],
                ),
              ],
            ),

            /// Brach Resources
            StatefulShellBranch(
              navigatorKey: _shellNavigatorResources,
              routes: <RouteBase>[
                GoRoute(
                  path: "/resource",
                  name: "Resources",
                  builder: (BuildContext context, GoRouterState state) =>
                      const ResourcePage(),
                  routes: [],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  });
}
