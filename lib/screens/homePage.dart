import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/api/auth.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/controllers/userControllers.dart';
import 'package:virtuetracker/controllers/virtueEntryController.dart';
import 'package:virtuetracker/screens/gridPage.dart';
import 'package:virtuetracker/screens/signInPage.dart';
import 'package:virtuetracker/widgets/Calendar.dart';
import 'package:virtuetracker/widgets/appBarWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userInfo = ref.read(userInfoProviderr);
    String communityName = userInfo.currentCommunity;
    ref
        .read(virtueEntryControllerProvider.notifier)
        .getMostRecentEntries(communityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE5CC),
      appBar: AppBarWidget('regular'),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFDF9),
            border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => {GoRouter.of(context).go('/home/gridPage')},
                child: Text(
                  'Reflect',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  shape: CircleBorder(),
                  elevation: 4,
                  padding: EdgeInsets.all(70),
                ),
              ),
              // Center( //----------------------------- test button for testing stuff :) ---------------------------------
              //   child: Container(
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       onPressed:() async {
              //         // --------- noti stuff -----------
              //         // TimeOfDay stringToTimeOfDay(String tod) {
              //         //   final format = DateFormat.jm();
              //         //     return TimeOfDay.fromDateTime(format.parse(tod));
              //         // }
              //         // TimeOfDay fromString(String time) {
              //         //   int hh = 0;
              //         //   if (time.endsWith('PM')) hh = 12;
              //         //   time = time.split(' ')[0];
              //         //   return TimeOfDay(
              //         //     hour: hh + int.parse(time.split(":")[0]) % 24, // in case of a bad time format entered manually by the user
              //         //     minute: int.parse(time.split(":")[1]) % 60,
              //         //   );
              //         // }
              //         // dynamic time = await Users().getNotiTime();
              //         // String response = time["response"];
              //         // TimeOfDay formatTime = fromString(response);
              //         // print('time: $formatTime');
              //         // NotificationService().scheduleNotification(
              //         //   title: 'Virtuous',
              //         //   body: 'Make an entry today!',
              //         //   scheduledNotificationDateTime: scheduleTime
              //         // );
              //         // -------------- location stuff ----------------
              //         Users().getNearbyEntries('10km', "Last week", true);
              //       },
              //       child: Text('Get entries'),
              //       style: ElevatedButton.styleFrom(
              //         primary: Colors.amber,
              //         // Change button color to beige
              //       ),
              //     ),
              //   ),
              // ),
              Text(' '),
              Divider(
                thickness: 1,
                color: Colors.black,
              ),
              SizedBox(height: 15),
              const RecentEntries()
              // RecentEntriesWidget(ref: ref)
            ],
          ),
        ),
      ),
    );
  }
}

class RecentEntriesWidget extends ConsumerWidget {
  const RecentEntriesWidget({super.key, required this.ref});
  final ref;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(virtueEntryControllerProvider).when(
        error: (error, stacktrace) => Text(
              "You currently don't have any entries, click the Reflect button to make your first entry!",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
        data: (response) {
          if (response['Function'] == "getMostRecentEntries") {
            List recentEntriesList = response['list'];
            return BuildRecentEntriesList(listy: recentEntriesList ?? []);
          } else {
            return Text('Not sure');
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()));
    // child: BuildRecentEntriesList(listy: []),
  }
}

class RecentEntries extends ConsumerStatefulWidget {
  const RecentEntries({super.key});

  @override
  _RecentEntriesState createState() => _RecentEntriesState();
}

class _RecentEntriesState extends ConsumerState<RecentEntries> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(virtueEntryControllerProvider).when(
        error: (error, stacktrace) => Text(
              "You currently don't have any entries, click the Reflect button to make your first entry!",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
        data: (response) {
          if (response != null) {
            if (response['Function'] == "getMostRecentEntries") {
              List recentEntriesList = response['list'];

              return BuildRecentEntriesList(listy: recentEntriesList ?? []);
            } else {
              return Text('Not sure');
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}

// Builds recent entries list
class BuildRecentEntriesList extends ConsumerWidget {
  const BuildRecentEntriesList({super.key, required this.listy});
  final List<dynamic> listy;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Recent entries in HomePage: $listy');

    return listy.isEmpty
        ? Center(
            child: Text('List is Null'),
          )
        : Expanded(
            child: ListView.builder(
                itemCount: listy.length,
                itemBuilder: (BuildContext context, index) {
                  final Map<String, dynamic> item =
                      listy![index] as Map<String, dynamic>;
                  return RecentEntryWidget(
                    quadrantName: item['quadrantUsed'],
                    quadrantColor:
                        int.tryParse(item['quadrantColor'].toString()) ??
                            0xFFA6A1CC,
                    docId: item['docId'],
                    ref: ref,
                  );
                }),
          );
  }
}

// Recent entrywidget, that is also tappable
class RecentEntryWidget extends StatelessWidget {
  const RecentEntryWidget(
      {super.key,
      required this.quadrantName,
      required this.quadrantColor,
      required this.docId,
      this.ref});
  final String quadrantName;
  final int quadrantColor;
  final String docId;
  final dynamic ref;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('Clicked virtue $docId');
        await settingEntryProvider(ref, docId);
        GoRouter.of(context).go('/home/editEntry');
      },
      child: Container(
        width: double.infinity,
        height: 80,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            width: 1,
          ),
        ),
        child: Wrap(
          direction: Axis.horizontal,
          runAlignment: WrapAlignment.center,
          // alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(quadrantColor),
                  ),
                  child: Text("")),
            ),
            Expanded(
                flex: 1,
                child: Text(
                  quadrantName,
                  maxLines: 1,
                  style: GoogleFonts.tinos(
                    textStyle: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
