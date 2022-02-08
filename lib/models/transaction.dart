import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { Income, Expense}

class Transaction {


  Future<void> _addTransaction(CollectionReference transactions, CollectionReference transactionNumber, String amount, String category, String name, String type, String user) async {
    // Call the user's CollectionReference to add a new user
    DocumentSnapshot variable = await FirebaseFirestore.instance.collection('transactionNumber').doc('7LkKmQeyZpT9mzAKRkrl').get();

    int uniqueNumber = variable.get('UniqueTransactionNumber');
    
    return transactions
        .add({
      'UniqueId': uniqueNumber,
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
