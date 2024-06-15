import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 120,
          ),
          Text(
            "Hello I'm Genius",
            style: TextStyle(
              color: Color.fromARGB(255, 5, 233, 215),
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          Image.asset(
            'assets/bote.png',
            width: 300, // Width in logical pixels
            height: 300,
          ),
        ],
      )),
    );
  }
}
