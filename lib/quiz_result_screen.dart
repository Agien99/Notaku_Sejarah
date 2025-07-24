import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QuizResultScreen extends StatefulWidget {
  final List<Map<String, dynamic>> answeredQuestions;
  final int score;
  final String bab;
  final String tingkatan;

  const QuizResultScreen({
    super.key,
    required this.answeredQuestions,
    required this.score,
    required this.bab,
    required this.tingkatan,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  Future<void> _saveResult() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> results = prefs.getStringList('quiz_results') ?? [];

    final resultData = {
      'bab': widget.bab,
      'tingkatan': widget.tingkatan,
      'score': widget.score,
      'answeredQuestions': widget.answeredQuestions,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final newResultJson = json.encode(resultData);

    // Add the new result to the beginning
    results.insert(0, newResultJson);

    // Filter out exact duplicates, keeping the most recent one (which is at the beginning)
    final uniqueResults = <String>{};
    final List<String> finalResults = [];
    for (var result in results) {
      if (uniqueResults.add(result)) { // add returns true if the element was not already in the set
        finalResults.add(result);
      }
    }

    await prefs.setStringList('quiz_results', finalResults);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Keputusan Kuiz'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight + 20.0), // Add padding to account for AppBar
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                child: Text(
                  'Jumlah Soalan Dijawab Dengan Betul: ${widget.score} Daripada ${widget.answeredQuestions.length} Soalan',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.answeredQuestions.length,
                  itemBuilder: (context, index) {
                    final item = widget.answeredQuestions[index];
                    final question = item['question'];
                    final selectedAnswer = item['selectedAnswer'];
                    final correctAnswer = item['correctAnswer'];
                    final isCorrect = item['isCorrect'];

                    return Card(
                      color: Colors.grey.shade200.withOpacity(0.9),
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Soalan ${index + 1}: $question',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 8.0),
                            if (isCorrect)
                              Text(
                                'Jawapan anda: $selectedAnswer',
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jawapan anda: $selectedAnswer',
                                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Jawapan yang betul: $correctAnswer',
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}