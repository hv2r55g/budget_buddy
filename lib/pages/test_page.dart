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

    db.collection('users').doc(uid).get();


    //De goede manier om een value op te halen uit een document door er constant naar te luisteren
    //Wil je het 1 maal ophalen gebruik je een FutureBuilder!!
    return Center(
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: db.collection('users').doc(uid).snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');

          if (snapshot.hasData) {
            var output = snapshot.data!.data();
            var value = output!['Username']; // <-- Your value
            return Text('Username = $value');
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
