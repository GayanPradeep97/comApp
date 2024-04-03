// ignore: unused_import
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:tele_communication_helper/models/credit_card.dart';
import 'package:tele_communication_helper/models/reload.dart';
import 'package:tele_communication_helper/screens/home_screen.dart';
// ignore: unused_import
import 'package:tele_communication_helper/screens/reload_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String phone;
  final double amount;
  const PaymentScreen(
      {super.key, required, required this.phone, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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

  void startOneTimePayment(
      BuildContext context, String phone, double amount) async {
    // double amount = 100.00;
    Map paymentObject = {
      "sandbox": true, // true if using Sandbox Merchant ID
      "merchant_id": "1226338", // Replace your Merchant ID
      "merchant_secret":
          "MzA4OTg3MzYyMDEzOTUzMDQ1Nzc0MDEwNzY2NzAxNTM4NjAxNjAz", // See step 4e
      "notify_url": "https://ent13zfovoz7d.x.pipedream.net/",
      "order_id": "ItemNo12345",
      "items": "Hello from Flutter", // Replace with your item name
      "amount": amount.toStringAsFixed(2),
      "currency": "LKR",
      "first_name": "Gayan",
      "last_name": "Pradeep",
      "email": "gayanpradeep@gmail.com",
      "phone": phone,
      "address": "E 93/1, sansungama, kawdulla",
      "city": "Hngurakgoda",
      "country": "Sri Lanka",
      // "delivery_address": "No. 46, Galle road, Kalutara South",
      // "delivery_city": "Kalutara",
      // "delivery_country": "Sri Lanka",
      // "custom_1": "",
      // "custom_2": ""
    };

    PayHere.startPayment(paymentObject, (paymentId) {
      // showAlert(context, "Payment Success!", "Payment Id: $paymentId");
      saveReloadDetails();
    }, (error) {
      showAlert(context, "Payment Failed", error);
    }, () {
      showAlert(context, "Payment Dismissed", "");
    });
  }

  void saveReloadDetails() async {
    // ignore: duplicate_ignore
    try {
      Reload reload = Reload(
          // cardNumber: _cardNumber.text,
          // expireDate: _expireDate.text,
          // cvc: _cvcCode.text,
          phoneNumber: widget.phone,
          amount: widget.amount,
          date: DateFormat('yyyy-MM-dd hh-mm a').format(DateTime.now()));

      final docRef = db
          .collection('reload')
          .withConverter(
            fromFirestore: Reload.fromFirestore,
            toFirestore: (Reload reload, options) => reload.toFirestore(),
          )
          .doc();
      await docRef.set(reload);

      // Navigator.pop(context);
      // Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));

      showSuccessSnackBar('Realod Successfull');
    } catch (e) {
      Navigator.pop(context);
      showErrorSnackBar(e.toString());
    }
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

  Widget savedCardsDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: DropdownButtonFormField(
            value: selectedCard,
            decoration: InputDecoration.collapsed(
                hintText: "Select previously saved card",
                hintStyle: TextStyle(color: Colors.grey.shade500)),
            onChanged: (newValue) {
              setState(() {
                selectedCard = newValue!;
                if (selectedCard != null) {
                  _cardNumber.text = selectedCard!.cardNumber.toString();
                  _expireDate.text = selectedCard!.expireDate.toString();
                  _cvcCode.text = selectedCard!.cvc.toString();
                  isSavedCard = true;
                  startOneTimePayment(context, widget.phone, widget.amount);
                }
              });
            },
            items: savedCards
                .map<DropdownMenuItem<CreditCard>>((CreditCard value) {
              return DropdownMenuItem<CreditCard>(
                value: value,
                child: Text(value.cardNumber.toString()),
              );
            }).toList(),
          ),
        ),
      ),
    );
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
        backgroundColor: const Color.fromARGB(255, 20, 45, 160),
        title: const Text(
          'Create your payment',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/payemant_background.png", // Replace with your image path
            fit: BoxFit.cover,
          ),
          Positioned(
              top: MediaQuery.of(context).size.height *
                  0.55, // Adjust the vertical position
              left: 10.0,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you ready for',
                    style: TextStyle(
                      fontSize: 32.00,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  Text(
                    'your payment?',
                    style: TextStyle(
                      fontSize: 32.00,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              )),
          Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                Container(
                  width: 300, // Set the width of the container
                  height: 70,
                  // padding: const EdgeInsets.only(left: 20.00, right: 30.00),
                  margin: const EdgeInsets.only(
                      left: 20.00, right: 20.00, bottom: 40.00),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 6, 30, 240), // Set the background color here
                    borderRadius: BorderRadius.circular(10.0),
                    // Optional: Add border radius
                  ),

                  child: TextButton(
                    onPressed: () {
                      startOneTimePayment(context, widget.phone, widget.amount);
                    },
                    child: const Text(
                      'Start One Time Payment!',
                      style: TextStyle(
                        color: Color.fromARGB(
                            255, 255, 255, 255), // Set the text color here
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0, // Set the font weight here
                      ),
                    ),
                  ),
                ),
              ])
              // top: MediaQuery.of(context).size.height *
              //     0.7, // Adjust the vertical position
              // left: 50.0,
              // bottom: 10.00, // Adjust the horizontal position

              ),
        ],
      ),
    );
  }
}
