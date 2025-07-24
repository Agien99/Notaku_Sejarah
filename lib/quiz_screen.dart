import 'package:flutter/material.dart';
import 'package:notaku_sejarah/quiz_result_screen.dart';
import 'package:notaku_sejarah/quiz/Tingkatan_1.dart';
import 'dart:math';

class QuizScreen extends StatelessWidget {
  final String tingkatan;

  const QuizScreen({super.key, required this.tingkatan});

  @override
  Widget build(BuildContext context) {
    final babList = sejarahKuiz.keys.toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Text('Pilih Bab - $tingkatan'),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 20.0),
            child: ListView.builder(
              itemCount: babList.length,
              itemBuilder: (context, index) {
                final bab = babList[index];
                return Card(
                  color: Colors.grey.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizQuestionsScreen(bab: bab, tingkatan: tingkatan),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          bab,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QuizQuestionsScreen extends StatefulWidget {
  final String bab;
  final String tingkatan;

  const QuizQuestionsScreen({super.key, required this.bab, required this.tingkatan});

  @override
  State<QuizQuestionsScreen> createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  int _questionIndex = 0;
  int _score = 0;
  late List<Map<String, dynamic>> _questions;
  final List<Map<String, dynamic>> _answeredQuestions = [];

  @override
  void initState() {
    super.initState();
    final Random random = Random();

    List<Map<String, dynamic>> allQuestions =
        List<Map<String, dynamic>>.from(sejarahKuiz[widget.bab]!.map((question) {
      return {
        'soalan': question['soalan'],
        'pilihan': List<String>.from(question['pilihan'] as List<String>),
        'jawapan': question['jawapan'],
      };
    }));

    allQuestions.shuffle(random);
    _questions = allQuestions.take(15).toList();

    for (var question in _questions) {
      (question['pilihan'] as List<String>).shuffle(random);
    }
  }

  void _answerQuestion(String selectedAnswer) {
    final isCorrect = selectedAnswer == _questions[_questionIndex]['jawapan'];
    _score += isCorrect ? 1 : 0;

    _answeredQuestions.add({
      'question': _questions[_questionIndex]['soalan'],
      'selectedAnswer': selectedAnswer,
      'correctAnswer': _questions[_questionIndex]['jawapan'],
      'isCorrect': isCorrect,
    });

    if (_questionIndex < _questions.length - 1) {
      setState(() {
        _questionIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            answeredQuestions: _answeredQuestions,
            score: _score,
            bab: widget.bab,
            tingkatan: widget.tingkatan,
          ),
        ),
      );
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Text('Kuiz ${widget.bab}'),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 20.0),
            child: _questionIndex < _questions.length
                ? Quiz(
                    answerQuestion: _answerQuestion,
                    questionIndex: _questionIndex,
                    questions: _questions,
                  )
                : Result(_score, _resetQuiz),
          ),
        ],
      ),
    );
  }
}

class Quiz extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final int questionIndex;
  final Function answerQuestion;

  const Quiz({
    super.key,
    required this.questions,
    required this.answerQuestion,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Soalan ${questionIndex + 1}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Question(questions[questionIndex]['soalan'] as String),
        ...(questions[questionIndex]['pilihan'] as List<String>).map((answer) {
          return Answer(() => answerQuestion(answer), answer);
        }).toList(),
      ],
    );
  }
}

class Question extends StatelessWidget {
  final String questionText;

  const Question(this.questionText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: Text(
        questionText,
        style: const TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class Answer extends StatelessWidget {
  final VoidCallback selectHandler;
  final String answerText;

  const Answer(this.selectHandler, this.answerText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectHandler,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        child: Text(
          answerText,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class Result extends StatelessWidget {
  final int resultScore;
  final VoidCallback resetHandler;

  const Result(this.resultScore, this.resetHandler, {super.key});

  String get resultPhrase {
    if (resultScore <= 8) return 'You are awesome and innocent!';
    if (resultScore <= 12) return 'Pretty likeable!';
    if (resultScore <= 16) return 'You are ... strange?!';
    return 'You are so bad!';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            resultPhrase,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: resetHandler,
            child: const Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }
}