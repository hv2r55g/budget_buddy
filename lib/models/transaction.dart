import 'package:budget_buddy/utils/cache_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { Income, Expense}

class Transaction {


  Future<void> _addTransaction(String budgetDoc, String amount, String category, String name, String type, String user) async {
    // Call the user's CollectionReference to add a new user
    DocumentSnapshot variable = await FirebaseFirestore.instance.collection('budgets').doc(budgetDoc).getSavy();
    int transactionNumber = variable.get('TransactionNumber');

    CollectionReference transactions = FirebaseFirestore.instance.collection('budgets').doc(budgetDoc).collection('transactions');

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

}
