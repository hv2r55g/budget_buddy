import 'dart:async';

import 'package:budget_buddy/theme/colors.dart';
import 'package:budget_buddy/utils/cache_query.dart';
import 'package:budget_buddy/models/transactionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestPage3 extends StatefulWidget {
  const TestPage3({Key? key}) : super(key: key);

  @override
  _TestPage3State createState() => _TestPage3State();
}

class _TestPage3State extends State<TestPage3> {
  var transactionHelper = TransactionModel();
  late String date =
      DateTime.now().day.toString() + " " + _month(DateTime.now().month);
  late int year = DateTime.now().year;
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

  late Stream<QuerySnapshot<Map<String, dynamic>>> dataList;

  late var sizeTransactionListView = MediaQuery.of(context).size.height - 185;

  @override
  void initState() {
    dataList = transactionHelper.getTransactionsByPeriod(
        date, yearBeginWeek, yearEndWeek, year, 0, 'c6NUG8oCKg6wx8tFRc6w');

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

  // Future<void> getData() async {
  //   Query<Map<String, dynamic>> transactions = FirebaseFirestore.instance
  //       .collection('budgets')
  //       .doc('c6NUG8oCKg6wx8tFRc6w')
  //       .collection('transactions');
  //
  //   if (selectedButton == 1) {
  //     setState(() {
  //       var splitted = date.split(" ");
  //       var startDate = DateTime(year, _textToNumberMonth(splitted[1]),
  //           int.parse(splitted[0]), 0, 0, 0, 0);
  //       var endDate = DateTime(year, _textToNumberMonth(splitted[1]),
  //           int.parse(splitted[0]), 23, 59, 59);
  //
  //       transactions = FirebaseFirestore.instance
  //           .collection('budgets')
  //           .doc('c6NUG8oCKg6wx8tFRc6w')
  //           .collection('transactions')
  //           .where('Date', isGreaterThanOrEqualTo: startDate)
  //           .where('Date', isLessThanOrEqualTo: endDate);
  //     });
  //   }
  //
  //   // Get docs from collection reference
  //   querySnapshot = await transactions.getSavy();
  //
  //   // Get data from docs and convert map to List
  //   userTransactions = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   print(userTransactions);
  // }

  _setDataset() {}

  getBody() {
    //getData();
    var size = MediaQuery.of(context).size;

    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user?.uid;
    // here you write the codes to input the data into firestore

    //var docRef = db.collection("users").doc(uid);

    //var test = db.collection('users').doc(uid).get();

    //getData().then((value) => print(userTransactions));

    // getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    //   return snapshot.data?.docs
    //       .map((doc) => ListTile(
    //           title: Text(doc["name"]),
    //           subtitle: Text(doc["amount"].toString())))
    //       .toList();
    // }

    //De goede manier om een value op te halen uit een document door er constant naar te luisteren
    //Wil je het 1 maal ophalen gebruik je een FutureBuilder!!

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: white, boxShadow: [
            BoxShadow(
              color: grey.withOpacity(0.01),
              spreadRadius: 10,
              blurRadius: 3,
              // changes position of shadow
            ),
          ]),
          child: Column(
            children: [
              const SizedBox(height: 45),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ToggleButtons(
                  renderBorder: false,
                  selectedColor: Colors.pink,
                  fillColor: Colors.transparent,
                  color: Colors.black,
                  constraints: const BoxConstraints(maxHeight: 20),
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

                      if (index == 0) {
                        date = DateTime.now().day.toString() +
                            " " +
                            _month(DateTime.now().month);

                        dataList = transactionHelper.getTransactionsByPeriod(
                            date,
                            yearBeginWeek,
                            yearEndWeek,
                            year,
                            selectedButton,
                            'c6NUG8oCKg6wx8tFRc6w');

                        sizeTransactionListView =
                            MediaQuery.of(context).size.height - 185;
                      } else if (index == 1) {
                        date = DateTime.now().day.toString() +
                            " " +
                            _month(DateTime.now().month);

                        dataList = transactionHelper.getTransactionsByPeriod(
                            date,
                            yearBeginWeek,
                            yearEndWeek,
                            year,
                            selectedButton,
                            'c6NUG8oCKg6wx8tFRc6w');
                        sizeTransactionListView =
                            MediaQuery.of(context).size.height - 210;
                      } else if (index == 2) {
                        var startDate = DateTime.now().subtract(
                            Duration(days: DateTime.now().weekday - 1));
                        var endDate = DateTime.now()
                            .add(Duration(days: 7 - DateTime.now().weekday));
                        date = startDate.day.toString() +
                            " " +
                            _month(startDate.month) +
                            " - " +
                            endDate.day.toString() +
                            " " +
                            _month(endDate.month);

                        dataList = transactionHelper.getTransactionsByPeriod(
                            date,
                            yearBeginWeek,
                            yearEndWeek,
                            year,
                            selectedButton,
                            'c6NUG8oCKg6wx8tFRc6w');
                        sizeTransactionListView =
                            MediaQuery.of(context).size.height - 210;
                      } else if (index == 3) {
                        date = _month(DateTime.now().month) +
                            " " +
                            year.toString();
                        dataList = transactionHelper.getTransactionsByPeriod(
                            date,
                            yearBeginWeek,
                            yearEndWeek,
                            year,
                            selectedButton,
                            'c6NUG8oCKg6wx8tFRc6w');
                        sizeTransactionListView =
                            MediaQuery.of(context).size.height - 210;
                      }
                    });
                  },
                  isSelected: isSelected,
                ),
              ]),
              if (!isSelected[0])
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        constraints: const BoxConstraints(maxHeight: 20),
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                        onPressed: () => setState(() {
                              _changeDateDown();
                              dataList =
                                  transactionHelper.getTransactionsByPeriod(
                                      date,
                                      yearBeginWeek,
                                      yearEndWeek,
                                      year,
                                      selectedButton,
                                      'c6NUG8oCKg6wx8tFRc6w');
                            }),
                        icon: const Icon(Icons.arrow_back)),
                    SizedBox(
                      height: 35,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(),
                          ),
                          onPressed: () {},
                          child: Text(
                            date,
                            style: const TextStyle(fontSize: 13, color: black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        constraints: const BoxConstraints(maxHeight: 20),
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                        onPressed: () => setState(() {
                              _changeDateUp();
                              dataList =
                                  transactionHelper.getTransactionsByPeriod(
                                      date,
                                      yearBeginWeek,
                                      yearEndWeek,
                                      year,
                                      selectedButton,
                                      'c6NUG8oCKg6wx8tFRc6w');
                            }),
                        icon: const Icon(Icons.arrow_forward)),
                  ],
                ),const SizedBox(height: 5),
            ],
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: sizeTransactionListView,
              child: StreamBuilder<QuerySnapshot>(
                stream: dataList,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                        child: ListView.separated(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            separatorBuilder: (context, index) {
                              return const Divider(
                                indent: 65,
                                endIndent: 5,
                                thickness: 1.5,
                                height: 0,
                              );
                            },
                            itemBuilder: (context, index) {
                              var item = snapshot.data!.docs[index];
                              return ListTile(
                                leading: Image.asset(
                                    _getIcon(item["Category"].toString()),
                                    height: 40),
                                title: Text(
                                  item["Name"],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: black,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  DateTime.parse(
                                              item["Date"].toDate().toString())
                                          .day
                                          .toString() +
                                      " " +
                                      _month(DateTime.parse(
                                              item["Date"].toDate().toString())
                                          .month) +
                                      " " +
                                      DateTime.parse(
                                              item["Date"].toDate().toString())
                                          .hour
                                          .toString() +
                                      ":" +
                                      _minute(DateTime.parse(
                                              item["Date"].toDate().toString())
                                          .minute
                                          .toString()),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: _amount(item["Type"].toString(),
                                    item["Amount"].toString()),
                              );
                            }));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ],
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
      year = DateTime.now().year;
      date = _month(DateTime.now().month) + " " + year.toString();
    }
  }

  _changeDateDown() {
    if (selectedButton == 1) {
      var splitted = date.split(" ");
      var day = splitted[0];
      var month = splitted[1];

      var tempDate = DateTime(year, _textToNumberMonth(month), int.parse(day));

      var resultDate = tempDate.subtract(const Duration(days: 1));

      date = resultDate.day.toString() + " " + _month(resultDate.month);
    } else if (selectedButton == 2) {
      var splitted = date.split(" ");
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
          " " +
          _month(tempBeginDay.month) +
          " - " +
          tempEndDay.day.toString() +
          " " +
          _month(tempEndDay.month);

      yearBeginWeek = tempBeginDay.year;
      yearEndWeek = tempEndDay.year;
    } else if (selectedButton == 3) {
      var splitted = date.split(" ");
      if (splitted[0] == "Jan") {
        year = year - 1;
        date = "Dec" + " " + year.toString();
      } else {
        date = _month(((_textToNumberMonth(splitted[0])) - 1)) +
            " " +
            year.toString();
      }
    }

    //getData();
  }

  void _changeDateUp() {
    if (selectedButton == 1) {
      var splitted = date.split(" ");
      var day = splitted[0];
      var month = splitted[1];

      var tempDate = DateTime(year, _textToNumberMonth(month), int.parse(day));

      var resultDate = tempDate.add(const Duration(days: 1));

      date = resultDate.day.toString() + " " + _month(resultDate.month);
    } else if (selectedButton == 2) {
      var splitted = date.split(" ");
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
          " " +
          _month(tempBeginDay.month) +
          ' - ' +
          tempEndDay.day.toString() +
          " " +
          _month(tempEndDay.month);

      yearBeginWeek = tempBeginDay.year;
      yearEndWeek = tempEndDay.year;
    } else if (selectedButton == 3) {
      var splitted = date.split(" ");
      if (splitted[0] == "Dec") {
        year = year + 1;
        date = "Jan" + " " + year.toString();
      } else {
        date = _month(((_textToNumberMonth(splitted[0])) + 1)) +
            " " +
            year.toString();
      }
    }

    //getData();
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
