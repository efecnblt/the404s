// Updated main_quiz_page.dart to dynamically fetch quiz questions from the backend
import 'package:flutter/material.dart';
import 'package:cyber_security_app/screens/quiz_screen/models/quiz_question_template.dart';
import 'package:cyber_security_app/screens/quiz_screen/quiz/results_page.dart';
import 'package:cyber_security_app/screens/quiz_screen/quiz/quiz_page.dart';

class MainQuizPage extends StatefulWidget {
  final String quizId;

  MainQuizPage({super.key, required this.quizId});

  @override
  _MainQuizPageState createState() => _MainQuizPageState();
}

class _MainQuizPageState extends State<MainQuizPage> {
  late Future<List<QuizQuestion>> _questionsFuture;
  late List<QuizQuestion> _questions;
  late List<String?> _selectedAnswers;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _questionsFuture = QuizQuestion.fetchQuestions(widget.quizId);
  }

  Future<void> _startQuiz(BuildContext context) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    _score = 0;

    for (int i = 0; i < _questions.length; i++) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
            currentQuestionIndex: i,
            question: _questions[i],
            shuffleAnswers: _questions[i].shuffleAnswers(),
            totalQuestions: _questions.length,
          ),
        ),
      ) as Map<String, dynamic>?;

      if (result != null) {
        _selectedAnswers[i] = result['selectedAnswer'];
        if (result['correct']) {
          int elapsedTime = result['timeTaken'];
          _score += 10 * (10 - elapsedTime ~/ 2);
        }
      }
    }
    _showResults(context);
  }

  void _showResults(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(
          questions: _questions,
          selectedAnswers: _selectedAnswers,
          score: _score,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Quiz Time!",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // navigate to where the course is
          },
        ),
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "An error occurred while loading the quiz.",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No questions available for this quiz.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          _questions = snapshot.data!;
          _selectedAnswers = List.filled(_questions.length, null);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Quiz Subject",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "This quiz contains ${_questions.length} questions. "
                  "It's a time-based quiz, so the faster you answer, the more points you earn. "
                  "Test your knowledge and aim for the highest score!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 40),
                Icon(
                  Icons.timer,
                  size: 100,
                  color: Colors.purple.shade400,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _startQuiz(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Start Quiz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
