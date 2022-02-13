import 'package:budget_buddy/json/daily_json.dart';
import 'package:budget_buddy/json/day_month.dart';
import 'package:budget_buddy/theme/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final db = FirebaseFirestore.instance;

  int activeDay = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  getBody() {
    var size = MediaQuery.of(context).size;

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;
    final uid = user?.uid;
    // here you write the codes to input the data into firestore

    var docRef = db.collection("users").doc(uid);

    db.collection('users').doc(uid)
        .get()
        .then((value) =>
    print(value.get('Username')));

    return Center(child: (Text(docRef.get().asStream().toString())));
  }
}
