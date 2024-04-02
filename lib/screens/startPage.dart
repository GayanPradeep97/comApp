// ignore: unused_import
// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:tele_communication_helper/models/credit_card.dart';
import 'package:tele_communication_helper/models/reload.dart';
import 'package:tele_communication_helper/screens/home_screen.dart';
// ignore: unused_import
import 'package:tele_communication_helper/screens/reload_screen.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<StartPage> {
  CreditCard? selectedCard;
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _expireDate = TextEditingController();
  final TextEditingController _cvcCode = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  List<CreditCard> savedCards = [];
  bool doSave = false;
  bool isSavedCard = false;

  @override
  void initState() {
    getSavedCards();
    super.initState();
  }

  Future<List<CreditCard>> fetchCreditCards() async {
    List<CreditCard> creditCards = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('card').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        CreditCard card = CreditCard.fromFirestore(doc, null);
        creditCards.add(card);
      }
    } catch (e) {
      print('Error fetching credit cards: $e');
    }

    return creditCards;
  }

  void getSavedCards() async {
    savedCards = await fetchCreditCards();
    setState(() {});
  }

  void showAlert(BuildContext context, String title, String msg) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showSuccessSnackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    ));
  }

  void showErrorSnackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ));
  }

  Widget providerButtons(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Card Examples')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff329BFC),
      appBar: AppBar(
        title: const Text('Create your payment'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/payment_page.png", // Replace with your image path
            fit: BoxFit.cover,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.7, // Adjust the vertical position
            left: 110.0,
            // bottom: 10.00, // Adjust the horizontal position
            child: Container(
              width: 210, // Set the width of the container
              height: 70,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 6, 30, 240), // Set the background color here
                borderRadius: BorderRadius.circular(10.0),
                // Optional: Add border radius
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                child: const Text(
                  'Start Your Journey!',
                  style: TextStyle(
                    color: Color.fromARGB(
                        255, 255, 255, 255), // Set the text color here
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0, // Set the font weight here
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
