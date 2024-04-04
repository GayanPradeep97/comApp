// ignore_for_file: unused_import, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:tele_communication_helper/models/credit_card.dart';
import 'package:tele_communication_helper/models/reload.dart';
import 'package:tele_communication_helper/screens/home_screen.dart';
import 'package:tele_communication_helper/screens/reload_screen.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
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
            left: 95.0,
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
