import 'dart:async';

import 'package:budget_buddy/theme/colors.dart';
import 'package:budget_buddy/utils/cache_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final db = FirebaseFirestore.instance;

  late List<Object?> userTransactions;
  late QuerySnapshot querySnapshot;
  late StreamSubscription subscription;

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
          .map((doc) => new ListTile(
              title: new Text(doc["name"]),
              subtitle: new Text(doc["amount"].toString())))
          .toList();
    }

    //De goede manier om een value op te halen uit een document door er constant naar te luisteren
    //Wil je het 1 maal ophalen gebruik je een FutureBuilder!!
    return Column(
      children: [
        MaterialButton(
          onPressed: () => getData(),
          color: Colors.pink,
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
                padding: const EdgeInsets.fromLTRB(5, 40, 5, 5),
                child: Column(
                    children: querySnapshot.docs
                        .map((doc) => ListTile(
                            title: Text("Name: " + doc["Name"]),
                            subtitle:
                                Text("Amount: " + doc["Amount"].toString())))
                        .toList()),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}
