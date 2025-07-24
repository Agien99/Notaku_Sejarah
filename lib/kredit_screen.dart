import 'package:flutter/material.dart';

class KreditScreen extends StatelessWidget {
  const KreditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Aplikasi ini dibangunkan oleh:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/credits/eurgien.jpeg'),
                ),
                SizedBox(height: 10),
                Text(
                  'EURGIEN',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Pembangun Aplikasi & Penyedia Soalan Kuiz Tingkatan 1, 2, 3',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/credits/pyllies.jpeg'),
                ),
                SizedBox(height: 10),
                Text(
                  'PYLLIES ELRUNA',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Penyedia Nota Tingkatan 1 dan Tingkatan 2',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/credits/avassonia.jpeg'),
                ),
                SizedBox(height: 10),
                Text(
                  'AVASSONIA DIANA',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Penyedia Nota Tingkatan 3',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}