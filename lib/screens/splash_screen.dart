// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tele_communication_helper/screens/home_screen.dart';
import 'package:tele_communication_helper/screens/startPage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    gotoHomePage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            "assets/images/background2.png", // Replace with your image path
            fit: BoxFit.cover,
          ),
          // Content
          const Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SpinKitCircle(
                          size: 100,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Welcome to Com Helper",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Com Helper",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "1.0.0",
                    style: TextStyle(fontSize: 16.0, color: Colors.white54),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void gotoHomePage(BuildContext context) {
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const StartPage()));
    });
  }
}
