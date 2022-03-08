import 'package:budget_buddy/pages/profile_page.dart';
import 'package:budget_buddy/pages/test_page.dart';
import 'package:budget_buddy/pages/testpage2.dart';
import 'package:budget_buddy/pages/transactions_page.dart';
import 'package:budget_buddy/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'create_transaction.dart';
import 'daily_page.dart';

class RootAppTest extends StatefulWidget {
  RootAppTest({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  final List locale = [
    {'name': 'ENGLISH', 'locale': const Locale('en', '')},
    {'name': 'NEDERLANDS', 'locale': const Locale('nl', '')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  @override
  _RootAppTestState createState() => _RootAppTestState();
}

class _RootAppTestState extends State<RootAppTest> {
  late User _user;
  int pageIndex = 0;

  var _pageController;

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pages = [
      //list of pages
      TransactionsPage(),
      TestPage2(),
      TransactionsPage(),
      ProfilePage(user: _user),
      CreateBudgetPage(user: _user),
    ];

    return Scaffold(
        body:PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => pageIndex = index);
          },
          children: pages,
        ),
        bottomNavigationBar: getFooter(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //will open a certain page
              selectedTab(4);
            },
            child: const Icon(
              Icons.add,
              size: 25,
            ),
            backgroundColor: Colors.pink
          //params
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked);
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Icons.calendar_today,
      Icons.bar_chart,
      Icons.money,
      Icons.person,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: primary,
      splashColor: secondary,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: _onItemTapped,
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
      //
      //
      //using this page controller you can make beautiful animation effects
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }
}


