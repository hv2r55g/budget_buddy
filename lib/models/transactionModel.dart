import 'package:budget_buddy/pages/test_page.dart';
import 'package:budget_buddy/utils/cache_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { Income, Expense }

class TransactionModel {
  var testPage = TestPage();

  Future<void> _addTransaction(String budgetDoc, String amount, String category,
      String name, String type, String user) async {
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
          'Amount': double.parse(amount),
          'Category': category,
          'Name': name,
          'Type': type,
          'User': user,
        })
        .then((value) => print("Transaction Added"))
        .catchError((error) => print("Failed to add transaction: $error"));
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
              int.parse(beginDay));

      var endDate =
          DateTime(yearEndWeek, _textToNumberMonth(endMonth), int.parse(endDay));
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
      String startDate = '';
      String endDate = '';
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
