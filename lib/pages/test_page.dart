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
  bool get wantKeepAlive => true;
  late String date;

  final db = FirebaseFirestore.instance;

  late List<Object?> userTransactions;
  late QuerySnapshot querySnapshot;
  late StreamSubscription subscription;

  List<bool> isSelected = [true, false, false, false];

  late int selectedButton = 0;

  @override
  void initState() {
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
    var transactions = FirebaseFirestore.instance
        .collection('budgets')
        .doc('c6NUG8oCKg6wx8tFRc6w')
        .collection('transactions');
    // Get docs from collection reference
    querySnapshot = await transactions.getSavy();
    print(querySnapshot.metadata.isFromCache
        ? "NOT FROM NETWORK"
        : "FROM NETWORK");

    querySnapshot.docs
        .map((doc) => ListTile(
            title: Text(doc["Name"]), subtitle: Text(doc["Amount"].toString())))
        .toList();

    // Get data from docs and convert map to List
    userTransactions = querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  getBody() {
    _setDate();

    int activeButton = 0;

    List<Widget> dateButtons = [
      //list of buttons
      DailyButton(),
      WeeklyButton(),
      MonthlyButton(),
      PeriodButton(),
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
                    "Montly",
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
                });
              },
              isSelected: isSelected,
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconButton(onPressed: null, icon: Icon(Icons.arrow_back)),
              Text(date),
              const IconButton(
                  onPressed: null, icon: Icon(Icons.arrow_forward)),
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
                                          .month
                                          .toString()) +
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

  String _month(String monthNumber) {
    if (monthNumber == "1") {
      return "Jan";
    } else if (monthNumber == "2") {
      return "Feb";
    } else if (monthNumber == "3") {
      return "Mar";
    } else if (monthNumber == "4") {
      return "Apr";
    } else if (monthNumber == "5") {
      return "May";
    } else if (monthNumber == "6") {
      return "Jun";
    } else if (monthNumber == "7") {
      return "Jul";
    } else if (monthNumber == "8") {
      return "Aug";
    } else if (monthNumber == "9") {
      return "Sep";
    } else if (monthNumber == "10") {
      return "Oct";
    } else if (monthNumber == "11") {
      return "Nov";
    } else if (monthNumber == "12") {
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
    if (selectedButton == 1) {
      date = DateTime.now().day.toString() +
          " " +
          _month(DateTime.now().month.toString());
    } else if (selectedButton == 2){
      var startDate = DateTime.now().subtract(Duration(days:DateTime.now().weekday - 1));
      var endDate = DateTime.now().add(Duration(days: 7-DateTime.now().weekday));
      date = startDate.day.toString() + " " + _month(startDate.month.toString()) +" - " + endDate.day.toString() + " " + _month(endDate.month.toString());
    } else if( selectedButton == 3){
      date = _month(DateTime.now().month.toString());
    }
  }
}
