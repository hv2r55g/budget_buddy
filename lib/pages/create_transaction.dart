import 'package:budget_buddy/json/create_budget_json.dart';
import 'package:budget_buddy/pages/root_app.dart';
import 'package:budget_buddy/theme/colors.dart';
import 'package:budget_buddy/utils/cache_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateBudgetPage extends StatefulWidget {
  const CreateBudgetPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _CreateBudgetPageState createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  late User _user;
  int activeCategory = 0;
  final TextEditingController _transactionName =
      TextEditingController(text: "");
  final TextEditingController _transactionAmount =
      TextEditingController(text: "");
  final TextEditingController _commentSection = TextEditingController(text: "");
  String _transactionType = "Income";
  String _transactionCategory = categories[0]['name'];
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _transactionName.dispose();
    _transactionAmount.dispose();
    _commentSection.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    List<String> types = <String>['Income', 'Expense'];

    String budgetDoc = 'c6NUG8oCKg6wx8tFRc6w';

    CollectionReference transactions = FirebaseFirestore.instance
        .collection('budgets')
        .doc(budgetDoc)
        .collection('transactions');

    Future<void> addTransaction() async {
      // Call the user's CollectionReference to add a new user

      DocumentSnapshot budgetTransactions = await FirebaseFirestore.instance
          .collection('budgets')
          .doc(budgetDoc)
          .getSavy();

      DocumentSnapshot userCollectionSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .getSavy();

      String userName = userCollectionSnapshot.get('Username');

      int transactionNumber = budgetTransactions.get('TransactionNumber');
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
          .catchError((error) => print("Failed to add transaction: $error"))
          .then((value) => _resetParameters());
    }

    Future<void> updateUniqueTransactionNumber() async {
      DocumentSnapshot variable = await FirebaseFirestore.instance
          .collection('budgets')
          .doc(budgetDoc)
          .getSavy();

      int transactionNumber = variable.get('TransactionNumber');

      await FirebaseFirestore.instance
          .collection('budgets')
          .doc(variable.id)
          .update({"TransactionNumber": transactionNumber + 1});
    }

    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Create transaction",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      Row(
                        children: const [Icon(Icons.search)],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Text(
              "Choose category",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: black.withOpacity(0.5)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(categories.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeCategory = index;
                    _transactionCategory = categories[activeCategory]['name'];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    width: 120,
                    height: 130,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(
                            width: 2,
                            color: activeCategory == index
                                ? primary
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: grey.withOpacity(0.01),
                            spreadRadius: 10,
                            blurRadius: 3,
                            // changes position of shadow
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 25, top: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: grey.withOpacity(0.15)),
                              child: Center(
                                child: Image.asset(
                                  categories[index]['icon'],
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.contain,
                                ),
                              )),
                          Text(
                            categories[index]['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color(0xff67727d)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: TextField(
                    controller: _transactionName,
                    cursorColor: black,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: black),
                    decoration: const InputDecoration(
                        hintText: "Enter Transaction Name",
                        border: InputBorder.none),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Type",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Color(0xff67727d)),
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: DropdownButton<String>(
                              value: _transactionType,
                              items: ['Income', 'Expense'].map((String val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _transactionType = val!;
                                });
                              },
                            )),
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Date",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Color(0xff67727d)),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(
                                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: black,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.pink,
                                    ),
                                    onPressed: () {
                                      _selectDate(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: (size.width - 160),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Color(0xff67727d)),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Row(
                              children: [
                                const Text(
                                  "€ ",
                                  style: TextStyle(
                                    color: black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _transactionAmount,
                                    cursorColor: black,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: black),
                                    decoration: const InputDecoration(
                                        hintText: "Transaction amount",
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(15)),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: white,
                        ),
                        onPressed: () {
                          addTransaction();
                          updateUniqueTransactionNumber();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Comment",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color(0xff67727d)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  width: size.width,
                  height: size.height * 0.10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), color: white),
                  child: TextField(
                    controller: _commentSection,
                    cursorColor: black,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: black),
                    decoration: const InputDecoration(
                        hintText: "Hier kan je wat commentaar geven",
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  _resetParameters() {
    _transactionAmount.clear();
    _transactionName.clear();
    _transactionAmount.clear();
    _commentSection.clear();
    activeCategory = 0;
  }
}
