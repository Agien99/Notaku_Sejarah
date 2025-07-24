import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:notaku_sejarah/quiz_result_screen.dart';

class QuizHistoryScreen extends StatefulWidget {
  final String tingkatan;

  const QuizHistoryScreen({super.key, required this.tingkatan});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> allResults = prefs.getStringList('quiz_results') ?? [];
    final filteredResults = allResults
        .map((result) => json.decode(result) as Map<String, dynamic>)
        .where((result) => result['tingkatan'] == widget.tingkatan)
        .toList();

    setState(() {
      _results = filteredResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Rekod Kuiz ${widget.tingkatan}'),
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
        child: _results.isEmpty
            ? const Center(
                child: Text(
                  'Tiada rekod kuiz ditemui untuk tingkatan ini.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + kToolbarHeight), // Add padding to account for AppBar
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final result = _results[index];
                  return Card(
                    color: Colors.grey.shade200.withOpacity(0.9),
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        '${result['bab']} - ${result['score']}/${(result['answeredQuestions'] as List).length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(DateTime.parse(result['timestamp']).toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizResultScreen(
                              answeredQuestions: List<Map<String, dynamic>>.from(result['answeredQuestions']),
                              score: result['score'],
                              bab: result['bab'],
                              tingkatan: result['tingkatan'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}