import 'package:flutter/material.dart';
import 'package:notaku_sejarah/quiz_screen.dart';
import 'package:notaku_sejarah/quiz_history_screen.dart';

class TingkatanQuizScreen extends StatefulWidget {
  const TingkatanQuizScreen({super.key});

  @override
  State<TingkatanQuizScreen> createState() => _TingkatanQuizScreenState();
}

class _TingkatanQuizScreenState extends State<TingkatanQuizScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.blueGrey,
              indicatorColor: Colors.blueAccent,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Jawab Kuiz'),
                Tab(text: 'Rekod Kuiz'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTingkatanButton(context, 'Tingkatan 1'),
                      _buildTingkatanButton(context, 'Tingkatan 2'),
                      _buildTingkatanButton(context, 'Tingkatan 3'),
                      _buildTingkatanButton(context, 'Tingkatan 4', isDisabled: true),
                      _buildTingkatanButton(context, 'Tingkatan 5', isDisabled: true),
                    ],
                  ),
                ),
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final tingkatan = 'Tingkatan ${index + 1}';
                    final bool isDisabled = index >= 3; // Tingkatan 4, 5 are disabled
                    return _buildTingkatanButton(
                      context,
                      tingkatan,
                      isDisabled: isDisabled,
                      isHistory: true,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTingkatanButton(BuildContext context, String topic,
      {bool isDisabled = false, bool isHistory = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: isDisabled
            ? null
            : () {
                if (isHistory) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QuizHistoryScreen(tingkatan: topic),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(tingkatan: topic),
                    ),
                  );
                }
              },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'images/buttons/Tingkatan.png',
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    topic.split(' ')[0],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    topic.split(' ')[1],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              if (isDisabled)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: const Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}