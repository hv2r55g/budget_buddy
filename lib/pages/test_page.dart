import 'dart:async';

import 'package:budget_buddy/theme/colors.dart';
import 'package:budget_buddy/utils/cache_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/buttons/daily_button.dart';
import '../widgets/buttons/monthly_button.dart';
import '../widgets/buttons/period_button.dart';
import '../widgets/buttons/weekly_button.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  late String date =
      DateTime.now().day.toString() + " " + _month(DateTime.now().month);
  late int year;
  late int yearBeginWeek =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)).year;

  late int yearEndWeek =
      DateTime.now().add(Duration(days: 7 - DateTime.now().weekday)).year;

  final db = FirebaseFirestore.instance;

  late List<Object?> userTransactions;
  late QuerySnapshot querySnapshot;
  late StreamSubscription subscription;

  List<bool> isSelected = [true, false, false, false];

  late int selectedButton = 0;

  @override
  void initState() {
    _setDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Future<void> getData() async {
    Query<Map<String, dynamic>> transactions = FirebaseFirestore.instance
        .collection('budgets')
        .doc('c6NUG8oCKg6wx8tFRc6w')
        .collection('transactions');

    if (selectedButton == 1) {
      setState(() {
        var splitted = date.split(' ');
        var startDate = DateTime(year, _textToNumberMonth(splitted[1]),
            int.parse(splitted[0]), 0, 0, 0, 0);
        var endDate = DateTime(year, _textToNumberMonth(splitted[1]),
            int.parse(splitted[0]), 23, 59, 59);

        transactions = FirebaseFirestore.instance
            .collection('budgets')
            .doc('c6NUG8oCKg6wx8tFRc6w')
            .collection('transactions')
            .where('Date', isGreaterThanOrEqualTo: startDate)
            .where('Date', isLessThanOrEqualTo: endDate);
      });
    }

    // Get docs from collection reference
    querySnapshot = await transactions.getSavy();

    // Get data from docs and convert map to List
    userTransactions = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(userTransactions);
  }

  getBody() {
    // _setDate();

    List<Widget> dateButtons = [
      //list of buttons
      const DailyButton(),
      const WeeklyButton(),
      const MonthlyButton(),
      const PeriodButton(),
    ];

    getData();
    var size = MediaQuery.of(context).size;

    //CollectionReference users = FirebaseFirestore.instance.collection('users');

    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user?.uid;
    // here you write the codes to input the data into firestore

    //var docRef = db.collection("users").doc(uid);

    //var test = db.collection('users').doc(uid).get();

    //getData().then((value) => print(userTransactions));

    getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
      return snapshot.data?.docs
          .map((doc) => ListTile(
              title: Text(doc["name"]),
              subtitle: Text(doc["amount"].toString())))
          .toList();
    }

    //De goede manier om een value op te halen uit een document door er constant naar te luisteren
    //Wil je het 1 maal ophalen gebruik je een FutureBuilder!!
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ToggleButtons(
              renderBorder: false,
              selectedColor: Colors.pink,
              fillColor: Colors.transparent,
              color: Colors.black,
              constraints: const BoxConstraints(maxHeight: 35),
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: Text(
                    "All",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: Text(
                    "Daily",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: Text(
                    "Weekly",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: Text(
                    "Monthly",
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      selectedButton = index;
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }

                  year = DateTime.now().year;

                  if (index == 1) {
                    date = DateTime.now().day.toString() +
                        " " +
                        _month(DateTime.now().month);
                  } else if (index == 2) {
                    var startDate = DateTime.now()
                        .subtract(Duration(days: DateTime.now().weekday - 1));
                    var endDate = DateTime.now()
                        .add(Duration(days: 7 - DateTime.now().weekday));
                    date = startDate.day.toString() +
                        " " +
                        _month(startDate.month) +
                        " - " +
                        endDate.day.toString() +
                        " " +
                        _month(endDate.month);
                  } else if (index == 3) {
                    date = _month(DateTime.now().month);
                  }
                });
              },
              isSelected: isSelected,
            ),
          ]),
          if (!isSelected[0])
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => setState(() {
                          _changeDateDown();
                        }),
                    icon: const Icon(Icons.arrow_back)),
                Text(date),
                IconButton(
                    onPressed: () => setState(() {
                          _changeDateUp();
                        }),
                    icon: const Icon(Icons.arrow_forward)),
              ],
            ),
          StreamBuilder(
            stream: db
                .collection('budgets')
                .doc('c6NUG8oCKg6wx8tFRc6w')
                .collection('transactions')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Column(
                      children: querySnapshot.docs
                          .map((doc) => ListTile(
                              leading: Image.asset(
                                  _getIcon(doc["Category"].toString()),
                                  height: 40),
                              title: Text(doc["Name"]),
                              subtitle: Text(DateTime.parse(doc["Date"].toDate().toString())
                                      .day
                                      .toString() +
                                  " " +
                                  _month(
                                      DateTime.parse(doc["Date"].toDate().toString())
                                          .month) +
                                  " " +
                                  DateTime.parse(doc["Date"].toDate().toString())
                                      .hour
                                      .toString() +
                                  ":" +
                                  _minute(
                                      DateTime.parse(doc["Date"].toDate().toString())
                                          .minute
                                          .toString())),
                              trailing: _amount(doc["Type"].toString(), doc["Amount"].toString())))
                          .toList()),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  String _getIcon(String category) {
    if (category == "Car") {
      return "assets/images/car.png";
    } else if (category == "Bank") {
      return "assets/images/bank.png";
    } else if (category == "Cash") {
      return "assets/images/cash.png";
    } else if (category == "Charity") {
      return "assets/images/charity.png";
    } else if (category == "Food") {
      return "assets/images/food.png";
    } else if (category == "Gift") {
      return "assets/images/gift.png";
    } else {
      return "assets/images/other.png";
    }
  }

  String _month(int monthNumber) {
    if (monthNumber == 1) {
      return "Jan";
    } else if (monthNumber == 2) {
      return "Feb";
    } else if (monthNumber == 3) {
      return "Mar";
    } else if (monthNumber == 4) {
      return "Apr";
    } else if (monthNumber == 5) {
      return "May";
    } else if (monthNumber == 6) {
      return "Jun";
    } else if (monthNumber == 7) {
      return "Jul";
    } else if (monthNumber == 8) {
      return "Aug";
    } else if (monthNumber == 9) {
      return "Sep";
    } else if (monthNumber == 10) {
      return "Oct";
    } else if (monthNumber == 11) {
      return "Nov";
    } else if (monthNumber == 12) {
      return "Dec";
    } else {
      return "Err";
    }
  }

  String _minute(String string) {
    if (int.parse(string) < 10) {
      return "0" + string;
    } else {
      return string;
    }
  }

  Text _amount(String type, String amount) {
    MaterialColor textColor;
    if (type == "Income") {
      textColor = Colors.green;
    } else {
      textColor = Colors.red;
    }
    //Text("Amount: € " + doc["Amount"].toString()),

    return Text.rich(TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: const TextStyle(
        fontSize: 14.0,
        color: Colors.black,
      ),
      children: <TextSpan>[
        //const TextSpan(text: 'Amount: '),
        TextSpan(text: "€ " + amount, style: TextStyle(color: textColor)),
      ],
    ));
  }

  void _setDate() {
    year = DateTime.now().year;

    if (selectedButton == 1) {
      date = DateTime.now().day.toString() + " " + _month(DateTime.now().month);
    } else if (selectedButton == 2) {
      var startDate =
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      var endDate =
          DateTime.now().add(Duration(days: 7 - DateTime.now().weekday));
      date = startDate.day.toString() +
          " " +
          _month(startDate.month) +
          " - " +
          endDate.day.toString() +
          " " +
          _month(endDate.month);
    } else if (selectedButton == 3) {
      date = _month(DateTime.now().month);
    }
  }

  _changeDateDown() {
    if (selectedButton == 1) {
      var splitted = date.split(' ');
      var day = splitted[0];
      var month = splitted[1];

      var tempDate = DateTime(year, _textToNumberMonth(month), int.parse(day));

      var resultDate = tempDate.subtract(const Duration(days: 1));

      date = resultDate.day.toString() + " " + _month(resultDate.month);
    } else if (selectedButton == 2) {
      var splitted = date.split(' ');
      var beginDay = splitted[0];
      var beginMonth = splitted[1];
      var endDay = splitted[3];
      var endMonth = splitted[4];

      var tempBeginDay = DateTime(yearBeginWeek, _textToNumberMonth(beginMonth),
              int.parse(beginDay))
          .subtract(const Duration(days: 7));

      var tempEndDay =
          DateTime(yearEndWeek, _textToNumberMonth(endMonth), int.parse(endDay))
              .subtract(const Duration(days: 7));

      date = tempBeginDay.day.toString() +
          ' ' +
          _month(tempBeginDay.month) +
          ' - ' +
          tempEndDay.day.toString() +
          ' ' +
          _month(tempEndDay.month);
    } else if (selectedButton == 3) {
      if (date == "Jan") {
        date = "Dec";
      } else {
        date = _month(((_textToNumberMonth(date)) - 1) % 12);
      }
    }

    getData();
  }

  void _changeDateUp() {
    if (selectedButton == 1) {
      var splitted = date.split(' ');
      var day = splitted[0];
      var month = splitted[1];

      var tempDate = DateTime(year, _textToNumberMonth(month), int.parse(day));

      var resultDate = tempDate.add(const Duration(days: 1));

      date = resultDate.day.toString() + " " + _month(resultDate.month);
    } else if (selectedButton == 2) {
      var splitted = date.split(' ');
      var beginDay = splitted[0];
      var beginMonth = splitted[1];
      var endDay = splitted[3];
      var endMonth = splitted[4];

      var tempBeginDay = DateTime(yearBeginWeek, _textToNumberMonth(beginMonth),
              int.parse(beginDay))
          .add(const Duration(days: 7));

      var tempEndDay =
          DateTime(yearEndWeek, _textToNumberMonth(endMonth), int.parse(endDay))
              .add(const Duration(days: 7));

      date = tempBeginDay.day.toString() +
          ' ' +
          _month(tempBeginDay.month) +
          ' - ' +
          tempEndDay.day.toString() +
          ' ' +
          _month(tempEndDay.month);
    } else if (selectedButton == 3) {
      if (date == "Dec") {
        date = "Jan";
      } else {
        date = _month(((_textToNumberMonth(date)) + 1) % 12);
      }
    }

    getData();
  }

  int _textToNumberMonth(String month) {
    if (month == "Jan") {
      return 1;
    } else if (month == "Feb") {
      return 2;
    } else if (month == "Mar") {
      return 3;
    } else if (month == "Apr") {
      return 4;
    } else if (month == "May") {
      return 5;
    } else if (month == "Jun") {
      return 6;
    } else if (month == "Jul") {
      return 7;
    } else if (month == "Aug") {
      return 8;
    } else if (month == "Sep") {
      return 9;
    } else if (month == "Oct") {
      return 10;
    } else if (month == "Nov") {
      return 11;
    } else if (month == "Dec") {
      return 12;
    } else {
      return 0;
    }
  }
}
