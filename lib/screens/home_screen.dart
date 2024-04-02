import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tele_communication_helper/screens/reload_history_screen.dart';
import 'package:tele_communication_helper/screens/reload_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _timer;
  int _currentIndex = 0;

  List<String> backgroundImages = [
    "assets/images/dialog_offers.png",
    "assets/images/airtel.png",
    "assets/images/hutch.png",
    "assets/images/mobitel.png"
  ];

  @override
  void initState() {
    super.initState();
    // Start timer to change images every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        // Update index to display the next image
        _currentIndex = (_currentIndex + 1) % backgroundImages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(156, 158, 38, 202),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(92, 9, 121, 100),
        centerTitle: true,
        title: const Text(
          "Home Page",
          style: TextStyle(
            color: Color.fromARGB(255, 253, 253, 253),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                homePageHeader(),
                SizedBox(
                  height: 130, // Adjust the height as needed
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildCard(), // Call buildCard for each card you want
                      buildCard(),
                      buildCard(),
                      buildCard(),
                    ],
                  ),
                ),
                providerButtons(context),
                reloadHistoryButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard() {
    return Card(
      child: GestureDetector(
        onTap: () {
          _showImagePopup(
              context, backgroundImages[_currentIndex], _currentIndex);
        },
        child: Container(
          width: 350, // Adjust width as needed
          height: 500, // Adjust height as needed
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            // color: Colors.white,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(
                  backgroundImages[_currentIndex],
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePopup(
      BuildContext context, String imagePath, int currentIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const Text(
                'Get your offers And Other things', // Replace with your desired text
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  if (currentIndex == 0) {
                    const url =
                        'https://www.dialog.lk/support/self-help-channel/mydialog-app';
                    launch(url);
                  } else if (currentIndex == 1) {
                    const url = 'https://www.airtel.lk/category/my-airtel-app/';
                    launch(url);
                  } else if (currentIndex == 2) {
                    const url = 'https://hutch.lk/hutch-self-care/';
                    launch(url);
                  } else if (currentIndex == 3) {
                    const url = 'https://www.mobitel.lk/selfcare-app';
                    launch(url);
                  }

                  // ignore: deprecated_member_use
                },
                child: const Text(
                  'click here',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget homePageHeader() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Com Helper",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 35, color: Colors.white, fontWeight: FontWeight.w700),
        ),
        Text(
          "Your TeleCommunication Partners",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white54, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 50.0,
        ),
      ],
    );
  }

  Widget providerButtons(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Select your provider for payment",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(134, 45, 10, 241),
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ReloadScreen(name: 'dialog')));
                },
                child: Container(
                  height: 100.0,
                  width: 150.0,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Image.asset('assets/icons/icon_dialog.png'),
                ),
              ),
              const SizedBox(
                width: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReloadScreen(name: 'mobitel'),
                    ),
                  );
                },
                child: Container(
                  height: 100.0,
                  width: 150.0,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Image.asset('assets/icons/icon_mobitel.png'),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 50.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ReloadScreen(name: 'hutch')));
                },
                child: Container(
                  height: 100.0,
                  width: 150.0,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Image.asset('assets/icons/icon_hutch.png'),
                ),
              ),
              const SizedBox(
                width: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ReloadScreen(name: 'airtel')));
                },
                child: Container(
                  height: 100.0,
                  width: 150.0,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Image.asset('assets/icons/icon_airtel.png'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget reloadHistoryButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ReloadHistoryScreen()));
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
            color: Colors.white,
          ),
          child: const Text(
            'Reload History',
            style: TextStyle(
              color: Color(0xff329BFC),
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
