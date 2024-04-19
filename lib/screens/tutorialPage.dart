// Path: lib/pages/tutorial_page.dart
import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:virtuetracker/screens/homePage.dart';
//import 'package:virtuetracker/widgets/appBarWidget.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.black; // Black text color for content
TextEditingController tfDescription = TextEditingController();
List<ButtonsData>? GridviewData = [
  ButtonsData(color: "#F3A3CA", text: "Honesty"),
  ButtonsData(color: "#C1D9CD", text: "Courage"),
  ButtonsData(color: "#B0E5F6", text: "Compassion"),
  ButtonsData(color: "#F6EEA2", text: "Generosity"),
  ButtonsData(color: "#C58686", text: "Fidelity"),
  ButtonsData(color: "#FADAB4", text: "Integrity"),
  ButtonsData(color: "#DEBFF5", text: "Fairness"),
  ButtonsData(color: "#7AB0D8", text: "Self-control"),
  ButtonsData(color: "#7FA881", text: "Prodence")
];

void main() => runApp(MaterialApp(home: TutorialPage()));

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: mainBackgroundColor,
        //appBar: AppBarWidget('Tutorial'),             UNCOMMENT
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle, size: 30, color: iconColor),
              onPressed: () {
                // TODO: Implement profile icon functionality.
              },
            ),
            SizedBox(width: 12),
          ],
        ),
        body: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFFDF9),
              border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      buildTutorialScreen1(
                        title: 'Getting Started',
                        content:
                            'Welcome to Virtuous! This is the home page. Let’s have you practice adding an entry. '
                            'Select the “Reflect” button below to add a virtue entry to your account. '
                            'This page also shows your last dozen of entries.',
                        backgroundColor: Color(0xFFFFEEDB),
                      ),
                      buildTutorialScreen2(
                        title: 'Getting Started',
                        content:
                            'Now select one of the virtues below that you feel you used today. '
                            'You may make multiple entries in a day, so just choose one for now.',
                        backgroundColor: Color(0xFFF2E1F8),
                      ),
                      buildTutorialScreen3(
                        title: 'Getting Started',
                        content:
                            'Great choice. Now answer the prompts to the best of your ability. '
                            'We want you to focus on the positive aspects of these experiences- '
                            'how did you grow or improve as a person?',
                        backgroundColor: Color(0xFFC0DDEB),
                      ),
                      buildTutorialScreen4(),
                      buildTutorialScreen5(
                        title: 'Getting Started',
                        content:
                            'Now you’re ready to use Virtuous to it’s fullest potential and become the best version of yourself. Good luck!',
                        context: context,
                        backgroundColor: Color(0xFFF2E1F8),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 5,
                    effect: WormEffect(
                      dotColor: Colours.swatch("#EFE5CC"),
                      activeDotColor: Colours.swatch("#C5B898"),
                    ),
                    onDotClicked: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
// Bottom navigation bar code would be here
      ),
    );
  }

  Widget buildTutorialScreen1(
      {required String title,
      required String content,
      required Color backgroundColor}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Getting started',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: GoogleFonts.tinos(
                textStyle: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            child: Text("Reflect",
                style: GoogleFonts.tinos(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: iconColor,
                  ),
                )),
            style: ElevatedButton.styleFrom(
              primary: buttonColor,
              shape: CircleBorder(),
              elevation: 4,
              padding: EdgeInsets.all(70),
            ),
          ),

// SizedBox(height: 10.0),
          Divider(
            endIndent: 10,
            indent: 10,
            color: Colours.swatch("#534D3F"),
            height: MediaQuery.of(context).size.height / 35,
            thickness: 2,
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Select the button above to add an entry.",
            style: GoogleFonts.tinos(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
          ),

// Other widgets or content can go here
        ],
      ),
    );
  }

  Widget buildTutorialScreen2(
      {required String title,
      required String content,
      required Color backgroundColor}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Getting started',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: GoogleFonts.tinos(
                textStyle: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 50.0),
          GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: List.generate(GridviewData!.length, (index) {
              return Stack(
                children: [
                  InkWell(
                    onTap: () {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colours.swatch(GridviewData![index].color),
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                            child: Text(
                          GridviewData![index].text.toString(),
                          style: GoogleFonts.tinos(
                            textStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: iconColor,
                            ),
                          ),
                        ))),
                  )
                ],
              );
            }),
          )

// Other widgets or content can go here
        ],
      ),
    );
  }

  Widget buildTutorialScreen3(
      {required String title,
      required String content,
      required Color backgroundColor}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Getting started',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: GoogleFonts.tinos(
                textStyle: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            "Honesty",
            style: GoogleFonts.tinos(
              textStyle: TextStyle(
                fontSize: 18,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.normal,
                color: iconColor,
              ),
            ),
          ),
          SizedBox(height: 8.0),
/*  MaterialButton(onPressed: (){
            _pageController.nextPage(duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },child: Container(decoration: BoxDecoration(color: Colours.swatch('#c5b898'),borderRadius: BorderRadius.circular(100)),width: 200,height: 200,
            child: Center(child: Text("Reflect",style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: iconColor,
            ),)) ,
          ),),*/
// SizedBox(height: 10.0),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Center(
              child: Text(
                "Honesty is being truthful and sincere in both words and actions, without deceit or deception.",
                // textAlign: TextAlign.center,
                style: GoogleFonts.tinos(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    color: Colours.swatch("#888479"),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            endIndent: 10,
            indent: 10,
            color: Colours.swatch("#F3A3CA"),
            height: MediaQuery.of(context).size.height / 35,
            thickness: 2,
          ),
          Container(
            child: Text(
              "Describe how you used this virtue today.",
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colours.swatch("#000000"),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          textFieldNoteInput(context, tfDescription, false)

// Other widgets or content can go here
        ],
      ),
    );
  }

  Widget textFieldNoteInput(
      BuildContext context, TextEditingController controller, bool readOnly) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.2,
        height: 120,
        child: TextFormField(
          cursorColor: Colors.black,
          cursorRadius: const Radius.circular(0),
          controller: controller,
          maxLines: 4,
          readOnly: readOnly,
          style: TextStyle(color: iconColor, fontSize: 16),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              filled: true,
              fillColor: Colors.white),
        ));
  }

  Widget buildTutorialScreen4() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Getting started',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Now that you know how to make an entry, let’s show you some of the other features Virtuous has to offer. ',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFF3A3CA),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "The Home page, as we showed before,\nallows you to add an entry and see\nyour entries from today.",
                      style: GoogleFonts.tinos(
                        textStyle: TextStyle(color: textColor, fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.home,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF7FA881),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "The Analyze page allows you to see stats related to your virtue usage as well as a visual calendar for easy tracking. ",
                      style: GoogleFonts.tinos(
                        textStyle: TextStyle(color: textColor, fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.bar_chart,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFC58686),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "The Nearby page shows you data related to the virtue usage of users in your location. ",
                      style: GoogleFonts.tinos(
                        textStyle: TextStyle(color: textColor, fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.near_me,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFB0E5F6),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "The Resources page provides information on the purpose of Virtuous and insight on your virtues. ",
                      style: GoogleFonts.tinos(
                        textStyle: TextStyle(color: textColor, fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.library_books,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTutorialScreen5(
      {required String title,
      required String content,
      required Color backgroundColor,
      required context}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Getting started',
              style: GoogleFonts.tinos(
                textStyle: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: GoogleFonts.tinos(
                textStyle: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 50.0),
          MaterialButton(
            onPressed: () {
              GoRouter.of(context).go('/home');
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFbab7d4), // Dark purple color
                  borderRadius:
                      BorderRadius.circular(5), // Adjusted border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                width: 210,
                height: 50,
                child: Center(
                  child: Text(
                    "Continue to Virtuous",
                    style: GoogleFonts.tinos(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonsData {
  String? color;
  String? text;

  ButtonsData({this.color, this.text});
}
