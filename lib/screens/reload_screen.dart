//import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:tele_communication_helper/dialogs/credit_card_details_dialog.dart';
import 'package:tele_communication_helper/screens/home_screen.dart';
import 'package:tele_communication_helper/screens/paymentgatway.dart';
// import 'package:flutter_confetti/flutter_confetti.dart';

class ReloadScreen extends StatefulWidget {
  const ReloadScreen({super.key, required this.name});
  final String name;
  @override
  State<ReloadScreen> createState() => _ReloadScreenState();
}

class _ReloadScreenState extends State<ReloadScreen> {
  final TextEditingController _number = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 6));
    _confettiController.play(); // Play confetti animation when the page loads
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(156, 50, 27, 175),
      appBar: AppBar(
        title: const Text(
          "Reload",
          style: TextStyle(color: Color(0xff329BFC)),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                'welcome to ${widget.name}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
            // const Padding(
            //   padding: EdgeInsets.only(bottom: 5.0),
            const Text(
              "Enter your connection details below",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
              // ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5.0),
                      height: 60.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
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
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _number,
                          maxLength: 10,
                          decoration: InputDecoration(
                              isCollapsed: true,
                              counterText: '',
                              border: InputBorder.none,
                              hintText: 'Enter phone number',
                              hintStyle:
                                  TextStyle(color: Colors.grey.shade500)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(5.0),
                      height: 60.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
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
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: _amount,
                          decoration: InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: 'Enter reload amount',
                              hintStyle:
                                  TextStyle(color: Colors.grey.shade500)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        validateUserInput();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 25.0, color: Color(0xff329BFC)),
                        ),
                      ))
                ],
              ),
            ),

            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              maxBlastForce: 70,
              minBlastForce: 10,
              emissionFrequency: 0.09,
              numberOfParticles: 10,
              gravity: 0.05,
              blastDirection: 3.14,
            ),
          ],
        ),
      )),
    );
  }

  void validateUserInput() {
    if (_number.text.isEmpty || _amount.text.isEmpty) {
      showErrorSnackBar('Please fill out all the fields');
    } else if (_number.text.length < 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(_number.text)) {
      showErrorSnackBar('Please enter a valid phone number');
    } else if (!RegExp(r'^[0-9]+$').hasMatch(_amount.text)) {
      showErrorSnackBar('Please enter a valid amount');
    } else if (widget.name == 'dialog' && !_number.text.startsWith('077')) {
      showErrorSnackBar('Please add dialog phone number');
    } else if (widget.name == 'mobitel' &&
        (!_number.text.startsWith('071') || !_number.text.startsWith('070'))) {
      showErrorSnackBar('Please add mobitel phone number');
    } else if (widget.name == 'hutch' && !_number.text.startsWith('078')) {
      showErrorSnackBar('Please add hutch phone number');
    } else if (widget.name == 'airtel' && !_number.text.startsWith('075')) {
      showErrorSnackBar('Please add airtel phone number');
    } else {
      scanCard();
    }
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

  void scanCard() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentScreen(
                  phone: _number.text,
                  amount: double.tryParse(_amount.text) ?? 0.0,
                )));

    CreditCardDetailsDialog(
      phoneNumer: _number.text,
      amount: double.tryParse(_amount.text) ?? 00.00,
    );
    // showDialog(
    //     context: context,
    //     builder: ((context) => CreditCardDetailsDialog(
    //           phoneNumer: _number.text,
    //           amount: double.tryParse(_amount.text) ?? 00.00,
    //         )));
  }
}
