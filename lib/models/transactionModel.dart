import 'package:budget_buddy/pages/test_page.dart';
import 'package:budget_buddy/utils/cache_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

enum TransactionType { Income, Expense }

class TransactionModel {
  var testPage = TestPage();

  Future<void> _addTransaction(
      String budgetDoc,
      String amount,
      String category,
      String _transactionCategory,
      String name,
      String type,
      String user,
      TextEditingController _transactionAmount,
      TextEditingController _transactionName,
      String _transactionType,
      User _user,
      String userName,
      DateTime _selectedDate,
      TextEditingController _commentSection) async {
    // Call the user's CollectionReference to add a new user
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('budgets')
        .doc(budgetDoc)
        .getSavy();
    int transactionNumber = variable.get('TransactionNumber');

    CollectionReference transactions = FirebaseFirestore.instance
        .collection('budgets')
        .doc(budgetDoc)
        .collection('transactions');

    return transactions
        .add({
          'TransactionNumber': transactionNumber,
          'Amount': double.parse(_transactionAmount.text),
          'Category': _transactionCategory,
          'Name': _transactionName.text,
          'Type': _transactionType,
          'UserId': _user.uid,
          'UserName': userName,
          'Date': _selectedDate,
          'Comment': _commentSection.text,
        })
        .then((value) => print("Transaction Added"))
        .catchError((error) => print("Failed to add transaction: $error"));
  }

  Future<void> deleteTransaction(String budgetDoc, String transactionDoc) async {
    //De collectionreference moet zijn volgens de vorm:

    // CollectionReference transactions = FirebaseFirestore.instance
    //     .collection('budgets')
    //     .doc(budgetDoc)
    //     .collection('transactions')
    //     .doc(de transactiondoc



    final transactions = FirebaseFirestore.instance
        .collection('budgets')
        .doc(budgetDoc)
        .collection('transactions');
    transactions
        .doc(transactionDoc) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((_) => print('Deleted'))
        .catchError((error) => print('Delete failed: $error'));
  }

  String testBudgetDoc = 'c6NUG8oCKg6wx8tFRc6w';

  Stream getAllTransactions(String budgetDoc) {
    return FirebaseFirestore.instance
        .collection('budgets')
        .doc(budgetDoc)
        .collection('transactions')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTransactionsByPeriod(
      String date,
      int yearBeginWeek,
      int yearEndWeek,
      int year,
      int periodType,
      String budgetDoc) {
    if (periodType == 1) {
      //Type daily
      var splitted = date.split(' ');
      var startDate = DateTime(DateTime.now().year,
          _textToNumberMonth(splitted[1]), int.parse(splitted[0]), 0, 0, 0, 0);
      var endDate = DateTime(DateTime.now().year,
          _textToNumberMonth(splitted[1]), int.parse(splitted[0]), 23, 59, 59);

      return FirebaseFirestore.instance
          .collection('budgets')
          .doc(budgetDoc)
          .collection('transactions')
          .where('Date', isGreaterThanOrEqualTo: startDate)
          .where('Date', isLessThanOrEqualTo: endDate)
          .orderBy('Date', descending: true)
          .snapshots();
    } else if (periodType == 2) {
      //Type weekly
      var splitted = date.split(' ');
      var beginDay = splitted[0];
      var beginMonth = splitted[1];
      var endDay = splitted[3];
      var endMonth = splitted[4];

      var startDate = DateTime(yearBeginWeek, _textToNumberMonth(beginMonth),
          int.parse(beginDay), 0, 0, 0, 0);

      var endDate = DateTime(yearEndWeek, _textToNumberMonth(endMonth),
          int.parse(endDay), 23, 59, 59);
      return FirebaseFirestore.instance
          .collection('budgets')
          .doc(budgetDoc)
          .collection('transactions')
          .where('Date', isGreaterThanOrEqualTo: startDate)
          .where('Date', isLessThanOrEqualTo: endDate)
          .orderBy('Date', descending: true)
          .snapshots();
    } else if (periodType == 3) {
      //Type Monthly
      var splitted = date.split(' ');
      var month = splitted[0];
      var year = splitted[1];
      var startDate =
          DateTime(int.parse(year), _textToNumberMonth(month), 1, 0, 0, 0, 0);
      var endDate = DateTime(int.parse(year), _textToNumberMonth(month),
          _numberOfDaysOfMonth(month, int.parse(year)), 23, 59, 59);
      return FirebaseFirestore.instance
          .collection('budgets')
          .doc(budgetDoc)
          .collection('transactions')
          .where('Date', isGreaterThanOrEqualTo: startDate)
          .where('Date', isLessThanOrEqualTo: endDate)
          .orderBy('Date', descending: true)
          .snapshots();
    } else {
      //Type All
      return FirebaseFirestore.instance
          .collection('budgets')
          .doc(budgetDoc)
          .collection('transactions')
          .orderBy('Date', descending: true)
          .snapshots();
    }
  }

  bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

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

  int _numberOfDaysOfMonth(String month, int year) {
    if (month == "Jan") {
      return 31;
    } else if (month == "Feb") {
      if (isLeapYear(year)) {
        return 29;
      } else {
        return 28;
      }
    } else if (month == "Mar") {
      return 31;
    } else if (month == "Apr") {
      return 30;
    } else if (month == "May") {
      return 31;
    } else if (month == "Jun") {
      return 30;
    } else if (month == "Jul") {
      return 31;
    } else if (month == "Aug") {
      return 31;
    } else if (month == "Sep") {
      return 30;
    } else if (month == "Oct") {
      return 31;
    } else if (month == "Nov") {
      return 30;
    } else if (month == "Dec") {
      return 31;
    } else {
      return 0;
    }
  }
}
