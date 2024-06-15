import 'package:flutter/material.dart';
import 'package:speech_assistnt/features/user_auth/presentation/pages/home_page.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final double positivePercentage;
  final double negativePercentage;
  final double neutralPercentage;
  final String analysisResult;

  ProfilePage({
    required this.userName,
    required this.positivePercentage,
    required this.negativePercentage,
    required this.neutralPercentage,
    required this.analysisResult,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const Homepage(),
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Username: $userName',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Sentiment Analysis:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Positive: ${positivePercentage.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                Text(
                  'Negative: ${negativePercentage.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                Text(
                  'Neutral: ${neutralPercentage.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Result: $analysisResult',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
